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

#ifndef GBA_RuntimeExample1_H_
#define GBA_RuntimeExample1_H_

/*
 */

#import <Cocoa/Cocoa.h>
#import "RamDisk.h"

@interface RuntimeExample1 : NSObject {

	RamDisk *_rd;

}

- (RuntimeExample1 *)ctor;

@end

#endif
