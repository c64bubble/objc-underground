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

#import "ParseString.h"


@implementation ParseString

- (ParseString*)ctor:(NSString*)s {
	[super init];
	string = s;
	
	return self;
	
}

- (bool) isSkipCharacterAtIndex:(int)index {
	if (index < [string length] && ([string characterAtIndex:index] == ' '
									||
									[string characterAtIndex:index] == '\t'
									||
									[string characterAtIndex:index] == '\n'))
		return true;
	
	else {
		return false;
	}
}

- (int) skipSkips:(int)i {
	while (i < [string length]) {
		if ([self isSkipCharacterAtIndex:i++])
			continue;
		else {
			break;
		}

	}
	return 0;
}

- (NSString*)getWordUntilCharacter:(unichar)c startingAt:(int)i {
	NSString *s;
	while (i < [string length]) 
		if ([string characterAtIndex:i] != c) {
			s += [string characterAtIndex:i];
		} else {
			return s;
		}
	return @"";
}

- (bool) eqString:(NSString*)s {
	if (s == string)
		return true;
	else {
		return false;
	}
}

- (int) isTypedWell {
	int i;
	i = [self skipSkips:i];
	
	while (++i < [string length]) {
		if ([string characterAtIndex:i] == '(')
			break;
	}
	
	i = [self skipSkips:i];
	
	
	NSString* typeword = [self getWordUntilCharacter:')' startingAt:i];//e.g void)
	NSString* typeword2 = [self getWordUntilCharacter:' ' startingAt:i];//e.g. void )
	
	//FIXME type db + object locator code
	if (typeword == @"void"
		||
		typeword == @"int"
		||
		typeword == @"NSString*") {
		return i+[typeword length];
	} else if (typeword2 == @"void"
			   ||
			   typeword2 == @"int"
			   ||
			   typeword2 == @"NSString*") {
		return i+[typeword2 length];
		
	} else {
		return -1;
	}
	
}

- (NSString*)string {
	return string;
}

- (NSString*)substringAtIndex:(int)i {
	NSString *ts = @"";
	
	int j = i;
	while (j < [string length]) {
		ts += [string characterAtIndex:j++];
	}
	
	return ts;
}

@end
