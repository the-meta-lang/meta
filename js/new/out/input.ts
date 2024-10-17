let pflag = false;
let tflag = false;
let eflag = false;
let inbuf = "";
let outbuf = "";
let match: string = "";
let cursor: number = 0;
let erule = "";
let einput = 0;
let labelcount = 0;
let stackframesize = 6;
let stackframe = 0;
let stos = -1;
let parsetree = { type: "", children: [] };
let __TREE__ = parsetree;
let stack: any[] = [];
function initialize() {
	// initialize for another compile
	pflag = false;
	tflag = false;
	eflag = false;
	outbuf = "";
	erule = "";
	einput = 0;
	parsetree = { type: "Program", children: [] };
	__TREE__ = parsetree;
	labelcount = 1;
	stackframe = -1;
	stos = -1;
	stack = [];
}
function ctxpush(rulename: string) {
	// push and initialize a new stackframe
	var LM;
	// new context inherits current context left margin
	LM = 0;
	if (stackframe >= 0) LM = stack[stackframe + 2];
	stos++;
	stackframe = stos * stackframesize;
	// stackframe definition
	stack[stackframe + 0] = 0; // generated label
	stack[stackframe + 1] = rulename; // called rule name
	stack[stackframe + 2] = LM; // left margin
	stack[stackframe + 3] = cursor; // left margin
	// clear additional stackframe backtracking entries
	bkclear();
}
function ctxpop() {
	// pop and possibly deallocate old stackframe
	stos--; // pop stackframe
	stackframe = stos * stackframesize;
}
function out(s: string) {
	// output string
	var i;
	// if newline last output, add left margin before string
	if (outbuf.charAt(outbuf.length - 1) == "\n") {
		i = stack[stackframe + 2];
		while (i > 0) {
			outbuf += " ";
			i--;
		}
	}
	outbuf += s;
}
function eol() {
	// output end of line
	outbuf += "\n";
}
function test(s: string) {
	// test for a string in the input
	var i;
	// delete whitespace
	while (
		inbuf.charAt(cursor) == " " ||
		inbuf.charAt(cursor) == "\n" ||
		inbuf.charAt(cursor) == "\r" ||
		inbuf.charAt(cursor) == "\t"
	)
		cursor++;
	// test string case insensitive
	pflag = true;
	i = 0;
	while (pflag && i < s.length && cursor + i < inbuf.length) {
		pflag =
			s.charAt(i).toUpperCase() ==
			inbuf.charAt(cursor + i).toUpperCase();
		i++;
	}
	pflag = pflag && i == s.length;
	// advance input if found
	if (pflag) cursor += s.length;
}
function bkerr() {
	// compilation error, provide error indication and context
	eflag = true;
	erule = stack[stackframe + 1];
	einput = cursor;
}
function bkset() {
	// set backtrack context on stack
	stack[stackframe + 4] = cursor; // input position
	stack[stackframe + 5] = outbuf.length; // output position
	stack[stackframe + 6] = match; // current token
}
function bkclear() {
	// clear backtrack context on stack
	stack[stackframe + 4] = -1; // input position
	stack[stackframe + 5] = -1; // output position
	stack[stackframe + 6] = ""; // current token
}
function bkrestore() {
	// restore context for backtracking
	eflag = false;
	cursor = stack[stackframe + 4]; // input position
	outbuf = outbuf.substring(0, stack[stackframe + 5]); // output position
	match = stack[stackframe + 6]; // current token
}

type Match = {
	ok: boolean;
};

interface TokenMatch extends Match {
	value: string;
}

interface Context {
	matches: Match[];
	namedMatches: Record<string, Match[]>;
	stdin: string;
	stdout: string;
	cursor: number;
	tree: Tree;
}

interface Tree {
	[key: string]: any | Tree;
}

type RuleFunction<T extends any[] = any[]> = (this: Context, ...args: T) => Match;

type TokenFunction<T extends any[] = any[]> = (this: Context, ...args: T) => TokenMatch;


export function compile(input: string) {
  // initialize compiler variables
  inbuf = input;
  initialize() ;
  // call the first rule
  ctxpush("program") ;
  let _ = $program.call({
		cursor: 0,
		matches: [],
		namedMatches: {},
		stdin: input,
		stdout: "",
		tree: {}
	}) ;
  ctxpop() ;
  // special case handling of first rule failure
  if ((!eflag) && (!_.ok)) {
    eflag = true ;
    erule = "program";};
  return { outbuf, eflag, inp: cursor, erule, stack, inbuf, parsetree };
}

const $program: RuleFunction = function(this: Context){
  let _: Match;
  _ = test("awd");
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  return { ok: _.ok }
}

