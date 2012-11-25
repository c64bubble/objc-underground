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
//
//  Disk.m
//  libcarm
//
//  Created by link on 25/10/12.

#import "Disk.h"
#import "../libobjcgbarm/src/TypeName.h"

@implementation Disk

- (int) defineWith:(long int)id and: (char *)name toFormat:(int)fmt {
	
	switch (fmt) {
		//write out to ELF file format (object code)
		case ELF:{
			break;
		}
		//write out to C source file (*.c)
		case CFILE:{
			break;
		}
		/* 
		 * append id & name to dictionary
		 * (write into run-time C source memory with 
		 * RDMEMORYWRITE macro
		 */
		case MEMORY:{
			// copy above typedef to working block
			break;
		}
			
		default:{
			return -1;
			break;
		}
			
	}
	
	return 0;
	
}


- (void) write:(TName *)name data:(void *)data {
	WRITETYPE(name)

	TName tname;
	tname.datax.length = sizeof(*data);

	memcpy(tname.datax.data, data, tname.datax.length);
}

@end


