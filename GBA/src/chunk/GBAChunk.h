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
//#include "MemChunk.h"

//NOTE : make this subcompilable (libobjcarm) pure C!
@interface GBAChunk : NSObject/*: MemChunk*/ {
	void *_chunk;
	int (*_readChunkF)(void *, void*);
	int (*_writeChunkF)(void*, void *);
}


- (GBAChunk*)ctor:(void *)chu withReadF:(int(*)(void *,void*))rf withWriteF:(int(*)(void *,void*))wf;
- (int)isChunk;
- (int) claim;
- (int) claimWith:(void*)data;

- (void)setData:(void *)data;

- (int) unclaim;
																																					
@end

