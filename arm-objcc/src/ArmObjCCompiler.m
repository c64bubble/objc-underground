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
#import "ArmObjCCompiler.h"
#import "CharBracket.h"
#include <unistd.h>
#include <stdlib.h>

@implementation ArmObjCCompiler

- (ArmObjCCompiler*)ctor {
	return self;

}

- (int)compile:(FileName*)fileName {

	[fileName readInFile];

	FileBuffer* filebuf = [fileName buffer];
	NSString*buf = [filebuf stringFromIndex:0 toIndex:[filebuf length]];

	char c = '\0';
	int i = 0;
	while ((c = [buf characterAtIndex:i++]) {
		if (c != '-') {
			continue;
		}
		if (c == '-') {
			[self scanObjCMethodDeclarationIn:fileName withIndex:&i];
			[self compileObjC:fileName atIndex:&i];
		}
	}

	

	return 0;

}

- (int)compileObjC:(FileName*)fileName atIndex:(int*)i {

	[fileName readInFile];

	FileBuffer* filebuf = [fileName buffer];
	NSString*buf = [filebuf stringFromIndex:*i toIndex:[filebuf length]];

	char c = '\0';
	int i = 0;
	while ((c = [buf characterAtIndex:i++]) {
		if (c == '[') {
			[_stack push:[CharBracket ctor]];	
		}
	}
}
	
@end
