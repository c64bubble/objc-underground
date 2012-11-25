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


#import "ArmCompiler.h"


@implementation ArmCompiler

- (void)compile:(FileName*)fileName {
	
	_armScanner = [ ArmScanner new ];
	[ _armScanner scanFile:fileName withCompiler: self ];
	
	return;
}

- (void) scanFile:(FileName*)fileName {

	[self scanFileRec:fileName];
	
}

- (int)scanFileRec:(FileName*)fileName {
	int e = -1;
	//ask if buffer has right block scopes syntax
	if ((e = [self compilable:fileName]) < 0)
		[fileName addError:e];
	
	return 0;
}

- (int)compilable:(FileName*)fileName {

	if ([fileName isheader]) {
		return [self compilableheader:fileName];
	} else if ([fileName issource]) {
		return [self compilablesource:fileName];
	} else {
		return UNKNOWNFILEFORMAT;//error
	}
	
	return 0;
	
}

- (int)compilableheader:(FileName*)fileName {
	
	FileBuffer *buffer = [fileName buffer];//reverse buffer
	NSString *str = @"";
	int i = -1;
	int ti = 0;
	
	while (++i < [buffer length]) {
		
		if ([buffer characterAtIndex:i] != ' ' 
			 ||
			 [buffer characterAtIndex:i] != '\t'
			 ||
			[buffer characterAtIndex:i] != '\n') {
			
			int j = -1;	
			while (++j < 4) {
				str += [buffer characterAtIndex:j];
			}
		
			//FIXME scan for common C functions after '@end'
			
			if (str != @"dne@")//\n@end
				return NOENDOFINTERFACE;
		
			i += j;
		}
	}
	
	ti = i;
	
	//i--;//NOTE
	int newlineIndex = i;
	int braceIndex = i;
	int braceIndex2 = i;
	int nsbrace = 0;//number of skips before brace
	int semicolonIndex = i;
	newlineIndex = [self searchFor:buffer char:'\n' startingAt:i];
	braceIndex = [self searchFor:buffer char:'}' startingAt:i numberOfSkips:&nsbrace];
	braceIndex2 = [self searchFor:buffer char:'{' startingAt:i];
	semicolonIndex = [self searchFor:buffer char:';' startingAt:i];
	//i++;//skip newline
	
	switch (newlineIndex-i){
		case 0:{
			switch (braceIndex-i-nsbrace){
				case 1:{
					[fileName addStatus:NOMETHODSDECLAREDINCLASS];
					switch (braceIndex2 > braceIndex) {
						case 0:{
							[fileName addError:INTERFACESTARTBRACENOTFOUND];
							break;
						}
						case 1:{
							if ((i = [self searchFor:buffer string:@"ecafretni@" startingAt:braceIndex2]) == NOTFOUND) {
								[fileName addError:INTERFACEWORDNOTFOUND];
							}
							
							break;
						}
						default:{
							break;
						}
					}
					break;
				}
				default:{
					//switch (
					break;
				}
			}	
			break;
		}
		default:{
			break;
		}
	}
	
	//search start from right brace index (interface definition)
	i = ti-1;
	while (++i < braceIndex) {
		int methodsemicolonindex = [self searchFor:buffer char:';' startingAt:i];
		int methoddashindex = [self searchFor:buffer char:'-' startingAt:i];
		
		if (methodsemicolonindex && methoddashindex == NOTFOUND) {
			[fileName addError:INTERFACEINVALIDMETHODDEFINITION];
		}
		else if (methodsemicolonindex < methoddashindex) {
			
			NSString *methodstr = [buffer stringFromIndex:methodsemicolonindex toIndex:methoddashindex];
			
			//NOTE: errorcodes can be managed with pure C agent code (as not every system supports objC or C++
			int *errororstatuscodes = [self compilableInterfaceMethod:[self reverse:methodstr]];//NOTE be string
			while (errororstatuscodes != (int*)0 && sizeof(errororstatuscodes) > 0) {
			
				switch (*errororstatuscodes++) {
				case INTERFACERETURNTYPEISNOTNATIVE:{
					[fileName addStatus:NONATIVERETURNTYPE];//NOTE status, needs object locator in next pass
					break;
				}
				default:{
					break;
				}
				}
			}
			i = methoddashindex;
			continue;
		} 
		
	}
	
	return 0;
}

- (int)compilablesource:(FileName*)fileName {
	
	//subclass responsability
	
	return 0;
}

- (int) searchFor:(NSString*)buffer char:(unichar)c startingAt:(int)startidx {
		int i = -1+startidx;
		while (++i < [buffer length]) {
			if ([buffer characterAtIndex:i] == c)
				return i;
		}
		
		return NOTFOUND;
}
	
- (int) searchFor:(NSString*)buffer char:(unichar)c startingAt:(int)startidx numberOfSkips:(int*)skips {
	int i = -1+startidx;
	while (++i < [buffer length]) {
		if ([buffer characterAtIndex:i] == c)
			return i;
		if ([buffer characterAtIndex:i] == '\n'//FIXME put in method
			||
			[buffer characterAtIndex:i] == '\t'
			||
			[buffer characterAtIndex:i] == ' ')
			*skips++;
	}

	return NOTFOUND;
}

- (int) searchFor:(NSString*)buffer string:(NSString*)s startingAt:(int)startidx {
	int i = -1+startidx;
	NSString *str = @"";
	
	while (++i < [buffer length]) {
	
		if ([buffer characterAtIndex:i] == ' '//FIXME put in method
			||
			[buffer characterAtIndex:i] == '\t'
			||
			[buffer characterAtIndex:i] == '\n') {
				str = @"";
				continue;
		}
		
		str += [buffer characterAtIndex:i];
		
		if (str == s)
			return i;
		
	}
	
	return NOTFOUND;
}

- (NSString*)reverse:(NSString*)str {
	NSString *reversestr = @"";
	
	int l = [str length];
	int i = 0;
	while (i++ < l){
		reversestr += [str characterAtIndex:i];
	}
	
	return reversestr;
}				 
			 
- (int*) compilableInterfaceMethod:(NSString*)methodstr {

	NSString* tmethodstr = methodstr;
	int *erroris = [self compilableCheckReturnType: tmethodstr];
	int *errorisstart = erroris;
	
	int *erroris2 = (int*)[self compilableCheckFunctionName: tmethodstr];
	memcpy((void*)erroris,(void*)(erroris2-errorisstart),sizeof(erroris2)-sizeof(erroris));

	//repeat for multiple argument methods
	while ([tmethodstr length] > 0) {
		
		
		int * erroris3 = (int*)[self compilableCheckFunctionArgs: tmethodstr];
		memcpy((void*)erroris,(void*)(erroris3-erroris2),sizeof(erroris3)-sizeof(erroris2));
	
		if ([tmethodstr length] > 0) {
			int *erroris4 = (int*)[self compilableCheckFunctionName: tmethodstr];
			memcpy((void*)erroris,(void*)(erroris4-erroris3),sizeof(erroris4)-sizeof(erroris3));
		}
	}
		
	return errorisstart;
	
}

- (int*)compilableCheckReturnType:(NSString*)methodstr {
	int *erroris = (int*)malloc(1024*sizeof(int));//FIXME C progr disease
	ParseString *tpmethodstr = [[ParseString new] ctor:methodstr];
	ParseString *tpstr = [[ParseString new] ctor:@""];
	int i = -1;
	while (++i < [methodstr length]) {
		if ([tpmethodstr isSkipCharacterAtIndex:i]) {
			continue;
		} else {
			tpstr += [methodstr characterAtIndex:i];
			int skipi;
			if ((skipi = [[[ParseString new] ctor:[tpstr string]] isTypedWell]) > 0) {
				methodstr = [tpmethodstr substringAtIndex:skipi];
				free(erroris);
				erroris = (int*)0;
				return erroris;
				
			}
		}
	
	}
								
	methodstr = @"";
	erroris[0] = INTERFACERETURNTYPEISNOTNATIVE;//NOTE status
	erroris++;
	return erroris;//return errors
			
}
	
- (int*)compilableCheckFunctionName:(NSString*)methodstrpart {
	int *erroris = (int*)malloc(1024*sizeof(int));
	int i = -1;
	ParseString*tpmethodstrpart = [[ParseString new] ctor:methodstrpart];
	
	while (++i < [methodstrpart length]) {
		if ([methodstrpart characterAtIndex:i] == '?'
			||
			[methodstrpart characterAtIndex:i] == '/'
			||
			[methodstrpart characterAtIndex:i] == '\\'
			||
			[methodstrpart characterAtIndex:i] == '\n'
			||
			[methodstrpart characterAtIndex:i] == ',') {
			methodstrpart = @"";
			erroris[0] = INTERFACEFUNCTIONNAMEILLEGALCHARACTER;
			methodstrpart = [tpmethodstrpart substringAtIndex:[methodstrpart length]];//FIXME length index
			return erroris;//return error
		} else if ([methodstrpart characterAtIndex:i] == ';') {
			free(erroris);
			erroris = (int)0;
			methodstrpart = [tpmethodstrpart substringAtIndex:i];
			return erroris;//set status to no args?
		} else if ([methodstrpart characterAtIndex:i] == ':') {
			free(erroris);
			erroris = (int)0;
			methodstrpart = [tpmethodstrpart substringAtIndex:i];
			return erroris;//set status to has args?
		}
		
	}
	
	return erroris;
	
}

- (int*)compilableCheckFunctionArgName:(NSString*)methodstrpart {
	return [self compilableCheckFunctionName:methodstrpart];
}

- (int*)compilableCheckFunctionArgs:(NSString*)methodstrpart {
	int *erroris = (int*)malloc(1024*sizeof(int));
	int i = 0;
	
	ParseString* ptstr = [[ParseString new] ctor:methodstrpart];
	i = [ptstr skipSkips:i];
	
	while (i < [methodstrpart length]) {
		if ([methodstrpart characterAtIndex:i++] == '(') {
			break;
		}
	}
	if (i >= [methodstrpart length]) {
		erroris[0] = INTERFACEMETHODNOARGUMENTTYPE;
		return erroris;
	}
	
	i = [ptstr skipSkips:i];
	while (i < [methodstrpart length]) {
		if ([methodstrpart characterAtIndex:i++] == ')') {
			break;
		}
	}
	
	erroris = [self compilableCheckFunctionArgName:[ptstr substringAtIndex:i]];//checks for valid argument characters
	return erroris;
	
}

/*
 * Arm Compiler ObjC pattern matcher
 */

//FIXME for source files -> compilable method
- (int) scanObjCMethodDeclarationIn:(FileName*)fileName withIndex:(int*)i fino:(int)fno{
	struct RType* returnType;
	NSString*funcName;
	NSMutableArray*Args;
	
	int oldidx = *i;
	
	while(++(*i) < [[fileName buffer] length]) {
		if ([[fileName buffer] characterAtIndex:(*i)] == '(') {
			returnType = NULL;
			
			
			if ([self scanDeclarationForType:[fileName buffer] withIndex:i returns:returnType] < 0) {
				*i = oldidx; 
				continue;
				////return SUBCOMPILEINVALIDRETURNTYPE;
			}
			if ([self scanDeclarationForFuncName:[fileName buffer] withIndex:i returns:funcName] < 0) {
				*i = oldidx;
				continue;
				////return SUBCOMPILEINVALIDFUNCNAME;
			}
			if ([self scanDeclarationForArgs:[fileName buffer] withIndex:i returns:Args] < 0) {
				*i = oldidx; 
				continue;
				////return SUBCOMPILEINVALIDARGS;
			}
			
			if (oldidx == *i)
				return SUBCOMPILEINVALIDFUNCDEF;
		}
	}
	
	[self writeDeclarationWithReturnTypeToHeader:returnType withFuncName:funcName andArgs:Args onfno:fno];
	
	return 0;
	
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

- (int) scanDeclarationForType:(NSString*)pstr withIndex:(int*)i returns:(struct RType*)rType{
	
	NSString*is;
	int subcount;
	while ([pstr characterAtIndex:*i] != ')' || subcount > 0) {
		
		if ([pstr characterAtIndex:*i] == '(') //scan for nested (((())) types e.g. function pointers
			subcount++;
		else if ([pstr characterAtIndex:*i] == ')') 
			subcount--;

		
		if (*i > [pstr length]) {
			rType = (struct RType*)malloc(sizeof(struct RType));
			rType->rtypestring = @"";
			rType->id = -1;
			return -1;
		}
		is += [pstr characterAtIndex:*i];
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
		return -1;
	}
		
	//skip whitespace
	for ( ;[pstr characterAtIndex:*i] == ' '
		   || 
		   [pstr characterAtIndex:*i] == '\t'
		   || 
		 [pstr characterAtIndex:*i] == '\n'; )
		(*i)++;
	
	rType = (struct RType*)malloc(sizeof(struct RType));
	rType->rtypestring = is;
	rType->id = r2 % INT_MAX;//--FIXME repeated ids
	
	return 0;
	
}

		  
- (int) scanDeclarationForFuncName:(NSString*)pstr withIndex:(int*)i returns:(NSString*)rName{
	NSString*is;
	while ([pstr characterAtIndex:*i] != '(') {
				  
		if (*i > [pstr length]) {
			rName = @"";
			return -1;
		}
		is += [pstr characterAtIndex:*i];
	}
			  
			  
	rName = is;
	return 0;	  
}
		  

- (int) scanDeclarationForArgs:(NSString*)pstr withIndex:(int*)i returns:(NSMutableArray*)rArgs{
	
	NSMutableArray*lis;
	struct RType*is;
	while ([pstr characterAtIndex:*i] != '{') {
		
		while ([pstr characterAtIndex:*i] != '(') 
			;
		
		if (*i > [pstr length]) {
			rArgs = lis;
			return 0;
		}
		if ([self scanDeclarationForType:pstr withIndex:i returns:is] < 0) {
			rArgs = lis;
			return -1;
		}
		else {
			//scan for argname
			NSString*argname;
			while ((*i) < [pstr length]) {
				if ([pstr characterAtIndex:*i] != ' ' || [pstr characterAtIndex:*i] != ')') {
					argname += [pstr characterAtIndex:*i];
				} else {
					is->rtypestring = [NSString stringWithFormat:@"%@/%@",is,argname];
					break;
				}
				(*i)++;
			}
		}	
		
		is += [pstr characterAtIndex:*i];
		
		//skip whitespace
		while ([pstr characterAtIndex:*i] == ' ' 
			   || 
			   [pstr characterAtIndex:*i] == '\t' 
			   || 
			   [pstr characterAtIndex:*i] == '\n')
			(*i)++;
		
		//FIXME rtypestring
		if ([_classLocator locateType:[[TypeName init] ctor:-1 withTypeName:is->rtypestring]] < 0) {
			[lis addObject:is->rtypestring];//--FIXME rtypestring
		}
	}
	
	return 0;
}

@end
