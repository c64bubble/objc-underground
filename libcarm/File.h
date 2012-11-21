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

/*
 * filename : file buffer agent (FNString in libojcgbarm lib !)
 */
#ifndef _FILEUTIL_H_
#define _FILEUTIL_H_

#import <Cocoa/Cocoa.h>
#import "FileBuffer.h"
#import "Node.h"
#import "Disk.h"

@interface FileName : NSString {
	
}

@end


@interface File {
	FileName *_fileName;
	FileBuffer *_fileBuffer;
	Node **_nodeptr;
}

- (File*)ctor:(FileName*)fileName;
- (FileBuffer*)buffer;
- (FileBuffer*)setBuffer:(FileBuffer*)fb;
//--FIXME -(FileBuffer*)addToBuffer:(NSString*);

- (FileName*)fileName;
- (NSString*)stringFromIndex:(int)start toIndex:(int)end;

- (void)writeOn:(Disk*)disk;

@end

#endif
