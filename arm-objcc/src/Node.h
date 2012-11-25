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

#ifndef GBA_NODE_H_
#define GBA_NODE_H_

/*
 * This is a TypeName class as seen in libobjcgbarm
 */

#import <Cocoa/Cocoa.h>

#define WORDSIZE 32
#define ARMPROCESSORSTACKSIZE \
	(int)pow(2,WORDSIZE)

@interface Node : NSObject {

	int _size;
	int *_data;
	int _id;
}
- (Node *)ctor;
- (Node *)ctor:(int) sz;

//////////////- (Node *)setData:(NSString*) s;
- (int)id;
- (NSString*)data;

@end

#endif
