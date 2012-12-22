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
#import "../../libcarm/Disk.h"////

#import "Data.h"

/*
 * The typename gets defined in memory (as a typename in a locator system)
 * and can be written to file
 * later on (ELF, misc obj files, ...)
 */

WRITETYPEDATA

#define WRITETYPE(NAME) \
	typedef struct TName { \
			int id; \
			char *NAME; \
			WRITEDATAMAC \
			} TName; \

@interface TypeName : NSObject {

		int _id;
		char *_name;
}

- (int) defineWithId:(long int)typeid andName:(NSString*)name;
- (TypeName *)ctor:(long)i withTypeName:(NSString *)n;
- (NSString *)string;
- (long int)type;

- (int) subCompileSelfOn:(Disk*)disk;
- (int) subCompileSelfOn:(Disk*)disk withFormat:(int)fmt;
- (int) this:(TypeName*) tn isa:(const char *)str;

- (int)writeOn:(Disk*)disk data:(Data*)data;
@end
