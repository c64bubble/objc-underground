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

#ifndef GBA_GFXWIDGETS_H_
#define GBA_GFXWIDGETS_H_

/*
 */

#import <Cocoa/Cocoa.h>
#import "GFXImage.h"

@interface GFXWidget : NSObject {

	short int _x;
	short int _y;
	short int _w;
	short int _h;

	GFXWidget *_root;
	GFXWidget *_parent;
	NSMutableArray *_children;

}

- (void) setX:(short int)x;
- (void) setY:(short int)y;
- (short int) getX;
- (short int) getY;

@end

@interface GFXFrame : GFXWidget {

}

- (GFXFrame*)ctor:(GFXWidget*)parent;
- (void)addButton:(GFXWidget*)button;

@end

@interface GFXButton : GFXWidget {

	GFXImage *_buttonimage;
	GFXImage *_buttonpressedimage;

}

- (GFXButton*)ctor;
- (void)setImageFrom:(char *)staticbuffer and:(char *)staticbuffer2;

@end

/*
 * Button in 1 colour, shaded when pressed
 */

@interface GFXColoredButton : GFXWidget {

	short int _color;
	short int _shadingcolor;

}

- (GFXColoredButton*)ctor;
- (GFXColoredButton*)ctor:(short int)colo;
- (GFXColoredButton*)ctor:(short int)colo and:(short int)shadingcolo;
//async blitting e.g. in GBA_loop(); --FIXME
- (void)blit;

@end

#endif
