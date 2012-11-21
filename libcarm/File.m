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


#import "File.h"
#import "RamDisk.h"
#include <stdio.h>
#include <stdlib.h>

@implementation File

- (File*)ctor:(FileName*)fileName {

	_fileName = fileName;
	return self;
}

- (FileBuffer*)buffer {
	return _fileBuffer;
}

- (FileBuffer*)setBuffer:(FileBuffer*)fb {
	memcpy(_fileBuffer, fb, [fb length]);
	return _fileBuffer;
} 

- (FileName*)fileName {
	return _fileName;
}

- (int) readInFile {
	
	_fileBuffer = [FileBuffer new];
	FILE *fp;
	
	if ((fp = fopen([_fileName UTF8String], "r")) == (FILE *)0) {
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

- (NSString*)stringFromIndex:(int)start toIndex:(int)end {
	int i = start-1;
	NSString *str = @"";
	while (i < end) {
		str += [_fileName characterAtIndex:i++];
	}
	
	return str;
}

- (void)writeOn:(Disk*)disk {

////FIXME	LOCK(m)
	_nodeptr = [disk write:self];
////FIXME	UNLOCK(m)
}
@end
