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


#import "FileStream.h"

@implementation FileNameStream

- (FileNameStream*)ctor {
	
	return self;

}


- (int) open:(NSString*)filename {
	
	if ((_fp = fopen(filename, "rw")) == (FILE *)0) {
		fprintf(stderr, "- filenamestream : cannot read in file."); 
		return -1;
	}
	
	if (flock(fileno(_fp), LOCK_SH) < 0) {
		fprintf(stderr, "- filenamestream : cannot lock shared lock.");
		return -1;
	}

}

- (char)get {

	return (getc(_fp));

}

- (char)get:(int)index {

	//code block
	fseek(_fp, index, SEEK_SET);
	return (getc(_fp));

}	

- (int)close {
	
	if (flock(fileno(_fp), LOCK_UN) < 0) {
		fprintf(stderr, "- filenamestream cannot unlock shared lock.");
		return -1;
	}
	if (!fclose(_fp))
		return 0;
	else {
		fprintf(stdout, "- filestreamstream : cannot close readin file."); 
		return -1;
	}

}

@end
