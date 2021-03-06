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


#import "Error.h"
#import "TupleInt.h"

@implementation Error

-(void) addError:(int)ei {
	
	switch (ei) {
		case 0:{
			break;
		}
		case UNKNOWNFILEFORMAT:{
			[_errorstrs addObject:[[TupleInt alloc] addFirstInt:ei andSecond: @"Unknown File Format. Not .m or .h"]];
			break;
		}
		default:{
		}
	}
	
}

-(void)addErrorTuple:(Tuple*)t {
	[_errorstrs addObject:t];
}

//is there an error in the str db ?
- (int)errorset {

	return [_errorstrs count];
}

-(void)clear {
	[ _errorstrs removeAllObjects];
}

-(NSMutableArray*)getErrors {
	return _errorstrs;
}
@end
