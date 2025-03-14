# run: cd 01Helloworld && make
# debug: cd 01Helloworld && DEBUG=1 make

ASM := nasm
flags := $(if $(DEBUG),-f elf64 -g -F dwarf,-f elf64)
LD := ld

src := main.asm
obj_files := main.o
executable := main

.PHONY: all clean run

all: ${executable}
	./${executable}

run: ${executable}
	./${executable}

debug: ${executable}
	gdb ./${executable}

${executable}: ${obj_files}
	${LD} -o $@ $^

%.o: %.asm
	${ASM} ${flags} -o $@ $<

clean:
	rm -f ${obj_files} ${executable}
