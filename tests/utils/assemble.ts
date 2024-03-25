/**
 * nasm -F dwarf -g -f elf32 -o $input_file.o $input_file 
 * ld -m elf_i386 -o $input_file.bin $input_file.o
 * rm $input_file.o
 */

import { spawn, spawnSync } from "bun";

export const assemble = async (file: string) => {
	return new Promise<string>((resolve, reject) => {
		spawn(["nasm", "-F", "dwarf", "-g", "-f", "elf32", "-o", `${file}.o`, file], {
			stderr: "inherit",
			onExit(proc, exitCode, signalCode, error) {
				if (exitCode !== 0) {
					throw new Error(`NASM failed to assemble ${file}`);
				}

				// Looks like nasm sucks and doesn't release the file immediately
				setTimeout(() => {
					spawn(["ld", "-m", "elf_i386", "-o", `${file}.bin`, `${file}.o`], {
						onExit(proc, exitCode, signalCode, error) {
							if (exitCode !== 0) {
								throw new Error("LD failed to link");
							}
							
							resolve(`${file}.bin`);
						}
					})
				}, 50)
			}
		});
	})
}