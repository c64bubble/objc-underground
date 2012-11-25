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

- (void)compile:(FileName*)fileName {
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

- (void) scanFile:(FileName*)fileName {
	
	[self scanFileRec:fileName];
	
}

- (int)scanFileRec:(FileName*)fileName {
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

- (int)subCompilable:(FileName *)fileName {
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

- (int) subCompilableObjCSourceFile:(FileName*)fileName {
	int idx = -1;
	
	int len = [[fileName buffer] length];
	
	for ( idx = 0; idx < len; idx++ ) {
		[self subCompilableRec:(FileName*)fileName withIndex:&idx];
		//and again search for another objC function definition	
	}
	
	return 0;//FIXME
}

- (int)subCompilableRec:(FileName*)pstr withIndex:(int*)idx{
	//compile pure C code in function definitions to ObjC source file which is compiled by compileRec method
	int i = *idx;
	
	int fno;
	if ((fno = mkstemp("/tmp/bovisbuves.c")) < 0) {
		*idx = i;
		return SUBCOMPILENOMKSTEMP;
	}
	
    if (flock(fno, LOCK_SH) < 0) {
		*idx = i;
		return SUBCOMPILECANNOTLOCK;
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
						*idx = i;
						return SUBCOMPILECANNOTFORK;
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
	int declstatus = [self scanObjCMethodDeclarationIn:pstr withIndex:&i fino:fno];
	
	//faulty declaration ?
	if (declstatus < 0) {
		*idx = i;
		return SUBCOMPILENOT;
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
			*idx = i;
			return SUBCOMPILENOT;
		} else {
			NSString*s;
			s += [pstr characterAtIndex:i];
			write(fno, [NSString stringWithFormat:@"%@", [pstr characterAtIndex:i]],1);
		}
	
	
	FILE *fp;
	//FIXME -I./PWD/
	if ((fp = popen((const char *)[NSString stringWithFormat:@"%@/%@", _compilerShellCommand, " -c /tmp/bovisbuves.c"], "r+")) == (FILE *)0) {
		*idx = i;
		return SUBCOMPILENOT;
	}
	if (flock(fileno(fp), LOCK_SH) < 0) {
		*idx = i;
		return SUBCOMPILECANNOTUNLOCK;
	}
	//try to subcompile for C code
	FileName*subFileName = [FileName new];
	subFileName = (FileName*)@"/tmp/bovisbuves.c";
	[subFileName readInFile];
	[self subCompilable:subFileName];
	
	//close function block
	write(fno, "}", 1);

	if (flock(fileno(fp), LOCK_UN) < 0) {	
		*idx = i;
		return SUBCOMPILECANNOTUNLOCK;
	}
	if (flock(fno, LOCK_UN) < 0) {
		*idx = i;
		return SUBCOMPILECANNOTUNLOCK;
	}
	
	fclose(fp);

	*idx = i;
	return 0;
}



- (int)compilablesource:(FileName*)fileName {
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
- (int)compileRec:(FileName*)fileName {

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
		int declstatus = [self scanObjCMethodDeclarationIn:fileName withIndex:&i fino:fno];
							  
		//faulty declaration ?
		if (declstatus < 0) {//never reached
			return SUBCOMPILENOT;
		}
	
		while (++i && [fileContents characterAtIndex:i] != '{')//--FIXME - minus in C code && nested ((())) 
			;
		
		[self compileObjC:&i];
	}
	
	return 0;
							  
}

- (int)compileObjC:(int*)idx {
	return 0;					  
}
							  
@end
