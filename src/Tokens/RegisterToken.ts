import { MetaCompiler } from "../MetaCompiler";
import { RegisterName } from "../types";

export class Register  {
	public raw: string;
	public name: RegisterName;

	constructor(raw: RegisterName, private compiler: MetaCompiler, public isPointer: boolean = false) {
		this.raw = raw;
		this.name = raw;
	}

	public get value() {
		return this.compiler.getRegister(this.name);
	}

	public set value(value: number) {
		this.compiler.setRegister(this.name, value)
	}
}