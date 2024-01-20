export class NumberToken {
	public raw: string;
	public value: number;

	constructor(raw: string, value: number) {
		this.raw = raw;
		this.value = value;
	}
}