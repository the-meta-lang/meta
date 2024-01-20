import { Scanner } from "./Scanner.js";
import { Builder } from "./Builder.js";
import { parse } from "./parse.js";
import { error } from "./error-handler.js";
import * as fs from "fs"
import {
	CompilerOptions,
	CompilerOutput,
	Issue,
	Registers,
	Step,
} from "./types.js";
import { Register } from "./Tokens/RegisterToken.js";
import { Pointer } from "./Tokens/Pointer.js";
import { StringToken } from "./Tokens/StringToken.js";
import { NumberToken } from "./Tokens/NumberToken.js";
import { Identifier } from "./Tokens/IdentifierToken.js";

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
	private pc: number;
	private stack: any[];
	private nextGN1: number;
	private nextGN2: number;
	private done: boolean;
	private branch: boolean;
	private program: {
		instruction: string,
		args: (Register | NumberToken | StringToken | Pointer)[]
	}[];
	private source: string;
	private instructionCount: number = 0;
	private environment: { [key: string]: any } = {};
	public options: CompilerOptions;
	public instructions = {
		"mov": 0x01
	}
	private registers: Registers = {
		eax: 0x00,
		ebx: 0x00,
		ecx: 0x00,
		edx: 0x00,
		edi: 0x00,
		esi: 0x00,
		ebp: 0x00,
		esp: 0x00,
		/**
		 * 16 bit Flags register mapping:
		 * X X X X OF DF IF TF SF ZF X AF X PF X CF
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
		flags: 0x00
	}

	public issues: Issue[];
	private pointers: Record<string, number>
	private memory: Uint16Array;

	constructor(private assembly: string) {
		const { program, pointers, memory } = parse(assembly, this.registers);
		this.program = program;
		this.pointers = pointers;
		this.memory = memory;
	}

	public step(): Step {
		if (this.done) {
			return;
		}

		if (!this.program[this.pc]) {
			this.error(`Invalid program counter: ${this.pc}`);
		}

		var { instruction, args } = this.program[this.pc];

		if (this.options.debugMode) {
			console.log(instruction);
		}

		if (!instruction) {
			this.error(`Malformed instruction: ${instruction}`);
		}

		if (!this[instruction]) {
			this.error(`Call to undefined instruction: ${instruction}`);
		}

		this[instruction](...args);
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
		return (this.registers.flags & 0b0000000001000000) == 0 ? false : true;
	}

	private setZeroFlag(value: boolean) {
		if (value === true) {
			this.registers.flags = this.registers.flags | 0b0000000001000000;
		} else {
			this.registers.flags = this.registers.flags & 0b1111111110111111;
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
			registers: this.registers,
			pc: this.pc,
			stack: this.stack,
			nextGN1: this.nextGN1,
			nextGN2: this.nextGN2,
			done: this.done,
			branch: this.branch,
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
		let count = this.registers.ecx;

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
			if (source1.value instanceof Pointer) {
				this.setZeroFlag(source1.value.value[0] === source2.value)
			} else {
				this.setZeroFlag(source1.value === source2.value)
			}
		} else if (source2 instanceof Register) {
			if (source1.value instanceof Pointer) {
				if (source2.value instanceof Pointer) {
					throw new Error("Cannot compare two pointers");
				} else {
					this.setZeroFlag(source1.value.value[0] === source2.value)
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
		let source1 = this.registers.esi;
		// Get the first byte from the second source operand
		let source2 = this.registers.edi;
		// Compare the two bytes

		if (!(source1 instanceof Pointer) || !(source2 instanceof Pointer)) {
			throw new Error("Expected to see pointers in esi and edi");
		}

		this.setZeroFlag(true)

		const source1Value = source1.value;
		const source2Value = source2.value;

		for (let i = 0; i < source1Value.length; i++) {
			const char = source1Value[i];

			if (source2Value[i] === undefined) {
				// If the second source operand is shorter than the first, set the ZF flag to false
				this.setZeroFlag(false)
				break;
			}

			if (char !== source2Value[i]) {
				// If they are not equal, set the ZF flag to false
				this.setZeroFlag(false)
				break;
			}
		}

		if (!omitProgramCodeIncrement) this.pc++;
	}

	public lea(register: Register, memoryAddressPointer: Pointer) {
		register.value = memoryAddressPointer;
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

	/**
	 * Adds the destination operand (first operand) and the source operand (second
	 * operand) and then stores the result in the destination operand. The
	 * destination operand can be a register or a memory location; the source
	 * operand can be an immediate, a register, or a memory location. 
	 * @param destination 
	 * @param source 
	 */
	public add(destination: Register, source: Register | NumberToken | Pointer) {
		if (source instanceof NumberToken) {
			if (destination instanceof Register && destination.value instanceof Pointer) {
				// Increment the pointer offset so it will point to a different memory location.
				destination.value.adjustedAddress += source.value;
			} else if (destination instanceof Register && typeof destination.value === "number") {
				destination.value += source.value;
			}
		} else if (source instanceof Register) {
			if (destination.value instanceof Pointer) {
				if (source.value instanceof Pointer) {
					throw new Error("Cannot add two pointers");
				} else {
					destination.value.value = [destination.value.value[0] + source.value, ...destination.value.value.slice(1)];
				}
			} else {
				if (source.value instanceof Pointer) {
					destination.value += source.value.value[0];
				} else {
					destination.value += source.value;
				}
			}
		} else if (source instanceof Pointer) {
			if (destination.value instanceof Pointer) {
				throw new Error("Cannot add two pointers");
			} else {
				destination.value += source.value[0];
			}
		}

		this.pc++
	}

	public mov(target: Register | Pointer, source: NumberToken | Register | Pointer | Identifier) {
		if (source instanceof Identifier && source.name == "dword") {
			// Support dword string loading
			// Load value of argument 3 into memory given at location from argument 2
			// Get the memory address from argument 2
			// Get the value from argument 3
			if (target instanceof Pointer) {
				target.value = [...arguments[2].value.split("").map((char: string) => {
					return char.charCodeAt(0)
				}), 0x00]
			} else if (target instanceof Register && target.value instanceof Pointer) {
				target.value.value = [...arguments[2].value.split("").map((char: string) => {
					return char.charCodeAt(0)
				}), 0x00]
			}

			this.pc++
			return;
		}
		
		if (target instanceof Pointer) {
			// Resolve the variable from memory
			if (source instanceof NumberToken) {
				target.value = [source.value, ...target.value.slice(1)];
			} else if (source instanceof Register) {
				if (source.value instanceof Pointer) {
					target.value = [...source.value.value, ...target.value.slice(source.value.value.length)];
				} else {
					target.value = [source.value, ...target.value.slice(1)];
				}
			} else if (source instanceof Pointer) {
				target.value = [...source.value, ...target.value.slice(source.value.length)];
			} else {
				throw new Error("Invalid source type");
			}
		} else if (target instanceof Register) {
			if (source instanceof NumberToken) {
				target.value = source.value;
			} else if (source instanceof Register) {
				target.value = source.value;
			} else if (source instanceof Pointer) {
				target.value = source;
				source.reference()
			} else {
				throw new Error("Invalid source type");
			}
		}

		this.pc++
	}

	// Interrupt
	public int(arg1: NumberToken) {
		if (this.registers.edi === STDOUT) {
			// Target stdout
			if (this.registers.eax === FILE_WRITE) {
				// Print to stdout
				// Get the pointer to memory from `esi`
				const esi = this.registers.esi as Pointer;

				if (!(esi instanceof Pointer)) {
					throw new Error("Expected to see a pointer in esi");
				}

				const chars = esi.value;
				const string = chars.map((num) => {
					return String.fromCharCode(num)
				}).join("")

				this.output.copy(string)
			}
		} else if (this.registers.edi === STDIN) {
			// Target stdin
			if (this.registers.eax === FILE_READ) {
				// Read from stdin
				// Get the pointer to memory from `esi`
				const esi = this.registers.esi as Pointer;

				if (!(esi instanceof Pointer)) {
					throw new Error("Expected to see a pointer in esi");
				}

				const string = this.input.text.substring(0, this.registers.edi || this.input.text.length - 1);
				const chars = string.split("").map((char) => {
					return char.charCodeAt(0)
				})

				esi.value = chars;
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
