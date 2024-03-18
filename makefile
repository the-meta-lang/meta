rawfilename := ./test

.PHONY: all watch

all: $(rawfilename)

$(rawfilename): $(rawfilename).asm
		nasm -F dwarf -g -f elf32 -i ./assembly -o $@.o $<
		ld -m elf_i386 -o $@ $@.o \
		&& rm $@.o

compile:
	nasm -F dwarf -g -f elf32 -i ./assembly -o $(target).o $(target) \
	&& ld -m elf_i386 -o $(out) $(target).o \
	&& rm $(target).o

watch:
		while inotifywait -e close_write $(rawfilename).asm >/dev/null 2>&1; do \
				make all && clear && $(rawfilename) "./assembly/input.meta"; \
		done

watch-compile-gyro:
	bash ./watch-full-compile.bash ./bootstrap/meta ./gyro/gyro.meta ./gyro/gyro-test.txt

bundle:
	cd bin && rm -f ../release/meta-linux-x64.zip && zip -r ../release/meta-linux-x64.zip ./meta-linux-x64/meta