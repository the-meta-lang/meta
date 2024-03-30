#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
COMPILER_BIN="$SCRIPT_DIR/../lisp.meta.bin";

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

function test_defunc() {
	OUTPUT=$($(compile "$SCRIPT_DIR/defunc/defunc.mlisp" "$TMP_DIR/defunc.asm"))
	assert_equals "$OUTPUT" "Hello, World!"
}

function test_math() {
	PLUS=$($(compile "$SCRIPT_DIR/math/plus.mlisp" "$TMP_DIR/plus.asm"));
	assert_equals 7 $? "Addition"
	PLUS=$($(compile "$SCRIPT_DIR/math/minus.mlisp" "$TMP_DIR/minus.asm"));
	assert_equals 13 $? "Subtraction"
	PLUS=$($(compile "$SCRIPT_DIR/math/multiply.mlisp" "$TMP_DIR/multiply.asm"));
	assert_equals 12 $? "Multiplication"
	PLUS=$($(compile "$SCRIPT_DIR/math/divide.mlisp" "$TMP_DIR/divide.asm"));
	assert_equals 3 $? "Division"
	PLUS=$($(compile "$SCRIPT_DIR/math/modulo.mlisp" "$TMP_DIR/modulo.asm"));
	assert_equals 3 $? "Modulo"
}

function test_logic() {
	AND=$($(compile "$SCRIPT_DIR/logic/and.mlisp" "$TMP_DIR/and.asm"));
	assert_equals 32 $? "AND"
	OR=$($(compile "$SCRIPT_DIR/logic/or.mlisp" "$TMP_DIR/or.asm"));
	assert_equals 24 $? "OR"
	NOT=$($(compile "$SCRIPT_DIR/logic/not.mlisp" "$TMP_DIR/not.asm"));
	assert_equals 2 $? "NOT"
}

function test_control_flow() {
	IF=$($(compile "$SCRIPT_DIR/control_flow/if.mlisp" "$TMP_DIR/if.asm"));
	assert_equals 4 $? "IF"
	WHILE=$($(compile "$SCRIPT_DIR/control_flow/while.mlisp" "$TMP_DIR/while.asm"));
	assert_equals 10 $? "WHILE"
}

function tear_down_after_script() {
	if [[ _TESTS_FAILED -eq 0 ]]; then
		rm -rf $TMP_DIR
	fi
}