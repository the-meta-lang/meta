import { Writable } from "stream";

interface Node extends Location {
	__RAW__: string;
	__PROPERTIES__: { [key: string]: string };
}

interface Match extends Location {
	__RAW__: string;
}

abstract class Location {
	constructor(public __START__: number, public __END__: number) {}
}

class Scope extends Location {
	// The last captured match
	__MATCH__?: string;
	// A list of all matches that occured up till now
	__MATCHES__: string[] = [];
	// The current offset for the stdin
	__CURSOR__: number = 0;
	__STDOUT__?: Writable;
	__STDERR__?: Writable;
	__STDIN__?: string;
	// A flat list of all captured nodes
	__NODES__: Node[] = [];
	// The last captured node
	__NODE__?: Node;

	constructor(__START__: number, __END__: number) {
		super(__START__, __END__);
	}
}

class PipedBuffer extends Writable {
	public buffer: string;

	constructor() {
		super();
		this.buffer = ""; // Initialize an empty buffer
	}

	_write(
		chunk: Buffer,
		encoding: string,
		callback: (error?: Error | null) => void
	): void {
		// Append the chunk to the buffer
		this.buffer += chunk;

		// Log the chunk to stdout
		process.stdout.write(chunk);

		// Signal that writing is complete
		callback();
	}

	get length(): number {
		return this.buffer.length;
	}
}

class WriteBuffer {
	public buffer: string;
	private captures: string[];

	constructor() {
		this.buffer = "";
		this.captures = [];
	}
	write(s: string) {
		this.buffer += s;
	}
	writeln(s: string) {
		this.buffer += s + "\n";
	}
	toString() {
		return this.buffer;
	}
	get length() {
		return this.buffer.length;
	}
}

class ReadBuffer {
	constructor(public buffer: string) {}
	charAt(pos: number) {
		return this.buffer.charAt(pos);
	}
	charCodeAt(pos: number) {
		return this.buffer.charCodeAt(pos);
	}
	toString() {
		return this.buffer;
	}
	get length() {
		return this.buffer.length;
	}
}

// runtime variables
let pflag = false;
let tflag = false;
let eflag = false;
let inbuf = "";
let stdin = inbuf;
let outbuf = new WriteBuffer();
let stdout = outbuf;
let __SCOPE__ = new Scope(0, 0);
let __STACK__ = [];
let erule = "";
let einput = 0;
let labelcount = 0;
let stackframesize = 6;
let stackframe = 0;
let stos = -1;
let parsetree = { type: "", children: [] };
let __TREE__ = parsetree;
let __NODES__ = [];
let __NODE__ = null;
let stack: any[] = [];

function combineParseTreeChildren(type: string, obj: Object, count: number) {
	let children = __TREE__.children.slice(-count);
	__TREE__.children = __TREE__.children.slice(0, -count);
	__TREE__.children.push({
		type,
		...obj,
		start: stack[stackframe + 3],
		end: __SCOPE__.__CURSOR__,
		children,
	});
}

export function initialize() {
	// initialize for another compile
	pflag = false;
	tflag = false;
	eflag = false;
	outbuf = new WriteBuffer();
	stdout = outbuf;
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
	stack[stackframe + 3] = __SCOPE__.__CURSOR__; // left margin
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
	if (outbuf.buffer.charAt(outbuf.length - 1) == "\n") {
		i = stack[stackframe + 2];
		while (i > 0) {
			outbuf.write(" ");
			i--;
		}
	}
	outbuf.write(s);
}

function eol() {
	// output end of line
	outbuf.write("\n");
}

function test(s: string) {
	// test for a string in the input
	var i;
	// delete whitespace
	while (
		inbuf.charAt(__SCOPE__.__CURSOR__) == " " ||
		inbuf.charAt(__SCOPE__.__CURSOR__) == "\n" ||
		inbuf.charAt(__SCOPE__.__CURSOR__) == "\r" ||
		inbuf.charAt(__SCOPE__.__CURSOR__) == "\t"
	)
		__SCOPE__.__CURSOR__++;
	// test string case insensitive
	pflag = true;
	i = 0;
	while (pflag && i < s.length && __SCOPE__.__CURSOR__ + i < inbuf.length) {
		pflag =
			s.charAt(i).toUpperCase() ==
			inbuf.charAt(__SCOPE__.__CURSOR__ + i).toUpperCase();
		i++;
	}
	pflag = pflag && i == s.length;
	// advance input if found
	if (pflag) __SCOPE__.__CURSOR__ += s.length;
}

function bkerr() {
	// compilation error, provide error indication and context
	eflag = true;
	erule = stack[stackframe + 1];
	einput = __SCOPE__.__CURSOR__;
}

function bkset() {
	// set backtrack context on stack
	stack[stackframe + 4] = __SCOPE__.__CURSOR__; // input position
	stack[stackframe + 5] = outbuf.length; // output position
	stack[stackframe + 6] = __SCOPE__.__MATCH__; // current token
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
	__SCOPE__.__CURSOR__ = stack[stackframe + 4]; // input position
	outbuf.buffer = outbuf.buffer.substring(0, stack[stackframe + 5]); // output position
	__SCOPE__.__MATCH__ = stack[stackframe + 6]; // current token
	__SCOPE__.__MATCHES__.push(__SCOPE__.__MATCH__);
}