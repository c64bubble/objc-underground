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

#import "GFX.h"

#include "./Malloc.h"
#include "../GBA/include/gba_arm_config.h"
//--FIXME better place 

@implementation Pixel


- (void)ctor:(short int)colo {

	_color = colo;
}

- (short int)color {
	return _color;
}

@end


@implementation Buffer 

- (Buffer *)ctor {

	_buffer = (Pixel ***)malloc(240*160*sizeof(Pixel*));

	return self;

}

@end

@implementation ScreenBuffer 

- (ScreenBuffer*)ctor {

	[super ctor];
	return self;
}

- (Pixel*)getX:(short int)x Y:(short int)y {

	return (_buffer[x][y]);

}

- (void)putX:(short int)x Y:(short int)y color:(Pixel*)pix{

	(_buffer)[x][y] = pix;

}

- (void)blit {

	int x = -1;
	int y = -1;
	for ( ; ++y < _SCREENHEIGHT ; ) {
		for ( ; ++x < _SCREENWIDTH; ) {
			_VideoRam[x+y*_SCREENWIDTH] = [_buffer[x][y] color];
			
		}
	}

	return;
}

@end
