//
// A compiled program is a JavaScript array containing
// instructions as tuples [op-code argument].
//
// Use the array's methods to iterate over the instructions:
//
//   program.forEach(function(instruction) { ... })
//
// Use the object's properties to access the instructions using
// labels:
//
//   pc = program["label"]
//

import { NumberToken } from "./Tokens/NumberToken.js";
import { StringToken } from "./Tokens/StringToken.js";
import { Parser } from "./Parser.js";
import { MetaCompiler } from "./MetaCompiler.js";
import { createMemory, extendMemory } from "./Memory.js";
import { AddressingModes, getAddressingMode } from "./AdressingModes.js";



function getTextSection(lines: string[], memory: DataView, pointers: Record<string, number>, compiler: MetaCompiler) {
	const program = []
	for (const line of lines) {
		// Labels end with a colon
		let trimmedLine = line.trim();
		if (trimmedLine[trimmedLine.length - 1] == ":") {
			const labelProgramCode = parseLabel(trimmedLine);
			program[labelProgramCode] = program.length;
		} else {
			const instruction = parseInstruction(line, memory, pointers, compiler)
			const addressingMode = getAddressingMode(instruction.args[0], instruction.args[1]);

			program.push({...instruction, addressingMode})
		}
	}

	return program
}

function getDataSection(lines: string[], compiler: MetaCompiler, memory: DataView, pointers: Record<string, number>) {
	let currentAddress = 0;
	for (const line of lines) {
		// Names of memory locations end with a colon
		let trimmedLine = line.trim();
		if (trimmedLine[trimmedLine.length - 1] == ":") {
			const label = parseLabel(trimmedLine);
			pointers[label] = currentAddress;
		} else {
			const { args } = parseInstruction(line, memory, pointers, compiler);

			// Iterate over the arguments and store them in memory.
			// If the argument is a string, we need to convert it to ascii
			// and store each character separately.
			for (const arg of args) {
				if (arg instanceof StringToken) {
					const str = arg.value as string;
					// We need to extend the memory by the length of the string + 1 for null termination.
					// To achieve that, we will copy the old memory into a new array.
					const oldMemory = memory;
					memory = extendMemory(oldMemory, str.length + 1);
					// Now we can copy the string into the memory.
					for (let i = 0; i < str.length; i++) {
						memory[currentAddress] = str.charCodeAt(i);
						currentAddress++;
					}
					// Null Terminate the string
					memory[currentAddress] = 0;
					currentAddress++;
				} else if (arg instanceof NumberToken) {
					// We need to extend the memory by the length of the string + 1 for null termination.
					// To achieve that, we will copy the old memory into a new array.
					const oldMemory = memory;
					memory = extendMemory(oldMemory, 1);
					// Now we can copy the string into the memory.
					memory[currentAddress] = arg.value as number;
					currentAddress++;
				} else {
					throw new Error(`Unknown data type ${arg.type}`);
				}
			}
		}
	}

	return {
		pointers: pointers,
		memory,
		currentAddress
	}
}

function getBSSSection(lines: string[], memory: DataView, pointers: Record<string, number>, currentAddress: number, compiler: MetaCompiler) {
	for (const line of lines) {
		// Names of memory locations end with a colon
		const { instruction: variableName, args } = parseInstruction(line, memory, pointers, compiler);
		// Argument 1 needs to contain the "resb" call or similar
		// Argument 2 needs to contain the size of the variable so we can allocate memory for it.
		if (args[0].value == "resb") {
			// We need to extend the memory by the length of the string + 1 for null termination.
			// To achieve that, we will copy the old memory into a new array.
			const oldMemory = memory;
			memory = extendMemory(oldMemory, args[1].value);
			// Now we can copy the string into the memory.
			// Save a pointer to the variable at the current starting address
			pointers[variableName] = currentAddress;
			// Allocate the memory for the variable after the current address
			currentAddress += args[1].value as number;
		}
	}

	return {
		memory,
		currentAddress
	}
}

// PARSER: String -> Program
//
// A program can be represented by a collection of lines.
// A line can be a label starting at column 1 or an instruction
// starting at column 8 composed of an op code of up to 3
// characters and an optional argument.
//
// LABEL  CODE    ADDRESS
// 1- -6  8- -10  12-
//
// Note: Strings are enclosed in simple quotes in assembly code
//       to make the parsing easier for the human and the machine.
//       These quotes are removed here before sending the instruction
//       to the virtual machine.
//
const parse = function (text: string, compiler: MetaCompiler): { program: {
	instruction: string,
	args: any[],
	addressingMode: AddressingModes
}[], pointers: Record<string, number>, memory: DataView } {
	// We split the text at each newline to get an array of lines.
	const lines = text.split("\n");

	// Then we iterate over all lines and add them to our program.
	let sections = {}
	let currentSection = null;
	for (const line of lines) {
		// Skip blank lines.
		if (line.trim().length == 0) {
			continue;
		} else if (line.trim().startsWith(";")) {
			// Ignore comments.
			continue;
		}

		if (line.trim().startsWith(".")) {
			const sectionName = line.trim().substring(1);
			if (sectionName == "text") {
				currentSection = "text";
			} else if (sectionName == "data") {
				currentSection = "data";
			} else if (sectionName == "bss") {
				currentSection = "bss";
			} else {
				throw new Error(`Unknown section ${sectionName}`);
			}

			sections[currentSection] = [];
			continue;
		}

		if (!currentSection) {
			continue;
		}

		sections[currentSection].push(line);
	}

	// We create an array for our program, where each instruction will get put
	// into.
	let memory = createMemory(0);
	const pointers = {}
	let currentAddress = 0;

	const data = getDataSection(sections["data"] || [], compiler, memory, pointers);
	memory = data.memory;
	currentAddress = data.currentAddress;
	const bss = getBSSSection(sections["bss"] || [], memory, pointers, currentAddress, compiler);
	memory = bss.memory;
	currentAddress = bss.currentAddress;
	const program = getTextSection(sections["text"] || [], memory, pointers, compiler);

	return { program, pointers, memory };
};



function parseInstruction(line: string, memory: DataView, pointers: Record<string, number>, compiler: MetaCompiler) {
	// Iterate through the instruction string and split it into parts.
	const instruction = line.trim();
	// Check if there is a space in the line.
	var idx = instruction.indexOf(" ");
	// If there is no space, it's just an instruction without any arguments.
	if (idx === -1) {
		return {
			instruction,
			args: []
		};
	} else {
		let instr = instruction.substring(idx).trim();
		const parser = new Parser(instr, memory, pointers, compiler);

		const args: any[] = [];

		let token: any;
		while (token = parser.getNextToken()) {
			args.push(token);
		}

		return {
			instruction: instruction.slice(0, idx),
			args
		}
	}
}

function parseLabel(line: string): string {
	// Remove the trailing colon.
	return line.trim().substring(0, line.length - 1);
}

export { parse };
