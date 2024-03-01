#!/bin/bash

input_file=$1

# Usage: ./compile <input_file>

nasm -F dwarf -g -f elf32 -o $input_file.o $input_file 
ld -m elf_i386 -o $input_file.bin $input_file.o
rm $input_file.o