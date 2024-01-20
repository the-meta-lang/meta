export class Pointer  {
	public raw: string;
	public name: string;
	// Memory address pointing to the first byte of the value in memory
	public address: number;

	constructor(raw: string, name: string, address: number, memory: DataView) {
		this.raw = raw;
		this.name = name;
		this.address = address;
	}
}