export type Match = {
	ok: boolean;
	tree: Tree;
};

export interface TokenMatch {
	ok: boolean;
	value: string;
	start: number;
	end: number;
}

export interface Context {
	matches: TokenMatch[];
	namedMatches: Record<string, TokenMatch[]>;
	stdin: string;
	stdout: string;
	cursor: number;
	tree: Tree;
}

export interface Tree {
	[key: string]: any | Tree;
}

export type RuleFunction<T extends any[] = any[]> = (this: Context, ...args: T) => Match;

export type TokenFunction<T extends any[] = any[]> = (this: Context, ...args: T) => TokenMatch;

let inbuf: string;
let cursor: number;
let ignore: (char: string) => boolean = () => false;

export const test: TokenFunction<[string]> = function (this: Context, str: string) {
	// test for a string in the input
	let i = 0,
		ok = true;
	// remove every character that matches the ignore rule.
	while (ignore(this.stdin.charAt(this.cursor)) === true) this.cursor++;
	// test string case sensitive
	while (ok && i < str.length && this.cursor + i < this.stdin.length) {
		ok = str.charAt(i) == this.stdin.charAt(this.cursor + i);
		i++;
	}
	// make sure we reached the end of our string.
	ok = ok && i == str.length;
	// advance input if found
	if (ok) this.cursor = this.cursor + str.length;

	return {
		ok,
		start: this.cursor - str.length,
		end: this.cursor,
		value: str,
	};
};