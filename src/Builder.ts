// BUILDER
//
// A text-based program builder with modes for
// the Meta II virtual machine.

import { parse } from "./parse.js";

//
class Builder {
	public text: string = "       ";

	copy(string: string) {
		this.text += string;
	}

	label() {
		// Remove leading whitespace from current line
		this.text = this.text.slice(0, -7);
	}

	newLine() {
		this.text += "\n       ";
	}

	getProgram() {
		return parse(this.text);
	}
}

export { Builder };
