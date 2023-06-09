type Instruction = [string, string?];

interface Step { lineno: number, colno: number, pc: number, instruction: Instruction, metadata: Metadata }

interface Metadata {
	isJumpInstruction: boolean;
	jumpAddress: number;
	jumpAddressLabel: string;
	isReturnInstruction: boolean;
}

enum InstructionSet {
	JMP = "JMP",
	RET = "R",
	BF = "BF",
	BT = "BT",
	B = "B"
}

interface Issue {
	message: string,
	pc: number,
	lineno: number,
	colno: number
}

interface CompilerOptions {
	debugMode?: boolean;
	performanceMetrics?: boolean;
	emitWhitespace?: boolean;
}

/**
 * Flags for the compiler.
 * p - Performance -> Measure the time it took to compile the source.
 * d - Debug -> Output additional debug information.
 */
type CompilerFlags = ("p" | "d")[]

interface CompilerOutput {
	output: string,
	metrics: {
		performance?: {
			// The number of instructions in the source that were executed.
			instructionCount: number,
			// The percentage of instructions that were executed.
			instructionPercentage: number,
			// The time it took in milliseconds until compilation was finished.
			time: number,
			// The time in milliseconds the compilation was started at.
			timeStarted: number,
			// The time in milliseconds the compilation ended at.
			timeEnded: number,
		}
	},
	environment: {[key: string]: any}
}

export { CompilerOptions, Instruction, InstructionSet, Step, Metadata, Issue, CompilerFlags, CompilerOutput }