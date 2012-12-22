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


#import "ErrorSubCompiler.h"


@implementation ErrorSubCompiler

-(void) addError:(int)ei {
	
	switch (ei) {
		case SUBCOMPILENOT:{
			[_errorstrs addObject:[[ Tuple new] addFirst:ei andSecond: @"Cannot compile"]];
			break;
		}
		case SUBCOMPILEINVALIDRETURNTYPE:{
			[_errorstrs addObject:[[ Tuple new] addFirst:ei andSecond: @"Invalid return type"]];
			break;
		}
		case SUBCOMPILEINVALIDFUNCNAME:{
			[_errorstrs addObject:[[ Tuple new] addFirst:ei andSecond: @"Invalid function name"]];
			break;
		}
		case SUBCOMPILEINVALIDARGS:{
			[_errorstrs addObject:[[ Tuple new] addFirst:ei andSecond: @"Invalid function arguments"]];
			break;
		}
		case SUBCOMPILEINVALIDFUNCDEF:{
			[_errorstrs addObject:[[ Tuple new] addFirst:ei andSecond: @"Invalid function definition"]];
			break;
		}
		default:{
			[_errorstrs addObject:[[ Tuple new] addFirst:ei andSecond: @"Compiler error"]];
		}
	}
	
}

(int)errorset {
	return [_errorstrs length];
}
@end
