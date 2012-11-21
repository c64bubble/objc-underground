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

#import "TypeName.h"

@implementation TypeName

// bogus
- (int) defineWithId:(long int)typeid andName:(NSString*)name {

	_id = typeid;
	_name = (char *)[name UTF8String];
	return 0;
	
}

- (TypeName *)ctor:(long int)i withTypeName:(NSString *)n {
	[super init];
	//////////////WRITETYPE(name);

	_id = i;
	_name = (char *)[n UTF8String];
	
	return self;
}

- (NSString *)string {
	return (NSString*)_name;
}

- (long int)type {
	return _id;
}

- (int) this:(TypeName*) tn isa:(const char *)str {
	if (!strncmp(str,[[tn string] UTF8String],strlen(str)))
		return 0;
	else
		return -1;
}

- (int) subCompileSelfOn:(Disk*)disk {


	[disk defineWith: _id and: _name toFormat:ELF];

	return 0;
}

- (int) subCompileSelfOn:(Disk*)disk withFormat:(int)fmt{
	[disk defineWith: _id and: _name toFormat:fmt];
	
	return 0;
}

- (int)writeOn:(Disk*)disk data:(Data*)data{

	[disk write:self data:[data data]];

}

@end
