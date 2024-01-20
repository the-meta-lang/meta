export class Identifier  {
	public raw: string;
	public name: string;
	public value: string;

	constructor(raw: string) {
		this.raw = raw;
		this.name = raw;
		this.value = raw;
	}
}