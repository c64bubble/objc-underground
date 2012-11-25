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


#import <Cocoa/Cocoa.h>
#import "ArmCompilerBase.h"
#import "FileName.h"
#import "ArmScanner.h"
#import "ParseString.h"

@interface ArmCompiler : ArmCompilerBase {

	ArmScanner *_armScanner;
	
}

enum {
	NOTFOUND = -1, 
};

- (void)compile:(FileName*)fileName;
- (void)scanFile:(FileName*)fileName;
- (int)scanFileRec:(FileName*)fileName;
- (int)compilable:(FileName*)fileName;
- (int)compilableheader:(FileName*)fileName;
- (int)compilablesource:(FileName*)fileName;
- (int) searchFor:(NSString*)fileBuffer char:(unichar)c startingAt:(int)startidx numberOfSkips:(int*)skips;
- (int) searchFor:(NSString*)fileBuffer char:(unichar)c startingAt:(int)startidx;
- (int) searchFor:(NSString*)fileBuffer string:(NSString*)s startingAt:(int)startidx;

- (int*)compilableInterfaceMethod:(NSString *)methodstr;
- (int*)compilableCheckReturnType:(NSString*)methodstr;
- (int*)compilableCheckFunctionName:(NSString*)methodstrpart;
- (int*)compilableCheckFunctionArgName:(NSString*)methodstrpart;
- (int*)compilableCheckFunctionArgs:(NSString*)methodstrpart;

- (NSString*)reverse:(NSString*)str;

@end
