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

#import "GFXWidgets.h"

@implementation GFXWidget 


- (void)ctor {
	//X11 - position is always rootxy when not defined
	_x = 0;
	_y = 0;

}

- (void) setX:(short int)x {
	_x = x;
}

- (void) setY:(short int)y {
	_y = y;
}

- (short int) getX {
	return _x;
}

- (short int) getY {
	return _y;
}

- (void) setW:(short int)w {
	_w = w;
}

- (void) setH:(short int)h {
	_h = h;
}

- (short int) getW {
	return _w;
}

- (short int) getH {
	return _h;
}

- (void) setWFrom:(GFXFrame*)frame {
	_w = [frame getW];
}

- (void) setHFrom:(GFXFrame*)frame {
	_h = [frame getH];
}

@end

@implementation GFXFrame

- (GFXFrame*)ctor:(GFXWidget*)parent {
	[super ctor];

	_root = NULL;//--FIXME
	_parent = parent;
	_children = [NSMutableArray init];

	return self;
}

- (void)addButton:(GFXWidget*)button {

	[_children addObject: button];
}
 
@end

@implementation GFXButton 

- (GFXButton*)ctor {
	return self;
}

- (void)setImageFrom:(char *)staticbuffer and:(char *)staticbuffer2{

	[[_buttonimage ctor] loadImageFrom:(char*)staticbuffer];

}

@end


/*
 * Button in 1 colour, shaded when pressed
 */
@implementation GFXColoredButton 

- (GFXColoredButton*)ctor {
	//B&W
	_color = 0x0000;
	_shadingcolor = 0xFFFF;
}

- (GFXColoredButton*)ctor:(short int)colo {
	_color = colo;
	return self;
}

- (GFXColoredButton*)ctor:(short int)colo and:(short int)shadingcolo{
	_color = colo;
	_shadingcolor = shadingcolo;
	return self;
}

- (void)blit {

	

}

@end

