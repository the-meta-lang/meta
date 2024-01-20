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

import { Pointer } from "./Tokens/Pointer.js";
import { Register } from "./Tokens/RegisterToken.js";
import { NumberToken } from "./Tokens/NumberToken.js";
import { StringToken } from "./Tokens/StringToken.js";
import { Identifier } from "./Tokens/IdentifierToken.js";
import { Registers } from "./types.js";

function getTextSection(lines: string[], memory: Uint16Array, pointers: Record<string, number>, registers: Registers) {
	const program = []
	for (const line of lines) {
		// Labels end with a colon
		let trimmedLine = line.trim();
		if (trimmedLine[trimmedLine.length - 1] == ":") {
			const labelProgramCode = parseLabel(trimmedLine);
			program[labelProgramCode] = program.length;
		} else {
			program.push(parseInstruction(line, memory, pointers, registers));
		}
	}

	return program
}

function getDataSection(lines: string[], registers: Registers, memory: Uint16Array, pointers: Record<string, number>) {
	let currentAddress = 0;
	for (const line of lines) {
		// Names of memory locations end with a colon
		let trimmedLine = line.trim();
		if (trimmedLine[trimmedLine.length - 1] == ":") {
			const label = parseLabel(trimmedLine);
			pointers[label] = currentAddress;
		} else {
			const { instruction: dataType, args } = parseInstruction(line, memory, pointers, registers);

			// Iterate over the arguments and store them in memory.
			// If the argument is a string, we need to convert it to ascii
			// and store each character separately.
			for (const arg of args) {
				if (arg instanceof StringToken) {
					const str = arg.value as string;
					// We need to extend the memory by the length of the string + 1 for null termination.
					// To achieve that, we will copy the old memory into a new array.
					const oldMemory = memory;
					memory = new Uint16Array(currentAddress + str.length + 1);
					memory.set(oldMemory);
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
					memory = new Uint16Array(currentAddress + 1);
					memory.set(oldMemory);
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

function getBSSSection(lines: string[], memory: Uint16Array, pointers: Record<string, number>, currentAddress: number, registers: Registers) {
	for (const line of lines) {
		// Names of memory locations end with a colon
		const { instruction: variableName, args } = parseInstruction(line, memory, pointers, registers);
		// Argument 1 needs to contain the "resb" call or similar
		// Argument 2 needs to contain the size of the variable so we can allocate memory for it.
		if (args[0].value == "resb") {
			// We need to extend the memory by the length of the string + 1 for null termination.
			// To achieve that, we will copy the old memory into a new array.
			const oldMemory = memory;
			memory = new Uint16Array(currentAddress + args[1].value);
			memory.set(oldMemory);
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
const parse = function (text: string, registers: Registers): { program: {
	instruction: string,
	args: any[]
}[], pointers: Record<string, number>, memory: Uint16Array } {
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
	let memory = new Uint16Array(0);
	const pointers = {}
	let currentAddress = 0;

	const data = getDataSection(sections["data"] || [], registers, memory, pointers);
	memory = data.memory;
	currentAddress = data.currentAddress;
	const bss = getBSSSection(sections["bss"] || [], memory, pointers, currentAddress, registers);
	memory = bss.memory;
	currentAddress = bss.currentAddress;
	const program = getTextSection(sections["text"] || [], memory, pointers, registers);

	return { program, pointers, memory };
};

class Parser {
	private currentChar: string;
	private input: string;
	private index: number;

  constructor(input: string, private memory: Uint16Array, private pointers: Record<string, number>, private registers: Registers) {
    this.input = input;
    this.index = 0;
    this.currentChar = this.input[this.index];
  }

  advance() {
    this.index++;
    if (this.index < this.input.length) {
      this.currentChar = this.input[this.index];
    } else {
      this.currentChar = null;
    }
  }

  skipWhitespace() {
    while (this.currentChar && /\s/.test(this.currentChar)) {
      this.advance();
    }
  }

  parseString() {
    let result = '';
    this.advance(); // Skip the opening double quote

    while (this.currentChar && this.currentChar !== '"') {
      result += this.currentChar;
      this.advance();
    }

    this.advance(); // Skip the closing double quote
    return new StringToken(`"${result}"`, result);
  }

  parseNumber() {
    let result = '';

    while (this.currentChar && /\d|\./.test(this.currentChar)) {
      result += this.currentChar;
      this.advance();
    }

    return new NumberToken(result, parseFloat(result));
  }

  parseVariableReference() {
    let result = '';
    this.advance(); // Skip the opening square bracket

    while (this.currentChar && this.currentChar !== ']') {
      result += this.currentChar;
      this.advance();
    }


    this.advance(); // Skip the closing square bracket
    return new Pointer(`[${result}]`, result, this.pointers[result], this.memory);
  }

	parseIdentifier() {
		let result = "";
		while (this.currentChar && /[a-zA-Z0-9_]/.test(this.currentChar)) {
			result += this.currentChar;
			this.advance();
		}

		if (this.registers.hasOwnProperty(result)) {
			return new Register(result, this.registers);
		} else {
			return new Identifier(result);
		}
	}

	parseHex() {
		let result = "";
		while (this.currentChar && /[a-fA-F0-9]/.test(this.currentChar)) {
			result += this.currentChar;
			this.advance();
		}

		return new NumberToken(result, parseInt(result, 16));
	}

  getNextToken() {
    this.skipWhitespace();

    if (!this.currentChar) {
      return null;
    }

		if (this.currentChar == ";") {
			// Comment
			this.advance();
			while (this.currentChar && this.currentChar != "\n") {
				this.advance();
			}
			this.advance();
			return null;
		}

		if (this.currentChar == ",") {
			// Argument separator.
			this.advance();
			this.skipWhitespace()
		}

    if (this.currentChar === '"') {
      return this.parseString();
    }

		if (this.currentChar === "0") {
			this.advance();
			if ((this.currentChar as string) === "x") {
				this.advance();
				return this.parseHex();
			} else {
				throw new Error("Unknown number format");
			}
		}

    if (/\d/.test(this.currentChar)) {
      return this.parseNumber();
    }

    if (this.currentChar === '[') {
      return this.parseVariableReference();
    }

		return this.parseIdentifier()
  }
}

function parseInstruction(line: string, memory: Uint16Array, pointers: Record<string, number>, registers: Registers) {
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
		const parser = new Parser(instr, memory, pointers, registers);

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
