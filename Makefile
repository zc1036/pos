
CC:=clang-7
CXX:=clang++-7
OBJCOPY:=llvm-objcopy-7
CFLAGS:=-Wall -O2 -ffreestanding -nostdinc -nostdlib
CXXFLAGS:=$(CFLAGS)
LD:=ld.lld-7
IC:=/home/beck/code/ivy/src/test.sh

OBJS := start.o main.o stack.o

all: kernel8.img

.SUFFIXES:
.PRECIOUS: %.ic.c

%.ic.c: %.ic
	$(IC) --target c $< >$@ || (rm -f $@; false)

%.o: %.ic.c
	$(CC) -c --target=aarch64-elf $(CFLAGS) $< -o $@

%.o: %.S
	$(CC) --target=aarch64-elf $(CFLAGS) -c $< -o $@

kernel8.elf: $(OBJS)
	$(LD) -m aarch64elf -nostdlib $^ -T linker.ld -o $@

kernel8.img: kernel8.elf
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f kernel8.img kernel8.elf *.o *.oc *.ic.c

run:
	qemu-system-aarch64 -M raspi3 -kernel kernel8.img -d in_asm
