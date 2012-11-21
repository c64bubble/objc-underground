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

#import "GBAChunk.h"
#include "GBAutil.h"


@implementation GBAChunk

- (GBAChunk*)ctor:(void *)chu withReadF:(int (*)(void *, void *))rf withWriteF:(int (*)(void *, void *))wf {
	[super init]; 
	
	_chunk = chu;
	_readChunkF = rf;
	_writeChunkF = wf;
	
	return self;
}

- (int) isChunk {
	return 0;
}

- (int) claim {
	if (_readChunkF == (int (*)(void*, void *))0) {
		_readChunkF = &GBAread;
		_writeChunkF = &GBAwrite;
	} else {
		return -1;
	}
	return 0;
}

- (int) claimWith:(void *)data {
	if (_readChunkF == (int (*)(void*, void *))0) {
		_readChunkF = &GBAread;
		_writeChunkF = &GBAwrite;
		[self setData:data];
	} else {
		return -1;
	}
	return 0;
}

- (void) setData:(void *)data {
	_chunk = data;
}

- (int) unclaim {
	_readChunkF = (int (*)(void *, void *))0;
	_writeChunkF = (int (*)(void *, void *))0;
	[self setData:(void *)0];

	return 0;
}

@end
