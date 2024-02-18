import { Scanner } from "./Scanner.js";
import { Builder } from "./Builder.js";
import { parse } from "./parse.js";
import { error } from "./error-handler.js";
import * as fs from "fs"
import {
	CompilerOptions,
	CompilerOutput,
	Issue,
	RegisterName,
	Step,
} from "./types.js";
import { Register } from "./Tokens/RegisterToken.js";
import { Pointer } from "./Tokens/Pointer.js";
import { StringToken } from "./Tokens/StringToken.js";
import { NumberToken } from "./Tokens/NumberToken.js";
import { Identifier } from "./Tokens/IdentifierToken.js";
import { createMemory, readFromMemory, readStringFromMemory } from "./Memory.js";
import { AddressingModes } from "./AdressingModes.js";

const STDIN = 0x00;
const STDOUT = 0x01;

const FILE_READ = 0x00;
const FILE_WRITE = 0x04;

//
// The META II virtual machine runs compilers
// compiled with the META II grammar.
//
class MetaCompiler {
	private input: Scanner;
	private output: Builder;
	private stack: any[];
	private nextGN1: number;
	private nextGN2: number;
	private done: boolean;
	private branch: boolean;
	private program: {
		instruction: string,
		args: (Register | NumberToken | StringToken | Pointer)[],
		addressingMode: AddressingModes
	}[];
	private source: string;
	private instructionCount: number = 0;
	private environment: { [key: string]: any } = {};
	public options: CompilerOptions;
	public instructions = {
		"mov": 0x01
	}

	/**
	 * 32 bit Flags register mapping:
	 * X X X X OF DF IF TF SF ZF X AF X PF X CF X X X X X X X X X X X X X X X X
	 * OF - Overflow Flag
	 * DF - Direction Flag
	 * IF - Interrupt Enable Flag
	 * TF - Trap Flag
	 * SF - Sign Flag
	 * ZF - Zero Flag
	 * AF - Auxiliary Carry Flag
	 * PF - Parity Flag
	 * CF - Carry Flag
	 */
	public registerNames: RegisterName[] = [
		"eip", "esp", "ebp", "eax", "ebx", "ecx", "edx", "edi", "esi", "flags"
	]

	public registerMap: Record<RegisterName, number> = this.registerNames.reduce((acc, name, i) => {
		// Get the memory offset for the register
		acc[name] = i * 2;
		return acc;
	}, {})

	// Reserve memory for the registers.
	// Each register is 8 bits wide.
	public registers = createMemory(this.registerNames.length * 2);

	public issues: Issue[];
	private pointers: Record<string, number>
	private memory: DataView;

	public getRegister(name: RegisterName) {
		if (!(name in this.registerMap)) {
			throw new Error(`Register ${name.toString()} does not exist`);
		}

		return this.registers.getUint16(this.registerMap[name]);
	}

	public setRegister(name: RegisterName, value: number) {
		if (!(name in this.registerMap)) {
			throw new Error(`Register ${name} does not exist`);
		}

		this.registers.setUint16(this.registerMap[name], value);
	}

	public fetch() {
		const nextInstructionAddress = this.getRegister("eip");
		const instruction = this.memory.getUint16(nextInstructionAddress);
		this.setRegister("eip", nextInstructionAddress + 2);
		return instruction;
	}

	constructor(private assembly: string) {
		const { program, pointers, memory } = parse(assembly, this);
		this.program = program;
		this.pointers = pointers;
		this.memory = memory;
	}

	private _pc = 0;

	get pc() {
		return this._pc
	}

	set pc(value: number) {
		this._pc = value
	}

	public step(): Step {
		if (this.done) {
			return;
		}

		if (!this.program[this.pc]) {
			this.error(`Invalid program counter: ${this.pc}`);
		}

		var { instruction, args, addressingMode } = this.program[this.pc];

		if (this.options.debugMode) {
			console.log(instruction);
		}

		if (!instruction) {
			this.error(`Malformed instruction: ${instruction}`);
		}

		if (!this[instruction]) {
			this.error(`Call to undefined instruction: ${instruction}`);
		}

		this[instruction](...args, addressingMode);
		this.instructionCount++;
		

		// If the current line is registered as a breakpoint,
		// stop execution and emit a "breakpoint" event.
		let lineno = this.input.getLine();
		let colno = this.input.getColumn();

		return {
			lineno,
			colno,
			pc: this.pc,
			instruction: instruction,
			metadata: {
				args: args.map(arg => arg.raw)
			}
		};
	}

	public init(content: string, options: CompilerOptions) {
		this.output = new Builder();
		this.pc = 0;
		this.stack = [];
		this.nextGN1 = 0;
		this.nextGN2 = 0;
		this.done = false;
		this.setZeroFlag(false)
		this.input = new Scanner(content);
		this.instructionCount = 0;
		this.options = Object.assign(
			{
				debugMode: false,
				performanceMetrics: false,
				emitWhitespace: true,
			},
			options
		);
	}

	private getZeroFlag(): boolean {
		return (this.getRegister("flags") & 0b00000100) == 0 ? false : true;
	}

	private setZeroFlag(value: boolean) {
		if (value === true) {
			const flags = this.getRegister("flags")
			this.setRegister("flags", flags | 0b00000100);
		} else {
			const flags = this.getRegister("flags")
			this.setRegister("flags", flags & 0b11111011);
		}
	}

	private steps: Step[] = []

	public compile(source: string = ""): CompilerOutput {
		const timeStarted = Number(process.hrtime.bigint()) / 1000000;
		this.source = source;

		let step: Step;
		while (step = this.step()) {
			this.steps.push(step);
		}

		let performance: CompilerOutput["metrics"]["performance"] = null;

		let totalInstructions = this.assembly.split("\n").length;

		if (this.options.performanceMetrics) {
			let timeEnded = Number(process.hrtime.bigint()) / 1000000;
			// Include performance metrics.
			performance = {
				time: timeEnded - timeStarted,
				timeStarted: timeStarted,
				timeEnded: timeEnded,
				instructionCount: this.instructionCount,
				instructionPercentage:
					(this.instructionCount / totalInstructions) * 100,
			};
		}

		fs.writeFileSync("meta-compiler-error-log.json", JSON.stringify(this.steps, null, 2));
		fs.writeFileSync("meta-compiler-machine-state.json", JSON.stringify({
			registers: Array.from(new Uint8Array(this.registers.buffer)),
			memory: Array.from(new Uint8Array(this.memory.buffer)),
		}, null, 2));

		return {
			output: this.output.text,
			metrics: {
				performance,
			},
			environment: this.environment,
		};
	}

	private error(message: string) {
		fs.writeFileSync("meta-compiler-error-log.json", JSON.stringify(this.steps, null, 2));
		error(
			message,
			this.input.originalText,
			this.source,
			this.input.getLine(),
			this.input.getColumn()
		);
	}

	/**
	 * Repeat String Operation Prefix 
	 *
	 * Repeats a string instruction the number of times specified in the count
	 * register or until the indicated condition of the ZF flag is no longer met.
	 */
	public rep(operation: Identifier) {
		// Amount of times to repeat the operation will be in ecx register
		let count = this.getRegister("ecx");

		if (typeof count !== "number") {
			throw new Error("Expected to see a number in ecx");
		}

		while (count > 0) {
			this[operation.value](true)
			// Result should be in ZF
			if (this.getZeroFlag() === false) {
				break;
			}
			count--;
		}

		this.pc++
	}

	public loop(label: Identifier) {
		// Amount of times to repeat the operation will be in ecx register
		let count = this.getRegister("ecx");

		if (count > 0) {
			this.jmp(label)
			this.setRegister("ecx", count - 1)
			return
		}
		

		this.pc++
	}

	/**
	 * Compares the first source operand with the second source operand and sets
	 * the status flags in the EFLAGS register according to the results. The
	 * comparison is performed by subtracting the second operand from the first
	 * operand and then setting the status flags in the same manner as the SUB
	 * instruction. When an immediate value is used as an operand, it is
	 * sign-extended to the length of the first operand.
	 */
	public cmp(source1: Register, source2: NumberToken | Pointer | Register) {
		if (source2 instanceof NumberToken) {
			if (source1 instanceof Pointer) {
				const register = this.getRegister(source1.name);
				const value = this.memory.getUint16(register);
				
				this.setZeroFlag(value === source2.value)
			} else {
				this.setZeroFlag(source1.value === source2.value)
			}
		} else if (source2 instanceof Register) {
			if (source1 instanceof Pointer) {
				if (source2 instanceof Pointer) {
					throw new Error("Cannot compare two pointers");
				} else {
					const value = this.memory.getUint16(source1.address);
					
					this.setZeroFlag(value === source2.value)
				}
			} else {
				if (source2.value instanceof Pointer) {
					this.setZeroFlag(source1.value === source2.value.value[0])
				} else {
					this.setZeroFlag(source1.value === source2.value)
				}
			}
		} else if (source2 instanceof Pointer) {
			if (source1.value instanceof Pointer) {
				throw new Error("Cannot compare two pointers");
			} else {
				this.setZeroFlag(source1.value === source2.value[0])
			}
		}
		

		this.pc++
	}

	/**
	 * Compare String Operands
	 *
	 * Compares the byte, word, doubleword, or quadword specified with the first
	 * source operand with the byte, word, doubleword, or quadword specified with
	 * the second source operand and sets the status flags in the EFLAGS register
	 * according to the results.
	 *
	 * Both source operands are located in memory. The address of the first source
	 * operand is read from ESI. The address of the second source operand is read
	 * from EDI.
	 */
	public cmps(omitProgramCodeIncrement: boolean = false) {
		// Get the first byte from the first source operand
		let source1 = this.getRegister("esi");
		// Get the first byte from the second source operand
		let source2 = this.getRegister("edi");
		// Compare the two bytes

		// We expect two strings to be compared, let's read them from memory

		const value1 = readStringFromMemory(this.memory, source1);
		const value2 = readStringFromMemory(this.memory, source2);

		this.setZeroFlag(true)

		if (value1.length !== value2.length) {
			// If the lengths of the strings are not equal, set the ZF flag to false
			this.setZeroFlag(false)
		}

		for (let i = 0; i < value1.length; i++) {
			const char = value1[i];

			if (value2[i] === undefined) {
				// If the second source operand is shorter than the first, set the ZF flag to false
				this.setZeroFlag(false)
				break;
			}

			if (char !== value2[i]) {
				// If they are not equal, set the ZF flag to false
				this.setZeroFlag(false)
				break;
			}
		}

		console.log(this.getZeroFlag());
		
		

		if (!omitProgramCodeIncrement) this.pc++;
	}

	public lea(register: Register, memoryAddressPointer: Pointer) {
		this.setRegister(register.name, memoryAddressPointer.address);
		this.pc++;
	}

	// TEST
	//
	// After deleting initial blanks in
	// the input string, compare it to
	// the string given as argument. If the
	// comparison is met, delete the
	// matched portion from the input and
	// set switch. If not met, reset
	// switch.
	public TST({value}: StringToken) {
		this.input.blanks();
		this.setZeroFlag(false)
		if (this.input.text.substring(0, value.length) === value) {
			this.input.lastMatch = value;
			this.input.text = this.input.text.substring(value.length);
			// Advance the cursor by the length of the string.
			this.input.cursor += value.length || 0;
			this.setZeroFlag(true)
		}
		this.pc++;
	}

	private ADD_REGISTER_IMMEDIATE(destination: Register, source: NumberToken) {
		this.setRegister(destination.name, destination.value + source.value);
	}

	private ADD_REGISTER_REGISTER(destination: Register, source: Register) {
		const r1 = this.getRegister(destination.name);
		const r2 = this.getRegister(source.name);

		this.setRegister(destination.name, r1 + r2);
	}

	private ADD_REGISTER_MEMORY(destination: Register, source: Pointer) {
		const r1 = this.getRegister(destination.name);
		const r2 = this.memory.getUint16(source.address);

		this.setRegister(destination.name, r1 + r2);
	}

	private ADD_MEMORY_IMMEDIATE(destination: Pointer, source: NumberToken) {
		const r1 = this.memory.getUint16(destination.address);

		this.memory.setUint16(destination.address, r1 + source.value);
	}

	private ADD_MEMORY_REGISTER(destination: Pointer, source: Register) {
		const r1 = this.memory.getUint16(destination.address);
		const r2 = this.getRegister(source.name);

		this.memory.setUint16(destination.address, r1 + r2);
	}

	private ADD_MEMORY_MEMORY(destination: Pointer, source: Pointer) {
		const r1 = this.memory.getUint16(destination.address);
		const r2 = this.memory.getUint16(source.address);

		this.memory.setUint16(destination.address, r1 + r2);
	}

	/**
	 * Adds the destination operand (first operand) and the source operand (second
	 * operand) and then stores the result in the destination operand. The
	 * destination operand can be a register or a memory location; the source
	 * operand can be an immediate, a register, or a memory location. 
	 * @param destination 
	 * @param source 
	 */
	public add(destination: Register | Pointer, source: Register | NumberToken | Pointer, addressingMode: AddressingModes) {
		if (addressingMode === AddressingModes.DIRECT) {
			// Move value from source into memory location of destination pointer.
			let address = 0;
			if (destination.name in this.registerMap) {
				address = this.getRegister(destination.name);
			} else {
				address = destination.address;
			}

			const value = this.memory.getUint16(address);
			this.memory.setUint16(address, value + source.value);
			this.pc++
			return
		}
		
		
		if (source instanceof NumberToken) {
			if (destination instanceof Register) {
				this.ADD_REGISTER_IMMEDIATE(destination, source)
			} else if (destination instanceof Pointer) {
				this.ADD_MEMORY_IMMEDIATE(destination, source)
			}
		} else if (source instanceof Register) {
			if (destination instanceof Pointer) {
				this.ADD_MEMORY_REGISTER(destination, source)
			} else {
				this.ADD_REGISTER_REGISTER(destination, source)
			}
		} else if (source instanceof Pointer) {
			if (destination instanceof Register) {
				this.ADD_REGISTER_MEMORY(destination, source)
			} else {
				this.ADD_MEMORY_MEMORY(destination, source)
			}
		}

		this.pc++
	}

	private MOV_MEMORY_IMMEDIATE(target: Pointer, source: NumberToken | StringToken) {
		const memoryAddress = target.address;

		// Store the value in memory
		if (source instanceof StringToken) {
			const chars = source.value.split("")
			for (let i = 0; i < chars.length; i++) {
				const char = chars[i];
				const charCode = char.charCodeAt(0);
				this.memory.setUint16(memoryAddress + (i * 2),charCode);
			}
			this.memory.setUint16(memoryAddress + chars.length * 2, 0);
		} else {
			this.memory.setUint16(memoryAddress, source.value);
		}
	}

	private MOV_MEMORY_REGISTER(target: Pointer, source: Register) {
		const memoryAddress = target.address;

		// Store the value in memory
		this.memory.setUint16(memoryAddress, source.value);
	}

	private MOV_REGISTER_MEMORY(target: Register, source: Pointer) {
		target.value = source.address;
		target.isPointer = true;
	}

	private MOV_REGISTER_REGISTER(target: Register, source: Register) {
		const r2 = this.getRegister(source.name);

		this.setRegister(target.name, r2);
	}

	private MOV_REGISTER_IMMEDIATE(target: Register, source: NumberToken) {
		this.setRegister(target.name, source.value);
	}

	public mov(destination: Register | Pointer, source: NumberToken | Register | Pointer | Identifier, addressingMode: AddressingModes) {
		if (addressingMode === AddressingModes.DIRECT) {
			// Move value from source into memory location of destination pointer.
			let address = 0;
			if (destination.name in this.registerMap) {
				address = this.getRegister(destination.name);
			} else {
				address = destination.address;
			}

			this.memory.setUint16(address, source.value);
			this.pc++
			return
		}
		
		if (source instanceof Identifier && source.name == "dword") {
			// Support dword string loading
			// Load value of argument 3 into memory given at location from argument 2
			// Get the memory address from argument 2
			// Get the value from argument 3
			if (destination instanceof Pointer) {
				this.MOV_MEMORY_IMMEDIATE(destination, arguments[2])
			}

			this.pc++
			return;
		}
		
		if (destination instanceof Pointer) {
			// Resolve the variable from memory
			if (source instanceof NumberToken) {
				this.MOV_MEMORY_IMMEDIATE(destination, source)
			} else if (source instanceof Register) {
				this.MOV_MEMORY_REGISTER(destination, source)
			} else if (source instanceof Pointer) {
				//this.MOV_MEMORY_MEMORY(target, source)
			} else {
				throw new Error("Invalid source type");
			}
		} else if (destination instanceof Register) {
			if (source instanceof NumberToken) {
				this.MOV_REGISTER_IMMEDIATE(destination, source)
			} else if (source instanceof Register) {
				this.MOV_REGISTER_REGISTER(destination, source)
			} else if (source instanceof Pointer) {
				this.MOV_REGISTER_MEMORY(destination, source)
			} else {
				throw new Error("Invalid source type");
			}
		}

		this.pc++
	}

	// Interrupt
	public int(arg1: NumberToken) {
		if (this.getRegister("edi") === STDOUT) {
			// Target stdout
			if (this.getRegister("eax") === FILE_WRITE) {
				// Print to stdout
				// Get the pointer to memory from `esi`
				const esi = this.getRegister("esi");

				const chars: string[] = [];
				let char: number;
				// Read until we hit a null terminator
				let i = 0;
				while (char = this.memory.getUint16(esi + (i * 2))) {
					chars.push(String.fromCharCode(char));
					i++
				}

				const string = chars.join("")
				
				this.output.copy(string)
			}
		} else if (this.getRegister("edi") === STDIN) {
			// Target stdin
			if (this.getRegister("eax") === FILE_READ) {
				// Read from stdin
				// Get the pointer to memory from `esi`
				const esi = this.getRegister("esi");

				const string = this.input.text.substring(0, this.getRegister("edi") || this.input.text.length - 1);
				const chars = string.split("")

				for (let i = 0; i < chars.length; i++) {
					const char = chars[i];
					const charCode = char.charCodeAt(0);

					this.memory.setUint16(esi + (i * 2), charCode);
				}
			}
		}
		this.pc++
	}

	// IDENTIFIER
	//
	// After deleting initial blanks in
	// the input string, test if it begins
	// with an identifier, ie., a letter
	// followed by a sequence of letters
	// and/or digits. If so, delete the
	// identifier and set switch. If not,
	// reset switch.
	public ID() {
		this.input.blanks();
		let captured = "";
		if (
			(this.input.text[0] >= "a" && this.input.text[0] <= "z") ||
			(this.input.text[0] >= "A" && this.input.text[0] <= "Z") ||
			this.input.text[0] === "_"
		) {
			do {
				captured += this.input.text[0];
				this.input.text = this.input.text.substring(1);
				// Advance the cursor by the length of the identifier.
				this.input.cursor += 1;
			} while (
				(this.input.text[0] >= "a" && this.input.text[0] <= "z") ||
				(this.input.text[0] >= "A" && this.input.text[0] <= "Z") ||
				(this.input.text[0] >= "0" && this.input.text[0] <= "9") ||
				this.input.text[0] === "_"
			);

			this.input.lastMatch = captured;
			this.setZeroFlag(true)
		} else {
			this.setZeroFlag(false)
		}

		this.pc++;
	}

	// NUMBER
	//
	// After deleting initial blanks in
	// the input string, test if it begins
	// with a number. A number is a
	// string of digits wich may contain
	// imbeded periods, but may not begin
	// or end with a period. Moreover, no
	// two periods may be next to one
	// another. If a number is found,
	// delete it and set switch. If not,
	// reset switch.
	public NUM() {
		this.input.blanks();
		let captured = "";
		this.setZeroFlag(false)
		if (
			this.input.text[0] === "-" ||
			(this.input.text[0] >= "0" && this.input.text[0] <= "9")
		) {
			let periodEncountered = false;

			do {
				captured += this.input.text[0];

				if (this.input.text[0] === ".") {
					if (periodEncountered) {
						// Two periods next to one another
						break;
					}
					periodEncountered = true;
				} else {
					periodEncountered = false;
				}

				this.input.text = this.input.text.substring(1);
				// Advance the cursor by the length of the number.
				this.input.cursor += 1;
			} while (
				(this.input.text[0] >= "0" && this.input.text[0] <= "9") ||
				this.input.text[0] === "."
			);

			// Check if the number doesn't begin or end with a period
			if (captured[0] !== "." && captured[captured.length - 1] !== ".") {
				this.input.lastMatch = captured;
				// Advance the cursor by the length of the number.
				this.setZeroFlag(true)
			}
		}
		

		this.pc++;
	}

	// NOT
	//
	// Match the entirety of the following characters up until
	// we hit a character that is excluded.
	public NOT({value}: StringToken) {
		let captured = "";
		do {
			captured += this.input.text[0];
			this.input.text = this.input.text.substring(1);
			// Advance the cursor by the length of the string.
			this.input.cursor += 1;
		} while (this.input.text.substring(0, value.length) !== value);
		this.input.lastMatch = captured;

		// Prevent branch error call
		this.setZeroFlag(true)

		this.pc++;
	}

	// STRING
	//
	// After deleting initial blanks in
	// the input string, test if it begins
	// with a string, ie., a double quote,
	// followed by a sequence of any
	// characters other than double quote
	// followed by another double quote.
	// If a string is found, delete it an
	// set switch. If not, reset switch.
	public SR() {
		this.input.blanks();
		let captured = "";
		this.setZeroFlag(false)
		if (this.input.text[0] === '"') {
			do {
				captured += this.input.text[0];
				this.input.text = this.input.text.substring(1);
				// Advance the cursor by the length of the string.
				this.input.cursor += 1;
			} while (this.input.text[0] !== '"');
			this.input.lastMatch = captured + '"';
			this.input.text = this.input.text.substring(1);
			// Advance the cursor by the length of the string.
			this.input.cursor += 1;
			this.setZeroFlag(true)
		}
		this.pc++;
	}

	// CALL
	//
	// Enter the subroutine beginning in
	// location aaa. Push the stack down
	// by three cells. The third cell
	// contains the return address.
	// Clear the top two cells to
	// blanks to indicate that they can
	// accept addresses which may be
	// generated within the subroutine.
	public call(target: Identifier) {
		this.stack.push(this.pc + 1);
		this.stack.push(null);
		this.stack.push(null);
		this.pc = this.program[target.value];
	}

	public jmp(target: Identifier) {
		this.pc = this.program[target.value];
	}

	// RETURN
	//
	// Return to the exit address, popping
	// up the stack by three cells.
	public ret() {
		if (this.stack.length === 0) {
			this.END();
		}
		this.stack.pop();
		this.stack.pop();
		this.pc = this.stack.pop();
	}

	// SET
	//
	// Set branch switch on.
	public SET() {
		this.setZeroFlag(true)
		this.pc++;
	}

	// BRANCH
	//
	// Branch unconditionally to location
	// aaa.
	public B(register: Identifier) {
		this.pc = this.program[register.value];
	}

	// JUMP EQUAL
	//
	// Jump to location aaa if branch flag is true
	// Otherwise, continue in sequence.
	public je(register: Identifier) {
		if (this.getZeroFlag()) {
			this.pc = this.program[register.value];
		} else {
			this.pc++;
		}
	}

	// JUMP NOT EQUAL
	//
	// Jump to location aaa if branch flag is off
	// Otherwise, continue in sequence.
	public jne(register: Identifier) {
		if (!this.getZeroFlag()) {
			this.pc = this.program[register.value];
		} else {
			this.pc++;
		}
	}

	// BRANCH TO ERROR IF FALSE
	//
	// Halt if switch is off. Otherwise,
	// continue in sequence.
	public BE() {
		if (!this.getZeroFlag()) {
			this.error("BRANCH ERROR Executed - Something is Wrong!");
		}
		this.pc++;
	}

	// COPY LITERAL
	//
	// Output the variable length string
	// given as the argument. A blank
	// character will be inserted in the
	// output following the string.
	public CL({value: string}: StringToken) {
		this.output.copy(string);
		this.pc++;
	}

	// COPY INPUT
	//
	// Output the last sequence of char-
	// acters deleted from the input
	// string. This command may not func-
	// tion properly if the last command
	// which could cause deletion failed
	// to do so.
	public CI() {
		this.output.copy(this.input.lastMatch);
		this.pc++;
	}

	// GENERATE 1
	//
	// This concerns the current label 1
	// cell, ie. the next to top cell in
	// the stack, which is either clear or
	// contains a generated label. If
	// clear, generate a label and put it
	// into that cell. Wether the label
	// has just been put into the cell or
	// was already there, output it.
	// Finally, insert a blank character
	// in the output following the label.
	public GN1() {
		var gn2 = this.stack.pop();
		var gn1 = this.stack.pop();
		if (gn1 === null) {
			gn1 = this.nextGN1++;
		}
		this.stack.push(gn1);
		this.stack.push(gn2);
		this.output.copy("A" + gn1);
		this.pc++;
	}

	// GENERATE 2
	//
	// Same as GN1, except that it con-
	// cerns the current label 2 cell,
	// ie., the top cell in the stack.
	public GN2() {
		var gn2 = this.stack.pop();
		if (gn2 === null) {
			gn2 = this.nextGN2++;
		}
		this.stack.push(gn2);
		this.output.copy("B" + gn2);
		this.pc++;
	}

	// LABEL
	//
	// Set the output counter to card
	// column 1.
	public LB() {
		this.output.label();
		this.pc++;
	}

	// OUTPUT
	//
	// Punch card and reset output counter
	// to card column 8.
	public OUT() {
		if (this.options.emitWhitespace) {
			this.output.newLine();
		}

		this.pc++;
	}

	// ADDRESS
	//
	// Produces the address which is
	// assigned to the given identifier
	// as a constant.
	public ADR(register: Identifier) {
		this.pc = this.program[register.value];
	}

	// END
	//
	// Denotes the end of the program.
	public END() {
		this.done = true;
	}
}

export { MetaCompiler };
