import { MemoryView } from "./MemoryView";

export class MemoryBlock {
	private _data: ArrayBuffer;

	constructor(size: number) {
		this._data = new ArrayBuffer(size);
	}

	public load(
		address: number,
		size: number = 4,
		signed: boolean = false
	): MemoryView {
		return new MemoryView(this, size, address, signed);
	}
	public isValid(address: number): boolean {
		return address >= 0 && address < this.size;
	}

	public clear() {
		for (let i = 0; i < this.size; i++) {
			this.load(i, 1).setValue(0);
		}
	}

	get data(): ArrayBuffer {
		return this._data;
	}
	get size(): number {
		return this.data.byteLength;
	}
}
