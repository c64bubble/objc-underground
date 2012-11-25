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
//  Disk.h
//  libcarm
//
//  Created by link on 25/10/12.
//  Copyright 2012 vub. All rights reserved.
//

#ifndef GBA_DISK_H_
#define GBA_DISK_H_

#import <Cocoa/Cocoa.h>
#import "DiskMacros.h"
//////////////////#import "../libobjcgbarm/src/TypeName.h"

typedef struct TName { int bogus; } TName;

@interface Disk : NSObject {
}

- (int) defineWith:(long int)id and: (char *)name toFormat:(int)fmt;
- (void) write:(TName *)name data:(void *)data;

@end

#endif
