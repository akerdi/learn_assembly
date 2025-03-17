# run: cd 01Helloworld && make
# debug: cd 01Helloworld && DEBUG=1 make


ASM := nasm
flags :=
LD := ld

src := main.asm
obj_files := main.o
executable := main

run: ${executable}
	./${executable}

debug: DEBUG=1
debug: ${executable}
	gdb ./${executable}

${executable}: ${obj_files}
	${LD} -o $@ $^

%.o: %.asm
	$(eval flags := $(if $(DEBUG),-f elf64 -g -F dwarf,-f elf64))
	${ASM} ${flags} -o $@ $<

clean:
	rm -f ${obj_files} ${executable}