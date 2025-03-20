
ASM := nasm
LD := ld
CC := gcc
flags :=

build_dir := build

src_c_casm := casm.asm casm.c
obj_casm := ${build_dir}/casm.c.o ${build_dir}/casm.asm.o
casm_exec := ${build_dir}/casm
links := -lc

run: make_dir ${casm_exec}
	./${casm_exec}

debug: DEBUG=1
debug: make_dir ${casm_exec}
	gdb ./${casm_exec}
    # (gdb) run

${casm_exec}: ${obj_casm}
	echo "Linking $@: $^"
	${CC} -o $@ $^

$(filter %.asm.o,$(obj_casm)): $(filter %.asm,$(src_c_casm))
	echo "Compiling $@: $<"
	$(eval flags := $(if $(DEBUG),-f elf64 -g -F dwarf,-f elf64))
	${ASM} ${flags} -o $@ $<
${filter %.c.o,$(obj_casm)}: $(filter %.c,$(src_c_casm))
	echo "Compiling $@: $<"
	${CC} -c -o $@ $<

make_dir:
	mkdir ${build_dir} -p

clean:
	rm -f ${obj_casm} ${casm_exec}