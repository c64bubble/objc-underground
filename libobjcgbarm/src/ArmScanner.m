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

#import "ArmScanner.h"

@implementation ArmScanner

- (int)scanFile:(FNString*)fileName withCompiler:(Compiler*)compiler {
	
	//init fileBuffer
	[fileName scan];
	[compiler scanFile:fileName];
	
	return 0;
}
/*
-(int)subCompile:(FNString*)fileName withCompiler:(Compiler*)compiler {
	[fileName readInFile];//FIXME fileName scan 
	[compiler scanFile
 */
@end