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


#import "FNString.h"

@implementation FNString

- (FNString*)ctor {
	self = [super init];
	
	_errorobj = [Error new];
	
	if (self)
		return self;
	else 
		return (FNString*)0;

}

- (FileBuffer*)buffer {
	return _fileBuffer;
}

- (int) scan {
	
	if (_fileBuffer == (FileBuffer *)0)
		[_fileBuffer init];
	
	//FIXME put int thread
	//FIXME2 ecl
	[self readInFile];
	[self scancompile];
	
	//fprintf(stdout, "%c", [fileBuffer characterAtIndex: 0]);
	
	
	return 0;
}


- (int) readInFile {
	
	_fileBuffer = [FileBuffer new];
	FILE *fp;
	
	if ((fp = fopen([self UTF8String], "r")) == (FILE *)0) {
		fprintf(stderr, "- file scanner : cannot read in file."); 
		return -1;
	}
	
	if (flock(fileno(fp), LOCK_SH) < 0) {
		fprintf(stderr, "- file scanner : cannot lock shared lock.");
		return -1;
	}

	//code block
	fseek(fp, 0L, SEEK_END);
	long pos = ftell(fp);
	
	//read in file le
	unichar c;
	while (fseek(fp, pos--,SEEK_END) && pos >= 0 && (c = fgetc(fp)))
		_fileBuffer = (FileBuffer *)[_fileBuffer stringByAppendingString: [NSString stringWithCharacters:&c length: 1]]; 
	
	if (flock(fileno(fp), LOCK_UN) < 0) {
		fprintf(stderr, "- file scanner cannot unlock shared lock.");
		return -1;
	}
	if (!fclose(fp))
		return 0;
	else {
		fprintf(stdout, "- file scanner : cannot close readin file."); 
		return -1;
	}

}

- (int) scancompile{

	//FIXME err struct
	if (_fileBuffer == (FileBuffer *)0)
		return -1;
	
	//compiler = [ Compiler new ]; 
	//[scancompiler compile: _fileBuffer ]; 
	
	return 0;
	
}

- (int) isheader {
	
	if ([self length] < 2)
		return -1;
	
	if ([self characterAtIndex: ([self length]-1)] == 'h' 
		&&
		[self characterAtIndex: ([self length]-2)] == '.')
		return 0;
	
	return -1;
}

- (int) issource {
	
	if ([self length] < 2)
		return -1;
	
	if ([self characterAtIndex: ([self length]-1)] == 'm'
		&&
		[self characterAtIndex: ([self length]-2)] == '.')
		return 0;
	
	return -1;
}

- (int) isCHeader {
	
	if ([self length] < 2)
		return -1;
	
	if ([self characterAtIndex: ([self length]-1)] == 'h' 
		&&
		[self characterAtIndex: ([self length]-2)] == '.')
		return 0;
	
	return -1;
}

- (int) isCSource {
	
	if ([self length] < 2)
		return -1;
	
	if (//([self characterAtIndex: ([self length]-1)] == 'cc' 
		 /*||*/ [self characterAtIndex:([self length]-1)] == 'c'
		 //|| [self characterAtIndex:([self length]-1)] == 'cpp'
		
		&&
		[self characterAtIndex: ([self length]-2)] == '.')
		return 0;
	
	return -1;
}


- (void) addStatus:(int)s {
	
	[_statusobj addStatus:s ];

}

- (void) addError:(int)e {
	
	[_errorobj addError:e ];
	
}

- (NSString*)stringFromIndex:(int)start toIndex:(int)end {
	int i = start-1;
	NSString *str = @"";
	while (i < end) {
		str += [self characterAtIndex:i++];
	}
	
	return str;
}

- (void)addErrors:(Error*)err {

	NSEnumerator *e = [[err getErrors] objectEnumerator];
	id object;
	while (object = [e nextObject]) {
		[_errorobj addErrorTuple: object];
	}

}

@end
