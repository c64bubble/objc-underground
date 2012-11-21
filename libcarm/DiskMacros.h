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
//  RamDisk.h
//  libcarm
//
//  Created by link on 25/10/12.
//  Copyright 2012 vub. All rights reserved.
//

#ifndef GBA_DISKMACROS_H_
#define GBA_DISKMACROS_H_

#import <Cocoa/Cocoa.h>
#include <sys/file.h>
#include "libcmacros.h"

//file types for writer
enum { ELF = 1, NIL = 2, MEMORY = 3, CFILE = 4, };

/*
 * write typedefs of subcompiled classes (inside the class locator) 
 * from the dictionary of CNodes into current block-scope
 */

#define MEMORYWRITE(dict, i) \
		\
		CARMASSERT(i >= 0); \
		\
		CNode *cnode = [dict objectAtIndex:i]; \
							\
		if (cnode == nil) \
			break; \
				\
		int id = [cnode id]; \
		char *name = [cnode name]; \
		//typedef of defined class to C runtime \
		NAMEMAC(name, id);  \

#define MEMORYBEGIN \
	{//open block \
			\

#define MEMORYEND \
			\
	//close block \
	}; \
		\

#define MEMORYEND2 \
			\
	//close block \
	} \
		\


/* 
 * NAMEMAC macro function :
 *
 * output typedef with name of NAME argument
 */

#define NAMEMAC(NAME, ID) \
	typedef struct NAME { int ID; char *NAME; };


#endif
