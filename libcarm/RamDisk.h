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
//  libobjcgbarm
//
//  Created by link on 25/10/12.
//  Copyright 2012 vub. All rights reserved.
//

#ifndef GBA_RAMDISK_H_
#define GBA_RAMDISK_H_

#import <Cocoa/Cocoa.h>



#import "Disk.h"

#import <sys/file.h>


//include configuration file
#import "config.h"
//Compile with features of GBA
#if _ARM7_GBA
#import "../GBA/src/File.h"
#endif

#import "Node.h"

#import "DiskMacros.h"
#import "RamDiskMacros.h"

@interface RamDisk : Disk {
	
	NSString *_currentFileName;
	int _currentId;
	NSMutableArray *_writeDict;	
}

- (NSMutableArray *)dictionary;

- (int) defineWith:(long int)id and: (char *)name toFormat:(int)fmt;
- (Node**) writeDictAppend:(int) id and:(char *)name;
- (Node*)readDictFrom:(char *)nodeName;
- (Node*)readDict:(int)id;

- (int) read:(FileName*)fileName;
- (Node**)write:(File*)file;
- (void)writeData:(NSString*)data;

@end

int memoryWrite(NSMutableArray *dict);

#endif
