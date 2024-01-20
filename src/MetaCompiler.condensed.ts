import type { Instruction } from "./types.js";

const parse = function (text: string): Instruction[] {
	const program = [];

	const lines = text.split("\n");

	for (const line of lines) {
		if (line.trim().length == 0) {
			continue;
		}

		if (line[0] == " ") {
			program.push(parseInstruction(line));
		} else {
			program[parseLabel(line)] = program.length;
		}
	}

	return program;
};

function parseInstruction(line: string) {
	const instruction = line.trim();

	var idx = instruction.indexOf(" ");

	if (idx === -1) {
		return [instruction];
	} else {
		let instr = instruction.substring(idx).trim();
		const args = [];
		let inString = false;
		let lastWasEscapeChar = false;
		let str = "";
		for (let i = 0; i < instr.length; i++) {
			const char = instr[i];
			if (char == "\\" && !lastWasEscapeChar) {
				lastWasEscapeChar = true;
				continue;
			}

			if (char == '"' && inString && !lastWasEscapeChar) {
				inString = false;
				continue;
			} else if (char == '"' && !inString) {
				inString = true;
				continue;
			}

			if (char == "," && !inString) {
				args.push(str.trim());
				str = "";
				continue;
			}

			lastWasEscapeChar = false;
			str += char;
		}

		args.push(str.trim());
		return [instruction.slice(0, idx), ...args];
	}
}

function parseLabel(line: string): string {
	return line.trim();
}

class Builder {
	public text: string = "       ";

	copy(string: string) {
		this.text += string;
	}

	label() {
		this.text = this.text.slice(0, -7);
	}

	newLine() {
		this.text += "\n       ";
	}

	getProgram() {
		return parse(this.text);
	}
}

class Scanner {
	public lastMatch: string = null;
	public matches: string[] = null;
	public cursor: number = 0;
	public originalText: string;

	constructor(public text: string) {
		this.originalText = this.text;
	}

	public getLine(): number {
		let str = this.originalText.substring(0, this.cursor);

		let lines = str.split("\n");

		return lines.length;
	}

	public getLines(): string[] {
		return this.originalText.split("\n");
	}

	public getColumn(): number {
		let str = this.originalText.substring(0, this.cursor);

		let lines = str.split("\n");

		return lines[lines.length - 1].length + 1;
	}

	public blanks() {
		let textLength = this.text.length;
		this.text = this.text.replace(/^\s+/, "");

		this.cursor += textLength - this.text.length;
	}

	public match(pattern: RegExp | string) {
		if (pattern instanceof RegExp) {
			return this.matchRegularExpression(pattern);
		}
		return this.matchString(pattern);
	}

	public matchRegularExpression(re: RegExp) {
		var result = re.exec(this.text);
		if (result !== null) {
			this.lastMatch = result[0];
			this.matches = result;
			this.text = this.text.substring(result[0].length);

			this.cursor += result[0].length || 0;
			return true;
		}
		return false;
	}

	public matchString(str: string) {
		if (this.text.substring(0, str.length) === str) {
			this.lastMatch = str;
			this.matches = [str];
			this.text = this.text.substring(str.length);

			this.cursor += str.length || 0;
			return true;
		}
		return false;
	}
}

class MetaCompiler {
	private input: Scanner;
	private output: Builder;
	private pc: number;
	private stack: any[];
	private nextGN1: number;
	private nextGN2: number;
	private done: boolean;
	private branch: boolean;
	private program: { [key: string | number]: any };
	private source: string;

	constructor(private assembly: string) {
		this.program = parse(this.assembly);
	}

	public step(): boolean {
		if (this.done) {
			return;
		}

		var instr = this.program[this.pc];

		if (!instr || instr.length == 0) {
			this.error(`malformed instruction: ${instr}`);
		}

		if (!this[instr[0]]) {
			this.error(`call to undefined instruction: ${instr[0]}`);
		}

		this[instr[0]](instr[1]);

		return true;
	}

	public compile(compiler: string, grammar: string = ""): string {
		this.output = new Builder();
		this.pc = 0;
		this.stack = [];
		this.nextGN1 = 0;
		this.nextGN2 = 0;
		this.done = false;
		this.branch = false;
		this.input = new Scanner(compiler);
		this.source = grammar;
		while (this.step()) {}
		return this.output.text;
	}

	private error(message: string) {
		console.log(message);
	}

	public TST(string: string) {
		this.input.blanks();
		this.branch = this.input.match(string);
		this.pc++;
	}

	public ID() {
		this.input.blanks();
		this.branch = this.input.match(/^[_a-zA-Z][$_a-zA-Z0-9]*/);
		this.pc++;
	}

	public NUM() {
		this.input.blanks();
		this.branch = this.input.match(/^-?[0-9]+([,.][0-9]+)*/);
		this.pc++;
	}

	public NOT(exclude: string) {
		exclude = exclude.replace(/[.*+?^${}()|[\]\\\/]/g, "\\$&");
		this.branch = this.input.match(new RegExp(`[^${exclude}]*`));
		this.pc++;
	}

	public SR() {
		this.input.blanks();
		this.branch = this.input.match(/^["][^"]*["]/);
		this.pc++;
	}

	public JMP(aaa: string) {
		this.stack.push(this.pc + 1);
		this.stack.push(null);
		this.stack.push(null);
		this.pc = this.program[aaa];
	}

	public R() {
		if (this.stack.length === 0) {
			this.END();
		}
		this.stack.pop();
		this.stack.pop();
		this.pc = this.stack.pop();
	}

	public SET() {
		this.branch = true;
		this.pc++;
	}

	public B(aaa: string) {
		this.pc = this.program[aaa];
	}

	public BT(aaa: string) {
		if (this.branch) {
			this.pc = this.program[aaa];
		} else {
			this.pc++;
		}
	}

	public BF(aaa: string) {
		if (!this.branch) {
			this.pc = this.program[aaa];
		} else {
			this.pc++;
		}
	}

	public BE() {
		if (!this.branch) {
			this.error("BRANCH ERROR Executed - Something is Wrong!");
		}
		this.pc++;
	}

	public CL(string: string) {
		this.output.copy(string + " ");
		this.pc++;
	}

	public CI() {
		this.output.copy(this.input.lastMatch);
		this.pc++;
	}

	public GN1() {
		var gn2 = this.stack.pop();
		var gn1 = this.stack.pop();
		if (gn1 === null) {
			gn1 = this.nextGN1++;
		}
		this.stack.push(gn1);
		this.stack.push(gn2);
		this.output.copy("A" + gn1 + " ");
		this.pc++;
	}

	public GN2() {
		var gn2 = this.stack.pop();
		if (gn2 === null) {
			gn2 = this.nextGN2++;
		}
		this.stack.push(gn2);
		this.output.copy("B" + gn2 + " ");
		this.pc++;
	}

	public LB() {
		this.output.label();
		this.pc++;
	}

	public OUT() {
		this.output.newLine();
		this.pc++;
	}

	public ADR(ident: string) {
		this.pc = this.program[ident];
	}

	public END() {
		this.done = true;
	}
}

export { MetaCompiler };
