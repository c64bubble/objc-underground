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

#import "Fuzzy.h"
#include <assert.h>

@implementation Fuzzy

- (int)mulinit:(int*)_rv {
	[self mul:_vector and:(int**)_matrix returns:_rv];
	return 0;
}

- (int) mul:(int*)_v and:(int**)_m returns:(int*)_rv {
	int i,j;
	
	for (; i < sizeof(_v)/sizeof(int); i++) {
		for (; j < sizeof(_v)/sizeof(int); j++) {
			
			_rv[j] += _m[j][i]*_v[j];
			
		}
	}
	return 0;
}

- (double) fitnessForMax:(int)max {
	int i;
	double r;
	int *v;
	[self mulinit:v];
	for (; i < max; i++) {
		r += v[i];
	}
	
	r /= i;
	return r;
}

@end
