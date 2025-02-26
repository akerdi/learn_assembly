# run: cd 01Helloworld && make
# debug: cd 01Helloworld && DEBUG=1 make

tool := nasm
flags := $(if $(DEBUG),-f elf64 -g -F dwarf,-f elf64)
link := ld

src := main.asm
obj_files := main.o
executable := main

.PHONY: all clean run

all: ${executable}

run: ${executable}
	./${executable}

debug: ${executable}
	gdb ./${executable}

${executable}: ${obj_files}
	${link} -o $@ $^

%.o: %.asm
	${tool} ${flags} -o $@ $<

clean:
	rm -f ${obj_files} ${executable}
