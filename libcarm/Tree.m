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

#import "Tree.h"

@implementation TreeNode 

- (Tree *)ctor:data {

	_data = data;
	_left = NULL;
	_right = NULL;

	return self;

}

- (void)addLeftNode:(NSObject*)data {

	TreeNode *_left = [ TreeNode ctor:data ];

}

- (void)addRightNode:(NSObject*)data {

	TreeNode *_right = [ TreeNode ctor:data ];

}

@end

@implementation Tree 

- (Tree *)ctor {

	return self;

}
@end
