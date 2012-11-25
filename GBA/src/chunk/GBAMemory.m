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

#import "GBAMemory.h"

@implementation GBAMemory

- (GBAMemory*)ctor {
	[super init];
	//_chunkmemory = RamBuffer;
	_chunkOffset = 0;

	return self;
}

- (int) manageChunk:(GBAChunk*)chunk {
	
	if (_chunkOffset > 2^16) {
		return MEMORYISFULL;
	}
	
	memcpy(RamBuffer[_chunkOffset], chunk, sizeof(chunk)||sizeof(GBAChunk));
	_chunkOffset += sizeof(GBAChunk);
	
	return 0;
}

@end
