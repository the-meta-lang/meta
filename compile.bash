#!/bin/bash

INPUT_FILE=$1
OUTPUT_FILE=$2

if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
		echo "Usage: compile <INPUT_FILE> <OUTPUT_FILE>"
		exit 1
fi

if [ ! -f $INPUT_FILE ]; then
		echo "Input file does not exist!"
		exit 1
fi

nasm -F dwarf -g -f elf32 -o $INPUT_FILE.o $INPUT_FILE 
ld -m elf_i386 -o $OUTPUT_FILE $INPUT_FILE.o
rm $INPUT_FILE.o