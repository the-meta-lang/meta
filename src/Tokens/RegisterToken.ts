import { Pointer } from "./Pointer";

export class Register  {
	public raw: string;
	public name: string;

	constructor(raw: string, private registers: Record<string, number | Pointer>) {
		this.raw = raw;
		this.name = raw;
	}

	public get value() {
		return this.registers[this.name];
	}

	public set value(value: number | Pointer) {
		this.registers[this.name] = value;
	}
}