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
//
//  RamDisk.m
//  libobjcgbarm
//
//  Created by link on 25/10/12.

#import "RamDisk.h"
#import "CNode.h"

@implementation RamDisk

- (NSMutableArray *)dictionary {
	return _writeDict;
}
 
- (int) defineWith:(long int)id and: (char *)name toFormat:(int)fmt {
	
	switch (fmt) {
		//write out to ELF file format (object code)
		case ELF:{
			break;
		}
		//write out to C source file (*.c)
		case CFILE:{
			FILE *fp;
			
			if ((fp = fopen([_currentFileName UTF8String], "w")) == (FILE *)0) {
				fprintf(stderr, "- CFILE : cannot open file."); 
				return -1;
			}
			
			if (flock(fileno(fp), LOCK_SH) < 0) {
				fprintf(stderr, "- CFILE : cannot lock shared lock.");
				return -1;
			}
			
			//goto EOF
			fseek(fp, 0,SEEK_END);
			
			NSMutableString *buf = [[NSMutableString alloc]	initWithString: @"typedef struct "];
			[buf appendString: (NSString*)name];
			[buf appendString: @" {"];
			[buf appendString: @" char *name; "];
			[buf appendString: @" int id; "];
			/////[buf appendString: @" int datalength; "];
			/////[buf appendString: @" void *data; };\n"];
			[buf appendString:STRING(WRITEDATAMAC(name))];
			[buf appendString: @" }; "];
			
			fwrite([buf UTF8String], [buf length], 1, fp);
			
			if (flock(fileno(fp), LOCK_UN) < 0) {
				fprintf(stderr, "- CFILE cannot unlock shared lock.");
				return -1;
			}
			if (!fclose(fp))
				return 0;
			else {
				fprintf(stdout, "- CFILE : cannot close file."); 
				return -1;
			}
			
			break;
		}
		/* 
		 * append id & name to dictionary
		 * (write into run-time C source memory with 
		 * RDMEMORYWRITE macro
		 */
		case MEMORY:{
			// copy above typedef to working block
			[self writeDictAppend:id and: name];	
			break;
		}
			
		default:{
			return -1;
			break;
		}
			
	}
	
	return 0;
	
}

- (Node**) writeDictAppend:(int) id and:(char *)name {
	Node *node = [[Node alloc] ctor:id and:name];
	[_writeDict addObject:node];

	return &node;
}

- (Node*)readDictFrom:(char *)nodeName {
	//--FIXME supply NSEnumerator in libcarm
	int i = -1;
	while ( ++i < [_writeDict count]) {

		//--FIXME char * from int *
		if (strncmp([[[_writeDict objectAtIndex: i] getdata] UTF8String], nodeName, strlen(nodeName)) == 0) {
			return [_writeDict objectAtIndex: i];
		}
	}
	
	return NULL;
}

- (Node*)readDict:(int)id {

	return [_writeDict objectAtIndex: id];

}

- (int *)read:(FileName*)fileName {

	_currentFileName = fileName;
	Node *node = [self readDictFrom:[fileName fileName]];
	_currentId = [node id];

	return [node data];
}

- (Node**)write:(File*)file {

	_currentFileName = [file fileName];
	_currentId ++;

	[self write:[file data]];
	return ([self writeDictAppend:_currentId and:[_currentFileName UTF8String]]);

}

- (void)writeData:(NSString*)data {
	[[_writeDict objectAtIndex:_currentId] setData:(NSString*)data];
}
 
- (void)defrag {
	//--FIXME dictionary will be defragged and currentid will change this way
}

@end


