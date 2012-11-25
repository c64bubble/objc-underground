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

#ifndef GBA_TREE_H_
#define GBA_TREE_H_

/*
 */

#import <Cocoa/Cocoa.h>

@interface TreeNode : NSObject {
	TreeNode* _left;
	TreeNode* _right;

	NSObject* _data;
}

- (void)addLeftNode:(NSObject*)data;
- (void)addRightNode:(NSObject*)data;

@end

@interface Tree : NSObject {
	TreeNode *root;	
}
@end

#endif
