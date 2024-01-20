import { MetaCompiler } from "./MetaCompiler";
import { Identifier } from "./Tokens/IdentifierToken";
import { NumberToken } from "./Tokens/NumberToken";
import { Pointer } from "./Tokens/Pointer";
import { Register } from "./Tokens/RegisterToken";
import { StringToken } from "./Tokens/StringToken";
import { RegisterName, Registers } from "./types";

export class Parser {
	private currentChar: string;
	private input: string;
	private index: number;

  constructor(input: string, private memory: DataView, private pointers: Record<string, number>, private compiler: MetaCompiler) {
    this.input = input;
    this.index = 0;
    this.currentChar = this.input[this.index];
  }

  advance() {
    this.index++;
    if (this.index < this.input.length) {
      this.currentChar = this.input[this.index];
    } else {
      this.currentChar = null;
    }
  }

  skipWhitespace() {
    while (this.currentChar && /\s/.test(this.currentChar)) {
      this.advance();
    }
  }

  parseString() {
    let result = '';
    this.advance(); // Skip the opening double quote
		// Keep track of whether we are currently escaped.
		let escaped = false;

    while (this.currentChar && (this.currentChar !== '"' || escaped)) {
			if (escaped) {
				if (this.currentChar === "n") {
					result += "\n";
				} else if (this.currentChar === "t") {
					result += "\t";
				}
				escaped = false;
			} else if (this.currentChar === "\\") {
				escaped = true;
			}
			else {
				result += this.currentChar;
			}
      
      this.advance();
    }
		

    this.advance(); // Skip the closing double quote
    return new StringToken(`"${result}"`, result);
  }

  parseNumber() {
    let result = '';

    while (this.currentChar && /\d|\./.test(this.currentChar)) {
      result += this.currentChar;
      this.advance();
    }

    return new NumberToken(result, parseFloat(result));
  }

  parseVariableReference() {
    let result = '';
    this.advance(); // Skip the opening square bracket

    while (this.currentChar && this.currentChar !== ']') {
      result += this.currentChar;
      this.advance();
    }


    this.advance(); // Skip the closing square bracket
    return new Pointer(`[${result}]`, result, this.pointers[result], this.memory);
  }

	parseIdentifier() {
		let result = "";
		while (this.currentChar && /[a-zA-Z0-9_]/.test(this.currentChar)) {
			result += this.currentChar;
			this.advance();
		}

		if (result in this.compiler.registerMap) {
			return new Register(result as RegisterName, this.compiler);
		} else {
			return new Identifier(result);
		}
	}

	parseHex() {
		let result = "";
		while (this.currentChar && /[a-fA-F0-9]/.test(this.currentChar)) {
			result += this.currentChar;
			this.advance();
		}

		return new NumberToken(result, parseInt(result, 16));
	}

  getNextToken() {
    this.skipWhitespace();

    if (!this.currentChar) {
      return null;
    }

		if (this.currentChar == ";") {
			// Comment
			this.advance();
			while (this.currentChar && this.currentChar != "\n") {
				this.advance();
			}
			this.advance();
			return null;
		}

		if (this.currentChar == ",") {
			// Argument separator.
			this.advance();
			this.skipWhitespace()
		}

    if (this.currentChar === '"') {
      return this.parseString();
    }

		if (this.currentChar === "0") {
			this.advance();
			if ((this.currentChar as string) === "x") {
				this.advance();
				return this.parseHex();
			} else {
				throw new Error("Unknown number format");
			}
		}

    if (/\d/.test(this.currentChar)) {
      return this.parseNumber();
    }

    if (this.currentChar === '[') {
      return this.parseVariableReference();
    }

		return this.parseIdentifier()
  }
}