
ASM := nasm
LD := ld
flags := $(if $(DEBUG),-f elf64 -g -F dwarf,-f elf64)

all: run_add_a_b run_arbitrary_sum_150

run_add_a_b: build_add_a_b
	./build/add_a_b

build_add_a_b: make_dir
	$(ASM) $(flags) -o build/add_a_b.o add_a_b.asm
	$(LD) -o build/add_a_b build/add_a_b.o

make_dir:
	mkdir build -p

run_arbitrary_sum_150: build_arbitrary_sum_150
	./build/arbitrary_sum_150

build_arbitrary_sum_150: make_dir
	$(ASM) $(flags) -o build/arbitrary_sum_150.o arbitrary_sum_150.asm
	$(LD) -o build/arbitrary_sum_150 build/arbitrary_sum_150.o
