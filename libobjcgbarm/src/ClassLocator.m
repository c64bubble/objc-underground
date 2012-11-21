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
#import "ClassLocator.h"
#import "TypeName.h"

@implementation ClassLocator

- (int) isa: (TypeName*)typename in: (GBAObject *)gbao {
	
	return [gbao isa:typename];
	
}

- (int) locateType:(TypeName*)type {
	
	if ([self isNativeType:type])
		return 0;
	if ([self isClassType:type])
		return 1;

	return -1;
}

- (int) isNativeType:(TypeName*)t {
	if ([t string] == @"void" || [t string] == @"int" || [t string] == @"char") {
		return 0;
	}
	else 
		return -1;
}

- (int) isClassType:(TypeName*)t {
	//FIXME locate class type in class Database
	return -1;
}


@end
