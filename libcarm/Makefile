.SUFFIXES : .o .cc .c

### NOTE needs objc gcc for arm-eabi to compile on the ARM (GBA) itself
CC = gcc 
LD = ld
CFLAGS = -g
INCLUDES = 

CHUNKOBJS = \
	chunk/GBAChunk.o \
	chunk/GBAMemory.o \
	chunk/MemChunk.o \
	chunk/Memory.o \

FSOBJS = \
	fs/DiskTree.o \
	fs/OTree.o

###FIXME GBAOBJS
GBAOBJS = \
	../GBA/src/File.o \

OBJS = \
	Node.o \
	CNode.o \
	GFX.o \
	GFXImage.o \
	GFXWidgets.o \
	Malloc.o \
	String.o \
	FileBuffer.o \
	Tree.o \
	Kernel.o \
	Disk.o \
	RamDisk.o \

all: lib 

text-01:
	@echo "Do you want to compile the full libc ?"

lib: $(OBJS) $(GBAOBJS) $(FSOBJS) $(CHUNKOBJS)
	@echo "+++"
	@echo "libcmacros.m has not been compiled."
	@echo "If you want to overload libc functions for arm processors,"
	@echo "you have to compile this file with (arm) gcc and then link in" 
	@echo "the resulting object code."
	@echo "Try to link in your ARM processors specific code e.g. GBA"
	@echo "+++"
	
	ar rcu carm.a *.o chunk/*.o fs/*.o

clean: 
	rm *.o *.a fs/*.o chunk/*.o

.m.o:
	$(CC) $(CFLAGS) -c $< -o $@

.cc.o :
	$(CC) $(CFLAGS) $(INLCUDES) -c $<
