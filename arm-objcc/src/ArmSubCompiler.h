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
#import "ArmSubScanner.h"
#import "ArmCompiler.h"
#import "ClassLocator.h"

//auto- C in objC compiler or other langs with output to elf
@interface ArmSubCompiler : ArmCompiler {

	ArmSubScanner *_armSubScanner;
	NSString *_compilerShellCommand;
}

- (ArmSubCompiler*)ctor:(NSString*)command;

- (void)compile:(FileName*)fileName;//override for other compiler command
- (void)scanFile:(FileName*)fileName;
- (int)scanFileRec:(FileName*)fileName;
- (int)subCompilable:(FileName*)fileName;
- (int)subCompilableObjCSourceFile:(FileName*)fileName;
//pure C in method definitions ->
- (int)subCompilableRec:(FileName*)pstr withIndex:(int*)idx;
//non-pure C but objC in method definitions ->
- (int)compileRec:(FileName*)fileName;
- (int)compileObjC:(int *)idx;

- (int)compilablesource:(FileName*)fileName;

/////////- (int) scanObjCMethodDeclarationIn:(FileName*)pstr withIndex:(int*)i fino:(int)fno;
////////- (int) scanDeclarationForType:(NSString*)pstr withIndex:(int*)i returns:(struct RType*)rType;
////////- (int) scanDeclarationForFuncName:(NSString*)pstr withIndex:(int*)i returns:(NSString*)rName;
////////- (int) scanDeclarationForArgs:(NSString*)pstr withIndex:(int*)i returns:(NSMutableArray*)rArgs;

- (int) writeDeclarationWithReturnTypeToHeader:(struct RType*)returnType withFuncName:(NSString*)funcName andArgs:(NSMutableArray*)Args onfno:(int)fno;

@end
