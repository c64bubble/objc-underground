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

#import "TypeNameArray.h"


@implementation TypeNameArray

- (TypeNameArray *)ctor {
	[_typenames ctor:256*256];//--FIXME fixed size
	return self;
}

//seek typename's id returns 0 if found, -1 if not found, rString contains typename matched by id
- (int) matchTypeNameId:(int)tni returns:(NSString*)rString {
	[_typenames matchWithKey: tni returns:rString];
	
	if (rString > 0)
		return 0;
	else {
		memset((void *)rString, 0, sizeof(rString));
		return -1;
	}

}

//seek typename returns 0 if found -1 if not found
- (int) matchTypeName:(TypeName *)tn {
	NSString  *rString;
	[self matchTypeNameId:[tn type] returns: rString];
	
	if (rString > 0)
		return 0;
	else {
		memset((void *)rString, 0, sizeof(rString));
		return -1;
	}
}

- (int)size {
	return [_typenames size];
}

@end
