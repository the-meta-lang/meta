#!/bin/bash

input_file=$1
watchfiles="$input_file"

# Usage: ./watch-full-compile.bash <input_file>

while inotifywait -e close_write $watchfiles >/dev/null 2>&1; do
		nasm -F dwarf -g -f elf32 -i ./assembly -o $input_file.o $input_file 
		ld -m elf_i386 -o $input_file.bin $input_file.o
		rm $input_file.o
done