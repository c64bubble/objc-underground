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

#ifndef GBA_GFX_H_
#define GBA_GFX_H_

#include "config.h"

#define _SCREENWIDTH _ARMSCREENWIDTH
#define _SCREENHEIGHT _ARMSCREENHEIGHT

/*
 */

#import <Cocoa/Cocoa.h>

@interface Pixel : NSObject {

	short int _color;	

}

- (void)ctor:(short int)colo;
- (short int)color;

@end

@interface Buffer : NSObject {

	Pixel ***_buffer;
	//_buffer size in config.h
}

- (Buffer *)ctor;

@end

@interface ScreenBuffer : Buffer {

	
}

- (ScreenBuffer*)ctor;
- (Pixel*)getX:(short int)x Y:(short int)y;
- (void)putX:(short int)x Y:(short int)y color:(Pixel*)pix;

- (void)blit;

@end

#endif
