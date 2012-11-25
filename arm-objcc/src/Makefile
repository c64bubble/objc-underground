.SUFFIXES : .o .cc .c

### NOTE needs objc gcc for arm-eabi to compile on the ARM (GBA) itself
CC = gcc 
LD = ld
CFLAGS = -g
INCLUDES = -I../../GBA/src/ -I../../GBA/include 

OBJS = \
Structure.o \
StructureBracket.o \
ArmCompiler.o \
ArmScanner.o \
ArmSubCompiler.o \
ArmSubScanner.o \
ArmCompilerBase.o \
ArmObjCCompiler.o \
ClassLocator.o \
Compiler.o \
Dispatcher.o \
Error.o \
FileName.o \
FileStream.o \
Fuzzy.o \
Object.o \
GBAObject.o \
HashTable.o \
HashTableStrings.o \
MethodName.o \
MethodNameArray.o \
ObjectLocator.o \
ParseString.o \
Scanner.o \
Status.o \
TypeName.o \
TypeNameArray.o \
Data.o \
DataArray.o \
scansystem.o \

LIBMEMORYOBJS = \
libmemory/GBAChunk.o \
libmemory/GBAMemory.o \
libmemory/MemChunk.o \
libmemory/Memory.o \

all: lib 

lib: $(OBJS) ######FIXME now in libcarm/fs $(LIBMEMORYOBJS)
	@echo "+++"
	@echo "+++"
	
	ar rcu carm.a *.o

clean: 
	rm *.o *.a

.m.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
