//
//  HashTableStrings.m
//  libobjcgbarm
//
//  Created by link on 25/10/12.
//  Copyright 2012 vub. All rights reserved.
//

#import "HashTableStrings.h"

@implementation HashTableStrings

- (HashTable *)ctor:(int)sz {
	_size = sz;
	_table = (int**)malloc(sizeof(NSString*)*_size);
	
	return self;
}

- (int)matchWithKey:(int)key returns:(NSString*)rString{
	if (_table > (int**)0) {
		rString = (NSString*)_table[ (sizeof(NSString*) * key) % _size ];
		return 0;
	} else {
		return -1;
	}
}

@end
