rawfilename="./test"
input_file="./assembly/input.meta"
watchfiles="$rawfilename.asm $input_file"

compile() {
	nasm -F dwarf -g -f elf32 -i ./assembly -o $rawfilename.o $rawfilename.asm 
	ld -m elf_i386 -o $rawfilename $rawfilename.o
	rm $rawfilename.o
}

while inotifywait -e close_write $watchfiles >/dev/null 2>&1; do
		content=$(cat $rawfilename.asm);

		compile;

		if [ $? == 0 ]; then
			echo "Compilation 1 successful"
			OUTPUT=$($rawfilename $input_file)
			if [ $? -gt 0 ]; then
				echo "Run 1 failed - reverting changes"
				echo "$OUTPUT"
				echo "$content" > "$rawfilename.asm"
				continue
			fi
			echo "$OUTPUT" > "$rawfilename.asm"
		else
			echo "Compilation 1 failed"
			continue
		fi

		compile;


		if [ $? == 0 ]; then
			echo "Compilation 2 successful"
			OUTPUT=$($rawfilename $input_file)
			if [ $? -gt 0 ]; then
				echo "Run 2 failed - reverting changes"
				echo "$OUTPUT"
				echo "$content" > "$rawfilename.asm"
				continue
			fi
			echo "$OUTPUT" > "$rawfilename.asm"
		else
			echo "Compilation 2 failed - reverting changes"
			echo "$content" > "$rawfilename.asm"
		fi

		compile;

		if [ $? == 0 ]; then
			echo "Compilation 3 successful"
			OUTPUT=$($rawfilename $input_file)
			if [ $? -gt 0 ]; then
				echo "Run 3 failed - reverting changes"
				echo "$OUTPUT"
				echo "$content" > "$rawfilename.asm"
				continue
			fi
			echo "$OUTPUT" > "$rawfilename.asm"
		else
			echo "Compilation 3 failed - reverting changes"
			echo "$content" > "$rawfilename.asm"
		fi
done