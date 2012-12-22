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

- (void)compile:(FNString*)fileName {
	
	_armScanner = [ ArmScanner new ];
	[ _armScanner scanFile:fileName withCompiler: self ];
	
	return;
}

- (void) scanFile:(FNString*)fileName {

	[self scanFileRec:fileName];
	
}

- (int)scanFileRec:(FNString*)fileName {
	int e = -1;
	//ask if buffer has right block scopes syntax
	if ((e = [self compilable:fileName]) < 0)
		[fileName addError:e];
	
	return 0;
}

- (int)compilable:(FNString*)fileName {

	if ([fileName isheader]) {
		return [self compilableheader:fileName];
	} else if ([fileName issource]) {
		return [self compilablesource:fileName];
	} else {
		return UNKNOWNFILEFORMAT;//error
	}
	
	return 0;
	
}

- (int)compilableheader:(FNString*)fileName {
	
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

- (int)compilablesource:(FNString*)fileName {
	
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

@end
