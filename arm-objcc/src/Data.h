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
/////////#import "RamDisk.h"//--FIXME
/*
 * The typename gets defined in memory (as a typename in a locator system)
 * and can be written to file
 * later on (ELF, misc obj files, ...)
 */

#define STRING(i) \
	"i" \

#define WRITEUBERDATAMAC(TYPENAME) \
	struct { int length; \
		void* TYPENAME; \
		}; \

#define WRITETYPEDATA \
	typedef struct DATAX { \
		int length; \
		void *data; \
		} DATAX; \

#define WRITEDATAMAC \
	DATAX datax; \

//--FIXME datastruct->typename
#define DATADEREF(typename) \
	->typename \

#define MATCHDATAANDTYPEID(datastruct, typename) \
	if (typename == datastructDATADEREF(typename)) \
		return 1; \
	else \
		return 0; \

typedef struct __Data_struct { int id; int datalength; void *data; } __Data_struct;

@interface Data : NSObject {
	__Data_struct *_data;
}

- (void*)data;
- (int) setData:(void*)data;
- (int) type;

@end
