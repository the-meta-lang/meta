//
// A generic text scanner for the META II virtual machine.
//

class Scanner {
	public lastMatch: string = null;
	public matches: string[] = null;
	public cursor: number = 0;
	public originalText: string;

	constructor(public text: string) {
		this.originalText = this.text;
	}

	public getLine(): number {
		// Get the string of everything before the cursor position.
		let str = this.originalText.substring(0, this.cursor);
		// Split into lines
		let lines = str.split("\n");
		// Get the length of the array + 1
		// if we have two newlines we're on the third line
		// that's why need to add 1.
		// however, since we're 0-based
		// we don't need to add 1
		return lines.length;
	}

	public getLines(): string[] {
		return this.originalText.split("\n");
	}

	public getColumn(): number {
		// Get the string of everything before the cursor position.
		let str = this.originalText.substring(0, this.cursor);
		// Split into lines
		let lines = str.split("\n");

		// Count how many characters the last
		// line contains, this will tell
		// us just how many characters are in
		// front of our current index in this line alone
		// a.k.a. our column index.
		return lines[lines.length - 1].length + 1;
	}

	// Remove initial blanks from the text.
	public blanks() {
		let textLength = this.text.length;
		this.text = this.text.trimStart();
		// Advance the cursor by the length of white-spaces we just removed.
		this.cursor += textLength - this.text.length;
	};
};

export { Scanner }