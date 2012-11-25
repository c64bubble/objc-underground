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

#import "OTree.h"

@implementation OTreeLeaf 

- (int)isleaf {
	return 1;
}

- (OTreeLeaf*)ctorX:(int)xx Y:(int)yy Z:(int)zz W:(int)ww H:(int)hh D:(int)dd {
	x = xx;
	y = yy;
	z = zz;
	w = ww;
	h = hh;
	d = dd;

	return self;
}


- (int)xx {
	return x;
}

- (int)yy {
	return y;
}

- (int)zz {
	return z;
}

- (int)ww {
	return w;
}

- (int)hh {
	return h;
}

- (int)dd {
	return d;
}


@end

@implementation OTreeNode 

//FIXME ctor

- (int)isleaf {
	return 0;
}

- (void)add:(NSObject*)n {

	[nodes addObject:n];

}

- (NSMutableArray*)nodes {
	return nodes;
}

- (OTreeNode*)ctorX:(int)xx Y:(int)yy Z:(int)zz W:(int)ww H:(int)hh D:(int)dd {

	x = xx;
	y = yy;
	z = zz;
	w = ww;
	h = hh;
	d = dd;

	return self;
}

@end

@implementation OTree 

- (void)ctorX:(int)xx Y:(int)yy Z:(int)zz W:(int)ww H:(int)hh D:(int)dd {

	tree = [OTreeNode ctorX:xx Y:yy Z:zz W:ww H:hh D:dd];

}

- (void)generateTreeDepth:(int)depth Width:width {

	//FIXME ctor OTree
	[self generateDepth:depth Node:tree X:[tree xx] Y:[tree yy] Z:[tree zz] W:[tree ww] H:[tree hh] D:[tree dd]];

}

- (void)generateDepth:(int) depth Node:(OTreeNode*)n X:(int)xx Y:(int)yy Z:(int)zz W:(int) ww H:(int)hh D:(int)dd {

	if (depth <= 0)
		[n add:[OTreeLeaf ctorX:xx Y:yy Z:zz W:ww H:hh D:dd]];
		return;

	[n add:[OTreeNode ctorX:xx Y:yy Z:zz W:ww/3 H:hh/3 D:dd/3]];
	[n add:[OTreeNode ctorX:4*xx/3 Y:yy Z:zz W:ww/3 H:hh/3 D:dd/3]];
	[n add:[OTreeNode ctorX:5*xx/3 Y:yy Z:zz W:ww/3 H:hh/3 D:dd/3]];
	[n add:[OTreeNode ctorX:xx Y:4*yy/3 Z:zz W:ww/3 H:hh/3 D:dd/3]];
	[n add:[OTreeNode ctorX:xx Y:5*yy/3 Z:zz W:ww/3 H:hh/3 D:dd/3]];
	[n add:[OTreeNode ctorX:xx Y:yy Z:zz W:ww/3 H:hh/3 D:dd/3]];
	[n add:[OTreeNode ctorX:xx Y:yy Z:4*zz/3 W:ww/3 H:hh/3 D:dd/3]];
	[n add:[OTreeNode ctorX:xx Y:yy Z:5*zz/3 W:ww/3 H:hh/3 D:dd/3]];
	
	[self generateDepth:depth-1, [[n nodes] objectAtIndex:0] X:xx Y:yy Z:zz W:ww/3 H:hh/3 D:dd/3];
	[self generateDepth:depth-1, [[n nodes] objectAtIndex:0] X:4*xx/3 Y:yy Z:zz W:ww/3 H:hh/3 D:dd/3];
	[self generateDepth:depth-1, [[n nodes] objectAtIndex:0] X:5*xx/3 Y:yy Z:zz W:ww/3 H:hh/3 D:dd/3];
	[self generateDepth:depth-1, [[n nodes] objectAtIndex:0] X:xx Y:4*yy/3 Z:zz W:ww/3 H:hh/3 D:dd/3];
	[self generateDepth:depth-1, [[n nodes] objectAtIndex:0] X:xx Y:5*yy/3 Z:zz W:ww/3 H:hh/3 D:dd/3];
	[self generateDepth:depth-1, [[n nodes] objectAtIndex:0] X:xx Y:yy Z:zz W:ww/3 H:hh/3 D:dd/3];
	[self generateDepth:depth-1, [[n nodes] objectAtIndex:0] X:xx Y:yy Z:4*zz/3 W:ww/3 H:hh/3 D:dd/3];
	[self generateDepth:depth-1, [[n nodes] objectAtIndex:0] X:xx Y:yy Z:5*zz/3 W:ww/3 H:hh/3 D:dd/3];
}

@end
