rawfilename := ./assembly/main

.PHONY: all watch

all: $(rawfilename)

$(rawfilename): $(rawfilename).asm
    nasm -F dwarf -g -f elf32 -i ./assembly -o $@.o $<
    ld -m elf_i386 -o $@ $@.o

watch:
    while inotifywait -e close_write $(rawfilename).asm; do \
        make all && cat ./assembly/input.meta | ./assembly/main; \
    done
