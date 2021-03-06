CC=gcc
CFLAGS=-m32
ASM=nasm
ASMFLAGS=-f elf32

all: build
build:
	$(ASM) $(ASMFLAGS) atoi_func.asm -o atoi_func.o
	$(CC) $(CFLAGS) atoi_func.o -o atoi_func
clear:
	rm atoi_func atoi_func.o
