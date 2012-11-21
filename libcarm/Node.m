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

#import "Node.h"

@implementation Node 

- (Node *)ctor {

	_size = ARMPROCESSORSTACKSIZE;
	
	return self;
}

- (Node *)ctor:(int) sz {

	_size = sz;
	
	return self;
}
/**************
- (Node *)setData:(NSString*) s {

	memmove(_data, strdup([s UTF8String]), [s length] * sizeof(char));
	memset(s, 0, [s length] *sizeof(char));

	return self;

}
***************/
- (int)id {
	return _id;
}

- (NSString*)data {

	return (NSString*)_data;

}
@end
