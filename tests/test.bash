#!/bin/bash

# Get the compiler binary to use for all compilations from the cmdline args
if [ $# -eq 0 ]; then
		echo "Usage: $0 <compiler-binary>"
		exit 1
fi

# Set the compiler binary
COMPILER_BIN=$1

# Get the start time in millis
START_TIME=$(date +%s%3N)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# Create a tmp directory to store build artifacts.
mkdir -p "$SCRIPT_DIR/tmp"

# Get a list of all tests
TESTS=$(find "$SCRIPT_DIR/assets" -mindepth 1 -type d)

echo -e "Running $(echo "$TESTS" | wc -l) tests\n"

FAILED_TESTS=0

# Run all tests
for TEST in $TESTS; do
		# Get the test name
		TEST_NAME=$(basename "$TEST")
		echo -e "Running test: $TEST_NAME"
		# Create a directory for the test
		TMP_DIR="$SCRIPT_DIR/tmp/$TEST_NAME"
		mkdir -p $TMP_DIR
		# Run the test
		# First we need to grab the grammar file
		cp "$TEST/grammar.meta" "$TMP_DIR/grammar.meta"
		# Then we need to compile the grammar file
		$COMPILER_BIN "$TMP_DIR/grammar.meta" > "$TMP_DIR/grammar.asm"
		# And compile the generated assembly
		FILE="$TMP_DIR/grammar.asm"

		nasm -F dwarf -g -f elf32 -o $FILE.o $FILE 
		ld -m elf_i386 -o "$TMP_DIR/grammar.bin" $FILE.o
		rm $FILE.o

		# Now we can run the compiler on the input file
		cp "$TEST/input.txt" "$TMP_DIR/input.txt"

		OUTPUT=$("$TMP_DIR/grammar.bin" "$TMP_DIR/input.txt")
		echo "$OUTPUT" > "$TMP_DIR/output.txt"
		# Finally we can compare the output to the expected output
		EXPECTED=$(cat "$TEST/output.txt")
		RECEIVED=$(cat "$TMP_DIR/output.txt")
		# Assert that the output is correct
		if [ "$EXPECTED" != "$RECEIVED" ]; then
				echo -e "\033[A\033[2K\r\x1b[37;41;1m[ FAILED ]\x1b[0m: $TEST_NAME (log: $TMP_DIR/diff.txt)"
				FAILED_TESTS=$((FAILED_TESTS + 1))
				DIFF=$(diff "$TMP_DIR/output.txt" "$TEST/output.txt")
				# Write the diff into a log
				echo "$DIFF" > "$TMP_DIR/diff.txt"
		else
				# Clear the line before printing
				echo -e "\033[A\033[2K\r\x1b[37;42;1m[ PASSED ]\x1b[0m: $TEST_NAME"
		fi
done

# Get the end time in millis
END_TIME=$(date +%s%3N)

# Calculate the duration
DURATION=$((END_TIME - START_TIME))

# Print the duration
echo -e "\nTime Taken: $DURATION ms"

# Print the number of failed tests
if [ $FAILED_TESTS -eq 0 ]; then
		echo -e "\x1b[37;42;1mAll tests passed\x1b[0m"
else
		echo -e "\x1b[37;41;1mTests Failed: $FAILED_TESTS\x1b[0m"
fi

# Exit with the number of failed tests
exit $FAILED_TESTS