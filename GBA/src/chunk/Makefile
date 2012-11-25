.SUFFIXES : .o .cc .c

### NOTE needs objc gcc for arm-eabi to compile on the ARM (GBA) itself
CC = gcc 
LD = ld
CFLAGS = -g
INCLUDES = -I../../include -I../../../libcarm/  -I../../../libcarm/chunk

GBACHUNKOBJS = \
	GBAChunk.o \
	GBAMemory.o \

all: lib 

lib: $(OBJS) $(GBAOBJS) $(GBACHUNKOBJS)
	@echo "+++"
	@echo "+++"
	
	###ar rcu gba.a *.o

clean: 
	rm *.o *.a

.m.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
