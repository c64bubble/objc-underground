.SUFFIXES : .o .cc .c

### NOTE needs objc gcc for arm-eabi to compile on the ARM (GBA) itself
CC = gcc 
LD = ld
CFLAGS = -g
INCLUDES = 

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
	File.o \
	OTree.o \

all: lib 

text-01:
	@echo "Do you want to compile the full libc ?"

lib: $(OBJS)
	@echo "+++"
	@echo "libcmacros.m has not been compiled."
	@echo "If you want to overload libc functions for arm processors,"
	@echo "you have to compile this file with (arm) gcc and then link in" 
	@echo "the resulting object code."
	@echo "+++"
	
	ar rcu carm.a *.o

clean: 
	rm *.o *.a

.m.o:
	$(CC) $(CFLAGS) -c $< -o $@

.cc.o :
	$(CC) $(CFLAGS) $(INLCUDES) -c $<
