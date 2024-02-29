compiler_asm=$1
grammar_file=$2
watchfiles="$compiler_asm $grammar_file"

if [ -z "$compiler_asm" ]; then
	echo "Usage: ./watch-compile-self.bash <compiler_asm> <grammar_file>"
	exit 1
fi

if [ -z "$grammar_file" ]; then
	echo "Usage: ./watch-compile-self.bash <compiler_asm> <grammar_file>"
	exit 1
fi

compile() {
	nasm -F dwarf -g -f elf32 -i ./assembly -o $compiler_asm.o $compiler_asm 
	ld -m elf_i386 -o $compiler_asm.bin $compiler_asm.o
	rm $compiler_asm.o
}

await_first_change() {
	while inotifywait -e close_write $watchfiles >/dev/null 2>&1; do
		clear;
		content=$(cat $compiler_asm);

		compile;

		if [ $? == 0 ]; then
			echo "Compilation successful - running..."
			OUTPUT=$($compiler_asm.bin $grammar_file)
			# Try to run the newly compiled program.
			# if it fails, revert the changes
			if [ $? -gt 0 ]; then
				echo "Run 1 failed - reverting changes"
				echo "$OUTPUT"
				echo "$content" > "$compiler_asm"
				continue
			fi

			echo "Run successful - awaiting input file change to implement new features..."
			echo "$OUTPUT" > "$compiler_asm"
			await_implementation_change;
			break;

		else
			echo "Compilation 1 failed - reverting changes"
			echo "$content" > "$compiler_asm"
			continue
		fi
	done
}

await_implementation_change() {
	while inotifywait -e close_write $watchfiles >/dev/null 2>&1; do
		clear;
		compile;

		if [ $? == 0 ]; then
			echo "Compilation successful - running..."
			OUTPUT=$($compiler_asm.bin $grammar_file)
			# Try to run the newly compiled program.
			# if it fails, revert the changes
			if [ $? -gt 0 ]; then
				echo "Implementation run failed - reverting changes"
				echo "$OUTPUT"
				echo "$content" > "$compiler_asm"
				continue
			fi

			echo "Run successful - program is ready for new compilation run..."
			echo "$OUTPUT" > "$compiler_asm"
			await_first_change;
			break;

		else
			echo "Compilation 2 failed - reverting changes"
			echo "$content" > "$compiler_asm"
			continue
		fi
	done
}

await_first_change;