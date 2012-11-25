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
#import "ArmCompiler.h"
#import "ArmObjCScanner.h"
#import "ClassLocator.h"
#import "Stack.h"
//file status & error ints 
enum { COMPILENOT = -2,
};

@interface ArmObjCCompiler : ArmCompiler {

	Stack _stack;

}

- (ArmObjCCompiler*)ctor;
- (int)compile:(FileName*)fileName;//override for other compiler command

@end
