/*
 Copyright (C) Johan Ceuppens 2012
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#import "ArmSubCompiler.h"
#include <unistd.h>
#include <stdlib.h>

@implementation ArmSubCompiler

- (ArmSubCompiler*)ctor:(NSString*)command {
	
	_compilerShellCommand = command;
	
	return self;

}

-(int)errorset  {

	return  ([_errorsubcompiler errorset]);

}

- (void)compile:(FNString*)fileName {
	//override for other sub compiler
	if ([fileName isCSource] 
		|| 
		[fileName isCHeader]) {
		_compilerShellCommand = @"arm-eabi-gcc";
	}
	_armSubScanner = [ ArmSubScanner new ];
	[ _armSubScanner scanFile:fileName withCompiler: self ];
	
	return;
}

- (void) scanFile:(FNString*)fileName {
	
	[self scanFileRec:fileName];
	
}

- (int)scanFileRec:(FNString*)fileName {
	int status = -1;
	int error = -1;
	//scan for pure C code
	if (error = [self subCompilable:fileName]) {
		if (error == 0) {
			status = PURECCOMPILE;
			[fileName addStatus:status];
		} else {
			[fileName addError:error];
		}
	} else if (error = [self subCompilableObjCSourceFile:fileName]) {
		if (error == 0) {
			status = OBJCHEADERCOMPILE;
			[fileName addStatus:status];
		} else {
			[fileName addError:error];
		}
	}
	
	return status;
	
}

- (int)subCompilable:(FNString *)fileName {
	//scan for pure C code
	FILE * fp;
	
	if ((fp = popen((const char *)[NSString stringWithFormat:@"%@/%@/%@", _compilerShellCommand, " -c ", fileName], "r+")) == (FILE *)0) {
		[fileName addError:SUBCOMPILENOT];
		return -1;
	}
	
	FILE *fp2;
	if ((fp2 = fopen((char *)fileName, "w")) < 0) {
		[fileName addError:SUBCOMPILENOT];
		return -1;
	}
	//FIXME flock
	
	int i = -1;
	NSString*s;
	char c;
	while (read(fileno(fp),&c,1) != EOF) {
		if (s == @"error") {
			return -1;//file is not pure C
		} else if (c == ' '
				   ||
				   c == '\t'
				   ||
				   c == '\n') {
			s = @"";
			continue;
		} else {		
			s += [[fileName buffer] characterAtIndex:i];
			write(fileno(fp2), &c, 1);
		}
	}
	
	return 0;//file is pure C
}

- (int) subCompilableObjCSourceFile:(FNString*)fileName {
	int idx = -1;
	
	int len = [[fileName buffer] length];
	
	for ( idx = 0; idx < len; idx++ ) {
		idx = [self subCompilableRec:(FNString*)fileName withIndex:idx];
		//and again search for another objC function definition	

		if ([self errorset]) {
			[fileName addErrors:_errorsubcompiler];
			[_errorsubcompiler clear];
		}
	}
	
	return 0;//FIXME
}

- (int)subCompilableRec:(FNString*)pstr withIndex:(int)idx{
	//compile pure C code in function definitions to ObjC source file which is compiled by compileRec method
	int i = idx;
	
	int fno;
	if ((fno = mkstemp("/tmp/bovisbuves.c")) < 0) {
		[self erroradd: SUBCOMPILENOMKSTEMP];
		idx = i;
		return idx;//SUBCOMPILENOMKSTEMP;
	}
	
    if (flock(fno, LOCK_SH) < 0) {
		idx = i;
		return idx;//SUBCOMPILECANNOTLOCK;
	}
	
	NSString*is;
	int j = i;
	
lable1:
	
	while (++i && ([[pstr buffer] characterAtIndex:i] != '#')) {
		
		if (i >= [[pstr buffer] length]) {
			i = j;
			goto lable2;
		}
		
		is += [[pstr buffer] characterAtIndex:i];
		if (is == @"#include") {
			while (++i && ([[pstr buffer] characterAtIndex:i] != '<' || [[pstr buffer] characterAtIndex:i] != '"')) {
				is += [pstr characterAtIndex:i];
				if ([[pstr buffer] characterAtIndex:i] == '>' || [[pstr buffer] characterAtIndex:i] == '"') {//e.g. #include <stdarg.h"
					write(fno, (char *)is, [is length]);
					pid_t pid1;
					if ((pid1 = fork()) < 0) {
						idx = i;
						return idx;//SUBCOMPILECANNOTFORK;
					} else if (pid1 == 0) {
						is = @"";
						goto lable1;
					} else {
						goto lable2;
					}
				}
			}
		}
	}
	
lable2:
	
	i = j;
	
	while (++i && [[pstr buffer] characterAtIndex:i] != '-')//--FIXME - minus in C code && nested ((())) 
		;
	//function header (of definition
	idx = i;
	int declstatus = [self scanObjCMethodDeclarationIn:pstr withIndex:idx fino:fno];
	
	//faulty declaration ?
	if (declstatus < 0) {
		idx = i;
		return idx;//SUBCOMPILENOT;
	}

	//block start
	write(fno,"{",1);
	write(fno,"\n",1);
	
	//FIXME following code compiles the following method
	while (++i && ([[pstr buffer] characterAtIndex:i] != '{'))
		;

		
	while (++i && [[pstr buffer] characterAtIndex:i] != '}')
		if (i+1 >= [[pstr buffer] length]) {
			close(fno);
			idx = i;
			return idx;//SUBCOMPILENOT;
		} else {
			NSString*s;
			s += [pstr characterAtIndex:i];
			write(fno, [NSString stringWithFormat:@"%@", [pstr characterAtIndex:i]],1);
		}
	
	
	FILE *fp;
	//FIXME -I./PWD/
	if ((fp = popen((const char *)[NSString stringWithFormat:@"%@/%@", _compilerShellCommand, " -c /tmp/bovisbuves.c"], "r+")) == (FILE *)0) {
		idx = i;
		return idx;//SUBCOMPILENOT;
	}
	if (flock(fileno(fp), LOCK_SH) < 0) {
		idx = i;
		return idx;//SUBCOMPILECANNOTUNLOCK;
	}
	//try to subcompile
	FNString*subFileName = [FNString new];
	subFileName = (FNString*)@"/tmp/bovisbuves.c";
	[subFileName readInFile];
	[self subCompilable:subFileName];
	
	//close function block
	write(fno, "}", 1);

	if (flock(fileno(fp), LOCK_UN) < 0) {	
		idx = i;
		return idx;//SUBCOMPILECANNOTUNLOCK;
	}
	if (flock(fno, LOCK_UN) < 0) {
		idx = i;
		return idx;//SUBCOMPILECANNOTUNLOCK;
	}
	
	fclose(fp);

	idx = i;
	return idx;
}

//FIXME for source files -> compilable method
- (int) scanObjCMethodDeclarationIn:(FNString*)fileName withIndex:(int)idx fino:(int)fno{
	struct RType* returnType;
	NSString*funcName;
	NSMutableArray*Args;
	
	int oldidx = idx;
	
	while(++idx < [[fileName buffer] length]) {
		if ([[fileName buffer] characterAtIndex:idx] == '(') {
			returnType = NULL;
			
			idx = [self scanDeclarationForType:[fileName buffer] withIndex:idx returns:returnType];
			if ([self errorset]) {
				[_errorsubcompiler addError:SUBCOMPILEINVALIDRETURNTYPE];
				idx = oldidx; 
				continue;
				////return SUBCOMPILEINVALIDRETURNTYPE;
			}
			idx = [self scanDeclarationForFuncName:[fileName buffer] withIndex:idx returns:funcName];
			if ([self errorset]) {
				[_errorsubcompiler addError:SUBCOMPILEINVALIDFUNCNAME];
				idx = oldidx;
				continue;
				////return SUBCOMPILEINVALIDFUNCNAME;
			}
			idx = [self scanDeclarationForArgs:[fileName buffer] withIndex:idx returns:Args]; 
			if ([self errorset]) {
				[_errorsubcompiler addError:SUBCOMPILEINVALIDARGS];
				idx = oldidx; 
				continue;
				////return SUBCOMPILEINVALIDARGS;
			}
			
			if (oldidx == idx)
				[_errorsubcompiler addError:SUBCOMPILEINVALIDFUNCDEF];
				return idx;//SUBCOMPILEINVALIDFUNCDEF;
		}
	}
	
	[self writeDeclarationWithReturnTypeToHeader:returnType withFuncName:funcName andArgs:Args onfno:fno];
	
	return idx;
	
}

- (int) writeDeclarationWithReturnTypeToHeader:(struct RType*)returnType withFuncName:(NSString*)funcName andArgs:(NSMutableArray*)Args onfno:(int)fno {

	write(fno, (char *)returnType->rtypestring, strlen((char *)returnType->rtypestring));
	write(fno, " ", 1);
	write(fno, (char *)funcName, strlen((char *)funcName));
	write(fno, "(", 1);
	int j = -1;
	while (++j < [Args count]-1) {
		write(fno, (char *)[Args objectAtIndex:j], strlen((char *)[Args objectAtIndex:j]));
		write(fno, (char *)", ",2);
	}
	write(fno, (char *)[Args objectAtIndex:j], strlen((char *)[Args objectAtIndex:j]));
	write(fno, ")", 1);//FIXME ") {"
	
	return 0;

}

- (int) scanDeclarationForType:(NSString*)pstr withIndex:(int)idx returns:(struct RType*)rType{
	
	NSString*is;
	int subcount;
	while ([pstr characterAtIndex:idx] != ')' || subcount > 0) {
		
		if ([pstr characterAtIndex:idx] == '(') //scan for nested (((())) types e.g. function pointers
			subcount++;
		else if ([pstr characterAtIndex:idx] == ')') 
			subcount--;

		
		if (idx > [pstr length]) {
			rType = (struct RType*)malloc(sizeof(struct RType));
			rType->rtypestring = @"";
			rType->id = -1;
			return -1;
		}
		is += [pstr characterAtIndex:idx];
	}
	
	long r = random();
	long r2 = random();
	long r3 = r2;
	long result = 0;
	
	if ([_classLocator locateType:[[TypeName init] ctor:r withTypeName:is]] < 0) {
		rType = (struct RType*)malloc(sizeof(struct RType));
		rType->rtypestring = @"";
		
		//make number string for id
		for ( ;; ) {
			
			r3 = r2 % 2;
			r2 -= (r2 % 10);//base 10
			
			result += r3;
			
		}
		
		rType->id = result;
		//rType->id = r2 % INT_MAX;//--FIXME repeated ids
		return idx;//-1;
	}
		
	//skip whitespace
	for ( ;[pstr characterAtIndex:idx] == ' '
		   || 
		   [pstr characterAtIndex:idx] == '\t'
		   || 
		 [pstr characterAtIndex:idx] == '\n'; )
		idx++;
	
	rType = (struct RType*)malloc(sizeof(struct RType));
	rType->rtypestring = is;
	rType->id = r2 % INT_MAX;//--FIXME repeated ids
	
	return idx;//0;
	
}

		  
- (int) scanDeclarationForFuncName:(NSString*)pstr withIndex:(int)idx returns:(NSString*)rName{
	NSString*is;
	while ([pstr characterAtIndex:idx] != '(') {
				  
		if (idx > [pstr length]) {
			rName = @"";
			return idx;//-1;
		}
		is += [pstr characterAtIndex:idx];
	}
			  
			  
	rName = is;
	return 0;	  
}
		  

- (int) scanDeclarationForArgs:(NSString*)pstr withIndex:(int)idx returns:(NSMutableArray*)rArgs{
	
	NSMutableArray*lis;
	struct RType*is;
	while ([pstr characterAtIndex:idx] != '{') {
		
		while ([pstr characterAtIndex:idx] != '(') 
			;
		
		if (idx > [pstr length]) {
			rArgs = lis;
			return idx;//0;
		}
		if ([self scanDeclarationForType:pstr withIndex:idx returns:is] < 0) {
			rArgs = lis;
			return idx;//-1;
		}
		else {
			//scan for argname
			NSString*argname;
			while ((idx) < [pstr length]) {
				if ([pstr characterAtIndex:idx] != ' ' || [pstr characterAtIndex:idx] != ')') {
					argname += [pstr characterAtIndex:idx];
				} else {
					is->rtypestring = [NSString stringWithFormat:@"%@/%@",is,argname];
					break;
				}
				idx++;
			}
		}	
		
		is += [pstr characterAtIndex:idx];
		
		//skip whitespace
		while ([pstr characterAtIndex:idx] == ' ' 
			   || 
			   [pstr characterAtIndex:idx] == '\t' 
			   || 
			   [pstr characterAtIndex:idx] == '\n')
			idx++;
		
		//FIXME rtypestring
		if ([_classLocator locateType:[[TypeName init] ctor:-1 withTypeName:is->rtypestring]] < 0) {
			[lis addObject:is->rtypestring];//--FIXME rtypestring
		}
	}
	
	return idx;//0;
}

- (int)compilablesource:(FNString*)fileName {
	//subcompile(rec)
	int status = [self subCompilable:fileName];
	if (status < 0) {
		//compile pure C code in function definitions (FIXME)
		return [self subCompilableObjCSourceFile:fileName];
	} else {
		return status;
	}
}


//compile objC code in file fileName
- (int)compileRec:(FNString*)fileName {

	if ([fileName readInFile] < 0)
		return -1;
	
	
	NSString *fileContents = [fileName stringFromIndex:0 toIndex:[[fileName buffer] length]];
							  
	int i = -1;
							  
	if (i < [fileContents length]) {
		while (++i && [fileContents characterAtIndex:i] != '-')//--FIXME - minus in C code && nested ((())) 
			;
		
		//FIXME flock
		FILE *fp = fopen("/tmp/bovisbuvesXXX", "w+");
		int fno = fileno(fp);
		//function header (of definition
		int i = [self scanObjCMethodDeclarationIn:fileName withIndex:i fino:fno];
							  
		//faulty declaration ?
		if ([self errorset]) {//never reached
			return SUBCOMPILENOT;
		}
	
		while (++i && [fileContents characterAtIndex:i] != '{')//--FIXME - minus in C code && nested ((())) 
			;
		
		i = [self compileObjC:i];
	}
	
	return i;
							  
}

- (int)compileObjC:(int)idx {
	return 0;					  
}
							  
- (void)erroradd:(int)ei {

	[_errorsubcompiler addError: ei];	

}


@end
