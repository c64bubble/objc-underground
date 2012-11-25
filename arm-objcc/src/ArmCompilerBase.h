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


#import <Cocoa/Cocoa.h>
#import "Compiler.h"
#import "ClassLocator.h"
#import "FileName.h"

typedef struct RType { int id; NSString *rtypestring; } RType;

//file status & error ints 
enum { SUBCOMPILENOT = -2,
		SUBCOMPILENOMKSTEMP = -3,
		SUBCOMPILENOFDOPEN = -4,
		SUBCOMPILECANNOTFORK = -5,
		SUBCOMPILECANNOTLOCK = -6,
		SUBCOMPILECANNOTUNLOCK = -7,
		SUBCOMPILEINVALIDRETURNTYPE = -8,
		SUBCOMPILEINVALIDFUNCNAME = -9,
		SUBCOMPILEINVALIDARGS = -10,
		SUBCOMPILEINVALIDFUNCDEF = -11,

		OBJCHEADERCOMPILE = -100,
		OBJCSOURCECOMPILE = -101,
		PURECCOMPILE = -102,
};

@interface ArmCompilerBase : Compiler {

	ClassLocator *_classLocator;
	
}

- (int) scanObjCMethodDeclarationIn:(FileName*)fileName withIndex:(int*)i;
- (int) scanDeclarationForType:(NSString*)pstr withIndex:(int*)i returns:(struct RType*)rType;
- (int) scanDeclarationForFuncName:(NSString*)pstr withIndex:(int*)i returns:(NSString*)rName;
- (int) scanDeclarationForArgs:(NSString*)pstr withIndex:(int*)i returns:(NSMutableArray*)rArgs;

- (int) writeDeclarationWithReturnTypeToHeader:(struct RType*)returnType withFuncName:(NSString*)funcName andArgs:(NSMutableArray*)Args onfno:(int)fno;
@end
