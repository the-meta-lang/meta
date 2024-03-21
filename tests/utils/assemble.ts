/**
 * nasm -F dwarf -g -f elf32 -o $input_file.o $input_file 
 * ld -m elf_i386 -o $input_file.bin $input_file.o
 * rm $input_file.o
 */

import { spawnSync } from "bun";

export const assemble = async (file: string) => {
	const process = spawnSync(["nasm", "-F", "dwarf", "-g", "-f", "elf32", "-o", `${file}.o`, file], {
		stderr: "inherit"
	});

	if (process.exitCode !== 0) {
		throw new Error("NASM failed to assemble");
	}

	const ld = spawnSync(["ld", "-m", "elf_i386", "-o", `${file}.bin`, `${file}.o`]);

	if (ld.exitCode !== 0) {
		throw new Error("LD failed to link");
	}

	spawnSync(["rm", `${file}.o`]);

	return `${file}.bin`;
}