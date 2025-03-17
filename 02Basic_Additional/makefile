
ASM := nasm
LD := ld
flags := $(if $(DEBUG),-f elf64 -g -F dwarf,-f elf64)

build_dir := build
src_add_a_b := add_a_b.asm
obj_add_a_b := ${build_dir}/add_a_b.o
executable_add_a_b := ${build_dir}/add_a_b

src_arbitrary_sum_150 := arbitrary_sum_150.asm
obj_arbitrary_sum_150 := ${build_dir}/arbitrary_sum_150.o
executable_arbitrary_sum_150 := ${build_dir}/arbitrary_sum_150

all: make_dir run_add_a_b run_arbitrary_sum_150

run_add_a_b: ${executable_add_a_b}
	./${executable_add_a_b}

${executable_add_a_b}:
	$(LD) -o ${executable_add_a_b} ${obj_add_a_b}

${obj_add_a_b}: ${src_add_a_b}
	$(ASM) $(flags) -o $@ $<


run_arbitrary_sum_150: ${executable_arbitrary_sum_150}
	./${executable_arbitrary_sum_150}

${executable_arbitrary_sum_150}:
	$(LD) -o ${executable_arbitrary_sum_150} ${obj_arbitrary_sum_150}

${obj_arbitrary_sum_150}: ${src_arbitrary_sum_150}
	$(ASM) $(flags) -o $@ $<

make_dir:
	mkdir build -p
