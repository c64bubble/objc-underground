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
//  libobjcgbarm
//
//  Created by link on 25/10/12.
//

#ifndef GBA_CARMMACROS_H_
#define GBA_CARMMACROS_H_

#import <Cocoa/Cocoa.h>
#include "../libobjcgbarm/src/FileStream.h"

#define CARMASSERT(cl) \
	if (cl) \
		return 0; \
	else \
		return -1; \

//FILE ops
#define CARMFOPENRAMDISK(filename, proto, ramdisk) \
	if (proto == "r" || proto == "r+") { \
		[ramdisk read:filename] \
		return 0; \
	} else if (proto == "w" || proto == "w+") { \
		[ramdisk write:[File ctor:filename]] \
		return 0; \
	} else { \
		return -1; \
	} \

//FILE ops
//--FIXME #include "FileStream.h"
#define CARMFOPENGBA(filename, proto) \
/////////	if (proto == "r" || proto == "r+") { \
		FILE *fp = [FileStream ctor]; \
		

#endif


