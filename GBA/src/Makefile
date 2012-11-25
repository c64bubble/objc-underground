.SUFFIXES : .o .cc .c

### NOTE needs objc gcc for arm-eabi to compile on the ARM (GBA) itself
CC = gcc 
LD = ld
CFLAGS = -g
INCLUDES = -I../include -I../../libcarm/  -I../../libobjcgbarm/src/

GBAOBJS = \
	GBAFile.o \
	GBARam.o \
	GBASecureRam.o \
	GBASecureRamDisk.o \

all: lib 

lib: $(OBJS) $(GBAOBJS) $(GBACHUNKOBJS)
	@echo "+++"
	cd chunk; make; cd ..
	@echo "+++"
	
	###ar rcu gba.a *.o

clean: 
	rm *.o chunk/*.o *.a

.m.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
