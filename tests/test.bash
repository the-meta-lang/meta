#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
COMPILER_BIN="$SCRIPT_DIR/../bootstrap/meta.bin";

if [[ $SCRIPT_DIR != "" ]]; then
	TMP_DIR="$SCRIPT_DIR/tmp"
	# Remove old tests
	rm -rf $TMP_DIR
	mkdir -p $TMP_DIR
else
	echo "Hey! We ain't gonna remove the /tmp directory, are we?!"
fi

function compile() {
	IN=$1
	OUT=$2
	# Compile the code file
	$COMPILER_BIN "$IN" > "$OUT"

	OUTFOLDER=$(dirname "$OUT")
	BASENAME=$(basename -- "$OUT")
	OUTFILE="${BASENAME%.*}"

	BINARY_OUT="$OUTFOLDER/$OUTFILE.bin"

	nasm -F dwarf -g -f elf32 -o $OUT.o $OUT 
	ld -m elf_i386 -o "$BINARY_OUT" $OUT.o
	rm $OUT.o

	echo "$BINARY_OUT"
}

function test_backtracking() {
	OUTPUT="$($(compile "$SCRIPT_DIR/backtracking/grammar.meta" "$TMP_DIR/backtracking.asm") "$SCRIPT_DIR/backtracking/input.txt")"
	assert_equals "$(cat "$SCRIPT_DIR/backtracking/output.txt")" "$OUTPUT"
}

function test_basic_tokens() {
	OUTPUT="$($(compile "$SCRIPT_DIR/basic-tokens/grammar.meta" "$TMP_DIR/basic-tokens.asm") "$SCRIPT_DIR/basic-tokens/input.txt")"
	assert_equals "$(cat "$SCRIPT_DIR/basic-tokens/output.txt")" "$OUTPUT"
}

function test_import() {
	OUTPUT="$($(compile "$SCRIPT_DIR/import/grammar.meta" "$SCRIPT_DIR/import/import.asm") "$SCRIPT_DIR/import/input.txt")"
	assert_equals "$(cat "$SCRIPT_DIR/import/output.txt")" "$OUTPUT"
}

function test_loops() {
	OUTPUT="$($(compile "$SCRIPT_DIR/loops/grammar.meta" "$TMP_DIR/loops.asm") "$SCRIPT_DIR/loops/input.txt")"
	assert_equals "$(cat "$SCRIPT_DIR/loops/output.txt")" "$OUTPUT"
}

function test_or() {
	OUTPUT="$($(compile "$SCRIPT_DIR/or/grammar.meta" "$TMP_DIR/or.asm") "$SCRIPT_DIR/or/input.txt")"
	assert_equals "$(cat "$SCRIPT_DIR/or/output.txt")" "$OUTPUT"
}

function test_string_matching() {
	OUTPUT="$($(compile "$SCRIPT_DIR/string-matching/grammar.meta" "$TMP_DIR/string-matching.asm") "$SCRIPT_DIR/string-matching/input.txt")"
	assert_equals "$(cat "$SCRIPT_DIR/string-matching/output.txt")" "$OUTPUT"
}

function test_tokens() {
	OUTPUT="$($(compile "$SCRIPT_DIR/tokens/grammar.meta" "$TMP_DIR/tokens.asm") "$SCRIPT_DIR/tokens/input.txt")"
	assert_equals "$(cat "$SCRIPT_DIR/tokens/output.txt")" "$OUTPUT"
}