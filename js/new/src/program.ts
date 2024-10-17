import { test, type Context, type Match, type TokenMatch, type Tree } from "./test";

export function compile(stdin: string) {
	let ctx: Context = {
		cursor: 0,
		matches: [],
		namedMatches: {},
		stdin,
		stdout: "",
		tree: {}
	};

	let _: Match;

	_  = $program.call(ctx);

	if (!_.ok) {
		throw new Error("Failed to match program");
	}

	return _;
}

type Scope<T extends TokenMatch | Match> = Record<string, T[]>

function addToScope(scope: Scope<any>, key: string, value: TokenMatch | Match) {
	if (key in scope) {
		scope[key] = [...scope[key], value];
	} else {
		scope[key] = [value];
	}
}

function $program(this: Context) {
	let _: Match | TokenMatch;
	let tree: Tree;
	let scope: Scope<Match> = {};

	addToScope(scope, "addition", $addition.call(this));

	tree = {
		type: "Program",
		body: scope.addition.map((match) => match.tree)
	}

	return { ok: true, tree: tree };
}

function $addition(this: Context) {
	let _: Match | TokenMatch;
	let tree: Tree;

	_ = $operand.call(this);

	if (!_.ok) {
		return { ok: false, tree: {} };
	}

	let left = _;

	_ = test.call(this, "+");	

	if (!_.ok) {
		throw new Error("Expected '+' but found " + this.stdin.charAt(this.cursor));
	}

	_ = $operand.call(this);

	if (!_.ok) {
		throw new Error("Expected '+' but found " + this.stdin.charAt(this.cursor));
	}

	let right = _;

	tree = {
		type: "BinaryExpression",
		expression: {
			left: left.tree,
			right: right.tree,
			operator: "+"
		}
	}

	return { ok: _.ok, tree }
}

function $operand(this: Context): Match {
	let _: TokenMatch;
	let tree: Tree;

	_ = $$number.call(this);

	if (!_.ok) {
		return { ok: false, tree: {}};
	}

	let value = _;

	tree = {
		type: "Literal",
		value: value
	}

	return { ok: _.ok, tree }
}

function addTokenMatch(matches: Record<string, TokenMatch[]>, key: string, value: TokenMatch) {
	if (key in matches) {
		matches[key] = [...matches[key], value]
	} else {
		matches[key] = [value];
	}

	return matches;
}

function $$whitespace(this: Context): TokenMatch {
	let _: TokenMatch = {value: "", ok: false, start: this.cursor, end: this.cursor};

	while (this.stdin.charAt(this.cursor) === " " || this.stdin.charAt(this.cursor) === "\t" || this.stdin.charAt(this.cursor) === "\n" || this.stdin.charAt(this.cursor) === "\r") {
		_.ok = true;
		_.value += this.stdin.charAt(this.cursor);
		_.end = this.cursor;
		this.cursor++;
	}

	if (_.ok) {
		addTokenMatch(this.namedMatches, "whitespace", _);
		this.matches.push(_)
	}

	return _;
}

const ignore = function(this: Context) {
	return $$whitespace.call(this).ok;
}

// This is a token matching function
function $$number(this: Context) {
	let _: TokenMatch = {value: "", ok: false, start: this.cursor, end: this.cursor};

	while (this.stdin.charAt(this.cursor) >= "0" && this.stdin.charAt(this.cursor) <= "9") {
		_.ok = true;
		_.value += this.stdin.charAt(this.cursor);
		_.end = this.cursor;
		this.cursor++;
	}

	if (_.ok) {
		addTokenMatch(this.namedMatches, "number", _);
		this.matches.push(_)
	}

	return { ok: _.ok, _ };
}

const result = compile("123+456");

console.log(result.tree.body[0].expression); // 123
