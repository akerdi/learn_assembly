
ASM := nasm
flags :=
LD := ld

build_dir := build
src := main.asm
obj_files := ${build_dir}/main.o
executable := ${build_dir}/main

run: make_dir ${executable}
	./${executable}

debug: DEBUG=1
debug: make_dir ${executable}
	gdb ./${executable}

${executable}: ${obj_files}
	${LD} -o $@ $^

${build_dir}/%.o: %.asm
	$(eval flags := $(if $(DEBUG),-f elf64 -g -F dwarf,-f elf64))
	${ASM} ${flags} -o $@ $<

make_dir:
	mkdir ${build_dir} -p

clean:
	rm -f ${obj_files} ${executable}