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
//  libcarm
//
//  Created by link on 25/10/12.
//

#ifndef GBA_OTREE_H_
#define GBA_OTREE_H_

/*
 * File System tree based on octtree
 */

#import <Cocoa/Cocoa.h>

@interface OTreeLeaf : NSObject {
	int x,y,z,w,h,d;//3D FS
}

- (int)xx;
- (int)yy;
- (int)zz;
- (int)ww;
- (int)hh;
- (int)dd;

- (int)isleaf;
- (OTreeLeaf*)ctorX:(int)xx Y:(int)yy Z:(int)zz W:(int)ww H:(int)hh D:(int)dd;

@end



@interface OTreeNode : OTreeLeaf {
	NSMutableArray* nodes;
}

- (int)isleaf;
- (void)add:(NSObject*)n;
- (NSMutableArray*)nodes;

@end

@interface OTree : NSObject {
	OTreeNode* tree;
	int depth;	
}
- (void)generateTreeDepth:(int)depth Width:width;
- (void)generateDepth:(int) depth Node:(OTreeNode*)n X:(int)xx Y:(int)yy Z:(int)zz W:(int) ww H:(int)hh D:(int)dd;

@end

#endif
