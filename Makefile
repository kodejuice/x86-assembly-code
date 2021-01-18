source = "(1) max_num.s"
out = asm

# for 32bit code
run32:
	as $(source) --32 -o asm.o
	ld asm.o -melf_i386 -o $(out) && rm asm.o
	echo "./$(out)\n"

run:
	as $(source) -o asm.o
	ld asm.o -o $(out) && rm asm.o
	echo "./$(out)\n"
