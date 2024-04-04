#!/bin/bash

argv=("$@")
len=${#argv[@]}

if [ $len -lt 2 ]; then
	echo "Usage: ./cascade.bash <compiler> [metafiles...]"
	exit 1
fi

compile() {
	nasm -F dwarf -g -f elf32 -i ./assembly -o $1.o $1.asm
	# Verify that an object file has been created.
	if [ ! -f "$1.o" ]; then
		echo "Failed to compile $1.asm"
		return 1
	fi
	ld -m elf_i386 -o $1.bin $1.o
	chmod +x $1.bin
	rm $1.o
}

while inotifywait -e close_write ${argv[*]} >/dev/null 2>&1; do
		# Iterate over all files and compile them.
		# The last element (n - 1) is always the compiler and the current is the input.
		clear;
		files=("${argv[@]}")
		for (( i=1; i<$len; i++ )); do
			compiler=${files[$i - 1]}
			metafile=${files[$i]}
			
			if (( $i == $len - 1 )); then
				# clear;
				OUTPUT=$($compiler $metafile)
				if [ $? -gt 0 ]; then
					echo "$OUTPUT"
					echo "Last run failed"
					break 1
				else
					echo "$OUTPUT"
					echo "$(date) Compilation successful"
				fi
			else
				compiler_output=$($compiler $metafile)

				if [ $? -gt 0 ]; then
					echo "$compiler_output"
					echo "$(date) Run $i failed"
					break 1
				fi

				echo "$compiler_output" > "$metafile.asm"

				compile $metafile;
				files[$i]="$metafile.bin"

				if [ $? -gt 0 ]; then
					echo "$(date) NASM Compilation failed"
					break 1
				fi
			fi
		done
done