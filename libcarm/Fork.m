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

#import "Fork.h"

@implementation Fork 

- (Fork *)ctor {

	#if 0
	#if _ARM7
	#endif
	#if _ARM9
	#endif
	#if _ARM10
	#endif
	#if _ARM11
	#endif	
	#else
	//no multi-core fork
	parentpid = 0;	
	pid = 0;

	return self;

}

- (Fork *)ctor:(pid_t) wantedpid {
	
	#if 0
	#if _ARM7
	#endif
	#if _ARM9
	#endif
	#if _ARM10
	#endif
	#if _ARM11
	#endif	
	#else
	//no multi-core fork
	parentpid = 0;	
	pid = 0;

	return self;

}

@end
