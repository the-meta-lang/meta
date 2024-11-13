type MetalsAstNode = { type: string; [key: string]: any };

abstract class MetalsCodeGen {
	public generate(indent?: number): string {
		throw new Error("Method not implemented.");
	}
}

export class MetalsProgram extends MetalsCodeGen {
	constructor(public body: MetalsCodeGen[]) {
		super();
	}

	public generate(): string {
		let buffer: string = "";

		for (const node of this.body) {
			buffer += node.generate();
		}

		return buffer;
	}
}

export class MetalsConditional extends MetalsCodeGen {
	constructor() {
		super();
	}
}

export class MetalsIfStatement extends MetalsCodeGen {
	constructor() {
		super();
	}

	public generate(): string {
		return "if {}";
	}
}

export class MetalsVariableDeclaration extends MetalsCodeGen {
	constructor(
		public name: string,
		public type: string,
		public value: string
	) {
		super();
	}

	public generate(): string {
		return `var ${this.name} ${this.type} = ${this.value}`;
	}
}

export class MetalsBlock extends MetalsCodeGen {
	constructor(public body: MetalsCodeGen[]) {
		super();
	}

	public generate(indent: number = 0): string {
		let buffer = "";

		for (const node of this.body) {
			buffer += node.generate(indent);
		}

		return buffer;
	}
}

export class MetalsStringLiteral extends MetalsCodeGen {
	constructor(public value: string) {
		super();
	}

	public generate(): string {
		return `"${this.value}"`;
	}
}

export class MetalsIdentifier extends MetalsCodeGen {
	constructor(public name: string) {
		if (!/^[A-Za-z_$][A-Za-z0-9_$]*$/.test(name)) {
			throw new Error(`Invalid identifier name '${name}'`);
		}

		super();
	}

	public generate(): string {
		return this.name;
	}
}

export class MetalsBinaryOperation extends MetalsCodeGen {
	constructor(
		public left: MetalsCodeGen,
		public operator: string,
		public right: MetalsCodeGen
	) {
		super();
	}

	public generate(): string {
		return `${this.left.generate()} ${
			this.operator
		} ${this.right.generate()}`;
	}
}

export class MetalsOr extends MetalsCodeGen {
	constructor(public left: MetalsCodeGen, public right: MetalsCodeGen) {
		super();
	}

	public generate(): string {
		return `${this.left.generate()} || ${this.right.generate()}`;
	}
}

export class MetalsCall extends MetalsCodeGen {
	constructor(public callee: MetalsCodeGen, public args: MetalsCodeGen[]) {
		super();
	}

	public generate(): string {
		return `${this.callee.generate()}(${this.args
			.map((arg) => arg.generate())
			.join(", ")})`;
	}
}

export class MetalsArgument extends MetalsCodeGen {
	constructor(public name: string, public type: MetalsType) {
		super();
	}

	public generate(): string {
		return `${this.name} ${this.type.generate()}`;
	}
}

export class MetalsType extends MetalsCodeGen {
	constructor(public type: string) {
		super();
	}

	public generate(indent: number = 0): string {
		return this.type;
	}
}

export class MetalsFunctionDeclaration extends MetalsCodeGen {
	constructor(
		public name: string,
		public args: MetalsArgument[],
		public returnType: MetalsType,
		public body: MetalsBlock
	) {
		super();
	}

	public generate(indent: number = 0): string {
		return indentText(`func ${this.name}(${this.args
			.map((arg) => arg.generate())
			.join(
				", "
			)}) ${this.returnType.generate()} {\n\t${this.body.generate(indent + 1)}\n}\n`, indent);
	}
}

function indentText(text: string, indent: number): string {
	return text.split("\n").map(line => {
		return "\t".repeat(indent) + line;
	}).join("\n")
}