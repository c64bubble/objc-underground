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


#import "ArmCompilerBase.h"


@implementation ArmCompilerBase

/*
 * Arm Compiler ObjC pattern matcher
 */

- (int) scanObjCMethodDeclarationIn:(FileName*)fileName withIndex:(int*)i {
	NSString*funcName;
	NSMutableArray*Args;
	struct RType* returnType;
	
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
