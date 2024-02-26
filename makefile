rawfilename := ./test

.PHONY: all watch

all: $(rawfilename)

$(rawfilename): $(rawfilename).asm
		nasm -F dwarf -g -f elf32 -i ./assembly -o $@.o $<
		ld -m elf_i386 -o $@ $@.o \
		&& rm $@.o

watch:
		while inotifywait -e close_write $(rawfilename).asm >/dev/null 2>&1; do \
				make all && clear && $(rawfilename) "./assembly/input.meta"; \
		done