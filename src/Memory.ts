export function createMemory(size: number) {
	const buffer = new ArrayBuffer(size);

	return new DataView(buffer);
}

export function extendMemory(memory: DataView, sizeInBytes: number) {
	const buffer = new ArrayBuffer(memory.byteLength + sizeInBytes);
	new Uint8Array(buffer).set(new Uint8Array(memory.buffer));
	return new DataView(buffer);
}

/**
 * Reads a string from memory until it reaches a null byte.
 * @param memory 
 * @param offset 
 */
export function readStringFromMemory(memory: DataView, offset: number) {
	let result = "";
	let currentByte: number;
	let i = 0;
	while (currentByte = memory.getUint16(offset + (i * 2))) {
		result += String.fromCharCode(currentByte);
		i++
	}

	return result;
}

export function readFromMemory(memory: DataView, offset: number) {
	let result = [];
	let currentByte: number;
	let i = 0;
	while (currentByte = memory.getUint16(offset + (i * 2))) {
		result.push(currentByte)
		i++
	}

	return result;
}