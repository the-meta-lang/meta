export class Pointer  {
	public raw: string;
	public name: string;
	// Memory address pointing to the first byte of the value in memory
	private address: number;
	// Memory address pointing to the last referenced byte in memory, can be
	// incremented using the `add` command or similar.
	public adjustedAddress: number;
	private memory: Uint16Array;

	constructor(raw: string, name: string, address: number, memory: Uint16Array) {
		this.raw = raw;
		this.name = name;
		this.memory = memory;
		this.address = address;
		this.adjustedAddress = address;
	}

	public set value(values: number[]) {
		if (this.adjustedAddress + values.length < this.memory.length) {
			for (let i = 0; i < values.length; i++) {
				const value = values[i];
				this.memory[this.adjustedAddress + i] = value;
			}
		} else {
			throw new Error(`Adding ${values.length} bytes would result in pointer ${this.name} being out of bounds.`);
		}
	}

	/**
	 * Gets called when the pointer is referenced again, this will revert any
	 * address changes that might have occured earlier on.
	 */
	public reference() {
		this.adjustedAddress = this.address;
	}

	public get value(): number[] {
		// Read until we hit a 0
		const values = [];
		let index = this.adjustedAddress;
		while (this.memory[index] !== 0) {
			values.push(this.memory[index]);
			index++;
		}
		return values;
	}
}