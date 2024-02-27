#!/bin/bash

compiler=$1
metafile=$2
input_file=$3
watchfiles="$metafile $input_file"

# Usage: ./watch-full-compile.bash <compiler> <metafile> <input_file>

compile() {
	nasm -F dwarf -g -f elf32 -i ./assembly -o $metafile.o $metafile.asm 
	ld -m elf_i386 -o $metafile.bin $metafile.o
	rm $metafile.o
}

while inotifywait -e close_write $watchfiles >/dev/null 2>&1; do
		compiler_output=$($compiler $metafile)

		if [ $? -gt 0 ]; then
			echo "$compiler_output"
			echo "$(date) Run failed - reverting changes"
			continue
		fi

		echo "$compiler_output" > "$metafile.asm"

		compile;

		if [ $? == 0 ]; then
			clear;
			OUTPUT=$($metafile.bin $input_file)
			echo "$OUTPUT"
			echo "$(date) Compilation successful"
			if [ $? -gt 0 ]; then
				echo "$OUTPUT"
				echo "Run failed"
				continue
			fi
		else
			echo "Compilation failed"
			continue
		fi
done