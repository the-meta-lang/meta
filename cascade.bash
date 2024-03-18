#!/bin/bash

argv=("$@")
len=${#argv[@]}

if [ $len -lt 2 ]; then
	echo "Usage: ./cascade.bash <compiler> [metafiles...]"
	exit 1
fi

compile() {
	nasm -F dwarf -g -f elf32 -i ./assembly -o $1.o $1.asm 
	ld -m elf_i386 -o $1.bin $1.o
	rm $1.o
}

while inotifywait -e close_write ${argv[*]} >/dev/null 2>&1; do
		# Iterate over all files and compile them.
		# The last element (n - 1) is always the compiler and the current is the input.
		clear;
		for (( i=1; i<$len; i++ )); do
			compiler=${argv[$i - 1]}
			metafile=${argv[$i]}
			
			if (( $i == $len - 1 )); then
				# clear;
				OUTPUT=$($compiler ${argv[$i]})
				if [ $? -gt 0 ]; then
					echo "$OUTPUT"
					echo "Run failed"
					break 1
				else
					echo "$OUTPUT"
					echo "$(date) Compilation successful"
				fi
			else
				compiler_output=$($compiler $metafile)

				if [ $? -gt 0 ]; then
					echo "$compiler_output"
					echo "$(date) Run failed - reverting changes"
					break 1
				fi

				echo "$compiler_output" > "$metafile.asm"

				compile $metafile;
				argv[$i]="$metafile.bin"

				if [ $? == 0 ]; then
					echo "$compiler_output"
					echo "$(date) Compilation successful"
				else
					echo "Compilation failed"
					break 1
				fi
			fi
		done
done