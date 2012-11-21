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

#import "GBAObject.h"


@implementation GBAObject

- (NSString *)string {
	return name;
}

- (int) isaid:(int)typenamei {
	NSString *morbo = nil;
	return [typenamearray matchTypeNameId:typenamei returns:morbo];
}

- (int) hasaid:(int)methodnamei {
	return [methodnamearray matchMethodNameId:methodnamei];
}

- (int) isa:(TypeName*)typename {
	return [typenamearray matchTypeName:typename];
}

- (int) hasa:(MethodName*)methodname {
	return [methodnamearray matchMethodName:methodname];
}

@end
