// PROGRAM compiler
import * as fs from "fs";
import { join } from "path";
export function compile(input: string) {
  // initialize compiler variables
  inbuf = input;
  stdin = inbuf;
  initialize() ;
  // call the first rule
  ctxpush("PROGRAM") ;
  rulePROGRAM() ;
  ctxpop() ;
  // special case handling of first rule failure
  if ((!eflag) && (!pflag)) {
    eflag = true ;
    erule = "PROGRAM" ;
    einput = __SCOPE__.__CURSOR__ ; } ;
  return { outbuf, eflag, inp: __SCOPE__.__CURSOR__, erule, stack, inbuf, parsetree, __SCOPE__ };
}

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
// body of compiler definition 
function rulePROGRAM(){
  pflag = true ;
  while (pflag && !eflag) {
    ctxpush("CODE_RULE") ;
    ruleCODE_RULE();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
    if ((!pflag) && (!eflag)) {
      ctxpush("INCLUDE_STATEMENT") ;
      ruleINCLUDE_STATEMENT();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
    } ;
  } ;
  pflag = !eflag ;
  if (pflag) {
    while (!eflag) {
      test(".SYNTAX");
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("ID") ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("// ") ;
      out(__SCOPE__.__MATCH__) ;
      out(" compiler") ;
      eol() ;
      out("import * as fs from ") ;
      out(String.fromCharCode(34)) ;
      out("fs") ;
      out(String.fromCharCode(34)) ;
      out(";") ;
      eol() ;
      out("import { join } from ") ;
      out(String.fromCharCode(34)) ;
      out("path") ;
      out(String.fromCharCode(34)) ;
      out(";") ;
      eol() ;
      ctxpush("PREAMBLE") ;
      rulePREAMBLE();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("PR") ;
        rulePR();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("INCLUDE_STATEMENT") ;
          ruleINCLUDE_STATEMENT();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("CODE_RULE") ;
          ruleCODE_RULE();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("COMMENT") ;
          ruleCOMMENT();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(".TOKENS");
      if (pflag) {
        while (!eflag) {
          pflag = true ;
          while (pflag && !eflag) {
            ctxpush("TR") ;
            ruleTR();
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                break }
            } ;
            if ((!pflag) && (!eflag)) {
              ctxpush("COMMENT") ;
              ruleCOMMENT();
              ctxpop() ;
              if (pflag) {
                while (!eflag) {
                  break }
              } ;
            } ;
          } ;
          pflag = !eflag ;
          if (!pflag) bkerr();
          if (eflag) break ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(".END");
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

// object definition preamble 
function rulePREAMBLE(){
  out("export function compile(input: string) {") ;
  stack[stackframe + 2] += 2 ;
  eol() ;
  if (true) {
    while (!eflag) {
      out("// initialize compiler variables") ;
      eol() ;
      out("inbuf = input;") ;
      eol() ;
      out("stdin = inbuf;") ;
      eol() ;
      out("initialize() ;") ;
      eol() ;
      out("// call the first rule") ;
      eol() ;
      out("ctxpush(") ;
      out(String.fromCharCode(34)) ;
      out(__SCOPE__.__MATCH__) ;
      out(String.fromCharCode(34)) ;
      out(") ;") ;
      eol() ;
      out("rule") ;
      out(__SCOPE__.__MATCH__) ;
      out("() ;") ;
      eol() ;
      out("ctxpop() ;") ;
      eol() ;
      out("// special case handling of first rule failure") ;
      eol() ;
      out("if ((!eflag) && (!pflag)) {") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out("eflag = true ;") ;
      eol() ;
      out("erule = ") ;
      out(String.fromCharCode(34)) ;
      out(__SCOPE__.__MATCH__) ;
      out(String.fromCharCode(34)) ;
      out(" ;") ;
      eol() ;
      out("einput = __SCOPE__.__CURSOR__ ; } ;") ;
      stack[stackframe + 2] -= 2 ;
      eol() ;
      out("return { outbuf, eflag, inp: __SCOPE__.__CURSOR__, erule, stack, inbuf, parsetree, __SCOPE__ };") ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out("}") ;
      eol() ;
      eol() ;
      break }
  } ;
}

// parsing rule definition 
// @example PARSE_RULE<argument, argument2>
function rulePR(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out("function rule") ;
      out(__SCOPE__.__MATCH__) ;
      test("<");
      if (pflag) {
        while (!eflag) {
          out("(") ;
          ctxpush("PARSE_RULE_ARGUMENT_DEFINITION_LIST") ;
          rulePARSE_RULE_ARGUMENT_DEFINITION_LIST();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          test(">");
          if (!pflag) bkerr();
          if (eflag) break ;
          out(")") ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            out("()") ;
            break }
        } ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("{") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      test("=");
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("EX1") ;
      ruleEX1();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(";");
      if (!pflag) bkerr();
      if (eflag) break ;
      stack[stackframe + 2] -= 2 ;
      out("}") ;
      eol() ;
      eol() ;
      break }
  } ;
}

// token rule definition 
function ruleTR(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out("function rule") ;
      out(__SCOPE__.__MATCH__) ;
      out("() {") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      test(":");
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("TX1") ;
      ruleTX1();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(";");
      if (!pflag) bkerr();
      if (eflag) break ;
      stack[stackframe + 2] -= 2 ;
      out("}") ;
      eol() ;
      eol() ;
      break }
  } ;
}

// comment definition 
function ruleCOMMENT(){
  test("//");
  if (pflag) {
    while (!eflag) {
      ctxpush("CMLINE") ;
      ruleCMLINE();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("//") ;
      out(__SCOPE__.__MATCH__) ;
      eol() ;
      break }
  } ;
}

// --------------------------------- Imports -----------------------------------
// TODO: Implement import command
function ruleIMPORT_COMMAND(){
  test(".IMPORT");
  if (pflag) {
    while (!eflag) {
      test("(");
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("STRING") ;
      ruleSTRING();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(")");
      if (!pflag) bkerr();
      if (eflag) break ;
      out("inbuf = new ReadBuffer(fs.readFileSync(import.meta.dirname + ") ;
      out(String.fromCharCode(34)) ;
      out("/") ;
      out(__SCOPE__.__MATCH__) ;
      out(String.fromCharCode(34)) ;
      out(", 'utf8'));") ;
      eol() ;
      break }
  } ;
}

// -------------------------- Parse Tree Operators -----------------------------
// Captures a node for the current parse tree
// @example (ID :Identifier);
// @example @(ID :Identifier) ~ &scope :Block<id = &scope["__NODES__"][0]>[0];
function ruleCAPTURE_SINGLE_NODE(){
  test("::");
  if (pflag) {
    while (!eflag) {
      ctxpush("ID") ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("__NODE__ = { type: ") ;
      out(String.fromCharCode(34)) ;
      out(__SCOPE__.__MATCH__) ;
      out(String.fromCharCode(34)) ;
      out(", start: stack[stackframe + 3], end: __SCOPE__.__CURSOR__, raw: __SCOPE__.__MATCH__,") ;
      test("<");
      if (pflag) {
        while (!eflag) {
          ctxpush("FULL_ARGUMENT") ;
          ruleFULL_ARGUMENT();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          pflag = true ;
          while (pflag && !eflag) {
            test(",");
            if (pflag) {
              while (!eflag) {
                ctxpush("FULL_ARGUMENT") ;
                ruleFULL_ARGUMENT();
                ctxpop() ;
                if (!pflag) bkerr();
                if (eflag) break ;
                break }
            } ;
          } ;
          pflag = !eflag ;
          if (!pflag) bkerr();
          if (eflag) break ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("};") ;
      eol() ;
      out("__STACK__.push(__NODE__);") ;
      eol() ;
      out("__NODES__.push(__NODE__);") ;
      eol() ;
      break }
  } ;
}

function ruleCAPTURE_LAST_NODES(){
  test(":");
  if (pflag) {
    while (!eflag) {
      ctxpush("ID") ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("combineParseTreeChildren(") ;
      out(String.fromCharCode(34)) ;
      out(__SCOPE__.__MATCH__) ;
      out(String.fromCharCode(34)) ;
      out(",") ;
      out("{") ;
      test("<");
      if (pflag) {
        while (!eflag) {
          ctxpush("FULL_ARGUMENT") ;
          ruleFULL_ARGUMENT();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          pflag = true ;
          while (pflag && !eflag) {
            test(",");
            if (pflag) {
              while (!eflag) {
                ctxpush("FULL_ARGUMENT") ;
                ruleFULL_ARGUMENT();
                ctxpop() ;
                if (!pflag) bkerr();
                if (eflag) break ;
                break }
            } ;
          } ;
          pflag = !eflag ;
          if (!pflag) bkerr();
          if (eflag) break ;
          test(">");
          if (!pflag) bkerr();
          if (eflag) break ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("},") ;
      test("[");
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("NUMBER") ;
      ruleNUMBER();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test("]");
      if (!pflag) bkerr();
      if (eflag) break ;
      out(__SCOPE__.__MATCH__) ;
      out(");") ;
      eol() ;
      break }
  } ;
}

function ruleFULL_ARGUMENT(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out(__SCOPE__.__MATCH__) ;
      out(": ") ;
      test("=");
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("ARGUMENT") ;
      ruleARGUMENT();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out(",") ;
      break }
  } ;
}

function ruleARGUMENT(){
  ctxpush("RAWSTRING") ;
  ruleRAWSTRING();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("NUMBER") ;
    ruleNUMBER();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("ID") ;
    ruleID();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if (pflag) {
    while (!eflag) {
      out(__SCOPE__.__MATCH__) ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test("**");
    if (pflag) {
      while (!eflag) {
        test("[");
        if (!pflag) bkerr();
        if (eflag) break ;
        ctxpush("NUMBER") ;
        ruleNUMBER();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("ID") ;
          ruleID();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out("__SCOPE__.__MATCHES__.at(") ;
        out(__SCOPE__.__MATCH__) ;
        out(")") ;
        test("]");
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("@");
    if (pflag) {
      while (!eflag) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(__SCOPE__.__MATCH__) ;
            out(".toString()") ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          pflag = true ;
          if (pflag) {
            while (!eflag) {
              out("outbuf.toString()") ;
              break }
          } ;
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("&");
    if (pflag) {
      while (!eflag) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        ctxpush("OBJECT_ACCESSOR") ;
        ruleOBJECT_ACCESSOR();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            pflag = true ;
            while (pflag && !eflag) {
              ctxpush("OBJECT_ACCESSOR") ;
              ruleOBJECT_ACCESSOR();
              ctxpop() ;
              if (pflag) {
                while (!eflag) {
                  break }
              } ;
            } ;
            pflag = !eflag ;
            if (!pflag) bkerr();
            if (eflag) break ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          pflag = true ;
          if (pflag) {
            while (!eflag) {
              out(__SCOPE__.__MATCH__) ;
              break }
          } ;
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
}

function ruleOBJECT_ACCESSOR(){
  test("[");
  if (pflag) {
    while (!eflag) {
      ctxpush("RAWSTRING") ;
      ruleRAWSTRING();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        ctxpush("NUMBER") ;
        ruleNUMBER();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if ((!pflag) && (!eflag)) {
        test("&");
        if (pflag) {
          while (!eflag) {
            ctxpush("ID") ;
            ruleID();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test("]");
      if (!pflag) bkerr();
      if (eflag) break ;
      out("[") ;
      out(__SCOPE__.__MATCH__) ;
      out("]") ;
      break }
  } ;
}

// -------------------------- META Lisp Definitions ----------------------------
function ruleCODE_RULE(){
  ctxpush("LISP") ;
  ruleLISP();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
}

function ruleLISPARG(output = false){
  bkset() ;
  ctxpush("LISP_OBJECT_ACCESSOR") ;
  ruleLISP_OBJECT_ACCESSOR();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  if (!pflag) {
    if (eflag) bkrestore() ;
    ctxpush("ID") ;
    ruleID();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
    if ((!pflag) && (!eflag)) {
      ctxpush("NUMBER") ;
      ruleNUMBER();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
    } ;
    if ((!pflag) && (!eflag)) {
      ctxpush("RAWSTRING") ;
      ruleRAWSTRING();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
    } ;
    if (pflag) {
      while (!eflag) {
        out(__SCOPE__.__MATCH__) ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if (!pflag) {
    if (eflag) bkrestore() ;
    ctxpush("LISP_OBJECT") ;
    ruleLISP_OBJECT();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if (!pflag) {
    if (eflag) bkrestore() ;
    ctxpush("LISP_ARRAY") ;
    ruleLISP_ARRAY();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if (eflag) bkrestore() ;
  bkclear() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
}

function ruleLISP_KEY(){
  bkset() ;
  ctxpush("LISP_OBJECT_ACCESSOR") ;
  ruleLISP_OBJECT_ACCESSOR();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  if (!pflag) {
    if (eflag) bkrestore() ;
    ctxpush("ID") ;
    ruleID();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out(__SCOPE__.__MATCH__) ;
        break }
    } ;
  } ;
  if (eflag) bkrestore() ;
  bkclear() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
}

function ruleLISP_OBJECT_ACCESSOR(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      test("::");
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("ID") ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out(__SCOPE__.__MATCHES__.at(-2));
      out(".") ;
      out(__SCOPE__.__MATCH__) ;
      break }
  } ;
}

function ruleLISP_ARRAY(){
  test("'[");
  if (pflag) {
    while (!eflag) {
      out("[") ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("LISPARG") ;
        ruleLISPARG();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test("]");
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleLISP_OBJECT(){
  test("'{");
  if (pflag) {
    while (!eflag) {
      out("{") ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(__SCOPE__.__MATCH__) ;
            out(": ") ;
            test(":");
            if (!pflag) bkerr();
            if (eflag) break ;
            ctxpush("LISPARG") ;
            ruleLISPARG();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            out(",") ;
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test("}");
      if (!pflag) bkerr();
      if (eflag) break ;
      out("};") ;
      eol() ;
      break }
  } ;
}

function ruleLISP_LANGUAGE_CONSTRUCTS(){
  test("while");
  if (pflag) {
    while (!eflag) {
      ctxpush("LISPARG") ;
      ruleLISPARG();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("while (") ;
      out(__SCOPE__.__MATCH__) ;
      out(") {") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      ctxpush("LISPARG") ;
      ruleLISPARG();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      stack[stackframe + 2] -= 2 ;
      out("} ;") ;
      eol() ;
      break }
  } ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test("if");
    if (pflag) {
      while (!eflag) {
        out("if (") ;
        ctxpush("LISP") ;
        ruleLISP();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("LISPARG") ;
          ruleLISPARG(true);
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(") {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        ctxpush("LISP") ;
        ruleLISP();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        stack[stackframe + 2] -= 2 ;
        out("} ;") ;
        eol() ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("set");
    if (pflag) {
      while (!eflag) {
        ctxpush("LISP_KEY") ;
        ruleLISP_KEY();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(" = ") ;
        ctxpush("LISPARG") ;
        ruleLISPARG(true);
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(";") ;
        eol() ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("defunc");
    if (pflag) {
      while (!eflag) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out("function ") ;
        out(__SCOPE__.__MATCH__) ;
        out("(") ;
        test("[");
        if (!pflag) bkerr();
        if (eflag) break ;
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(__SCOPE__.__MATCH__) ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          pflag = true ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        pflag = true ;
        while (pflag && !eflag) {
          ctxpush("ID") ;
          ruleID();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              out(", ") ;
              out(__SCOPE__.__MATCH__) ;
              break }
          } ;
        } ;
        pflag = !eflag ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test("]");
        if (!pflag) bkerr();
        if (eflag) break ;
        out(") {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        pflag = true ;
        while (pflag && !eflag) {
          ctxpush("LISP") ;
          ruleLISP();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        pflag = !eflag ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out("}") ;
        stack[stackframe + 2] -= 2 ;
        eol() ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("define");
    if (pflag) {
      while (!eflag) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out("let ") ;
            out(__SCOPE__.__MATCH__) ;
            out(" = ") ;
            break }
        } ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          test("[");
          if (pflag) {
            while (!eflag) {
              ctxpush("ID") ;
              ruleID();
              ctxpop() ;
              if (!pflag) bkerr();
              if (eflag) break ;
              out("let ") ;
              out(__SCOPE__.__MATCH__) ;
              out(" = ") ;
              ctxpush("TYPE") ;
              ruleTYPE();
              ctxpop() ;
              if (!pflag) bkerr();
              if (eflag) break ;
              test("]");
              if (!pflag) bkerr();
              if (eflag) break ;
              break }
          } ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        ctxpush("LISPARG") ;
        ruleLISPARG(true);
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(";") ;
        eol() ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("->");
    if (pflag) {
      while (!eflag) {
        pflag = true ;
        while (pflag && !eflag) {
          out("out(") ;
          if (true) {
            while (!eflag) {
              ctxpush("LISPARG") ;
              ruleLISPARG(true);
              ctxpop() ;
              if (!pflag) bkerr();
              if (eflag) break ;
              out(")") ;
              break }
          } ;
        } ;
        pflag = !eflag ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(";") ;
        eol() ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("throw");
    if (pflag) {
      while (!eflag) {
        out("throw new Error(") ;
        ctxpush("LISPARG") ;
        ruleLISPARG(true);
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(");") ;
        eol() ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("+=");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("+");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("-");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("*");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("/");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD(">");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("<");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("==");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("!=");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("<=");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD(">=");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("&&");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_OPERATOR_METHOD") ;
    ruleLISP_OPERATOR_METHOD("||");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP_FUNCTION_CALL") ;
    ruleLISP_FUNCTION_CALL();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
}

function ruleLISP_FUNCTION_CALL(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out(__SCOPE__.__MATCH__) ;
      out("(") ;
      ctxpush("LISPARG") ;
      ruleLISPARG();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          out(__SCOPE__.__MATCH__) ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        ctxpush("LISP") ;
        ruleLISP();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("LISPARG") ;
        ruleLISPARG();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(", ") ;
            out(__SCOPE__.__MATCH__) ;
            break }
        } ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("LISP") ;
          ruleLISP();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out(");") ;
      eol() ;
      break }
  } ;
}

function ruleLISP_OPERATOR_METHOD(Operator){
  test(Operator);
  if (pflag) {
    while (!eflag) {
      ctxpush("LISPARG") ;
      ruleLISPARG(true);
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        ctxpush("LISP") ;
        ruleLISP();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag && !eflag) {
        // We need to reorder the arguments for the operator to work.
        if (pflag) {
          while (!eflag) {
            // We create a temporary buffer and copy the operator before the arguments
            if (!pflag) bkerr();
            if (eflag) break ;
            outbuf = new WriteBuffer();
            ctxpush("LISPARG") ;
            ruleLISPARG(true);
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                break }
            } ;
            __STACK__.push(outbuf);
            outbuf = stdout;
            if (pflag) {
              while (!eflag) {
                TempBuffer = __STACK__.pop();
                if (!pflag) bkerr();
                if (eflag) break ;
                out(Operator);
                outbuf.write(TempBuffer.toString());
                break }
            } ;
            if (!pflag) bkerr();
            if (eflag) break ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("LISP") ;
          ruleLISP();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              // Since we capture the output into a temporary buffer before doing input validation, we need to dispose of
              if (!pflag) bkerr();
              if (eflag) break ;
              // the trailing buffer that persists.
              if (!pflag) bkerr();
              if (eflag) break ;
              break }
          } ;
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      eol() ;
      break }
  } ;
}

function ruleLISP(){
  test("[");
  if (pflag) {
    while (!eflag) {
      ctxpush("LISP_LANGUAGE_CONSTRUCTS") ;
      ruleLISP_LANGUAGE_CONSTRUCTS();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test("]");
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test("[");
    if (pflag) {
      while (!eflag) {
        ctxpush("LISP") ;
        ruleLISP();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test("]");
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("COMMENT") ;
    ruleCOMMENT();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
}

// ---------------------------------- Types ------------------------------------
// [+= counter 1]
function ruleTYPE(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
}

// --------------------------- Parsing expressions -----------------------------
function ruleEX1(){
  ctxpush("EX2") ;
  ruleEX2();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      pflag = true ;
      while (pflag && !eflag) {
        test("|");
        if (pflag) {
          while (!eflag) {
            out("if ((!pflag) && (!eflag)) {") ;
            stack[stackframe + 2] += 2 ;
            eol() ;
            ctxpush("EX2") ;
            ruleEX2();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            stack[stackframe + 2] -= 2 ;
            out("} ;") ;
            eol() ;
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleEX2(){
  ctxpush("EX3") ;
  ruleEX3();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out("if (pflag) {") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("OUTPUT") ;
    ruleOUTPUT();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out("if (true) {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("INCLUDE_STATEMENT") ;
    ruleINCLUDE_STATEMENT();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("DIRECT_OUTPUT") ;
    ruleDIRECT_OUTPUT();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if (pflag) {
    while (!eflag) {
      out("while (!eflag) {") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("EX3") ;
        ruleEX3();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out("if (!pflag) bkerr();") ;
            eol() ;
            out("if (eflag) break ;") ;
            eol() ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("OUTPUT") ;
          ruleOUTPUT();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("INCLUDE_STATEMENT") ;
          ruleINCLUDE_STATEMENT();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("DIRECT_OUTPUT") ;
          ruleDIRECT_OUTPUT();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("break }") ;
      stack[stackframe + 2] -= 2 ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out("} ;") ;
      eol() ;
      break }
  } ;
}

function ruleINCLUDE_STATEMENT(){
  test(".INCLUDE");
  if (pflag) {
    while (!eflag) {
      test("(");
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("STRING") ;
      ruleSTRING();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(")");
      if (!pflag) bkerr();
      if (eflag) break ;
      out(fs.readFileSync(join(import.meta.dirname, __SCOPE__.__MATCH__), 'utf-8'));break }
  } ;
}

function ruleDIRECT_OUTPUT(){
  test(".DIRECT");
  if (pflag) {
    while (!eflag) {
      test("(");
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("STRING") ;
        ruleSTRING();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(__SCOPE__.__MATCH__) ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("NUMBER") ;
          ruleNUMBER();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              out(__SCOPE__.__MATCH__) ;
              break }
          } ;
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush("ID") ;
          ruleID();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              out(__SCOPE__.__MATCH__) ;
              break }
          } ;
        } ;
        if ((!pflag) && (!eflag)) {
          test("*");
          if (pflag) {
            while (!eflag) {
              out("__SCOPE__.__MATCH__") ;
              break }
          } ;
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(")");
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleEX3(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out("ctxpush(") ;
      out(String.fromCharCode(34)) ;
      out(__SCOPE__.__MATCH__) ;
      out(String.fromCharCode(34)) ;
      out(") ;") ;
      eol() ;
      out("rule") ;
      out(__SCOPE__.__MATCH__) ;
      out("(") ;
      test("<");
      if (pflag) {
        while (!eflag) {
          ctxpush("PARSE_RULE_ARGUMENT_LIST") ;
          rulePARSE_RULE_ARGUMENT_LIST();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          test(">");
          if (!pflag) bkerr();
          if (eflag) break ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out(");") ;
      eol() ;
      out("ctxpop() ;") ;
      eol() ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("STRING") ;
    ruleSTRING();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out("test(") ;
        out(String.fromCharCode(34)) ;
        out(__SCOPE__.__MATCH__) ;
        out(String.fromCharCode(34)) ;
        out(");") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("(");
    if (pflag) {
      while (!eflag) {
        ctxpush("EX1") ;
        ruleEX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(")");
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".EMPTY");
    if (pflag) {
      while (!eflag) {
        out("pflag = true ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".LITCHR");
    if (pflag) {
      while (!eflag) {
        out("__SCOPE__.__MATCH__ = inbuf.charCodeAt(__SCOPE__.__CURSOR__) ;") ;
        eol() ;
        out("__SCOPE__.__MATCHES__.push(__SCOPE__.__MATCH__);") ;
        eol() ;
        out("__SCOPE__.__CURSOR__++ ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".PASS");
    if (pflag) {
      while (!eflag) {
        out("__SCOPE__.__CURSOR__ = 0 ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("$");
    if (pflag) {
      while (!eflag) {
        out("pflag = true ;") ;
        eol() ;
        out("while (pflag && !eflag) {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        ctxpush("EX3") ;
        ruleEX3();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        stack[stackframe + 2] -= 2 ;
        out("} ;") ;
        eol() ;
        out("pflag = !eflag ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("{");
    if (pflag) {
      while (!eflag) {
        out("bkset() ;") ;
        eol() ;
        ctxpush("EX1") ;
        ruleEX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        pflag = true ;
        while (pflag && !eflag) {
          test("/");
          if (pflag) {
            while (!eflag) {
              out("if (!pflag) {") ;
              stack[stackframe + 2] += 2 ;
              eol() ;
              out("if (eflag) bkrestore() ;") ;
              eol() ;
              ctxpush("EX1") ;
              ruleEX1();
              ctxpop() ;
              if (!pflag) bkerr();
              if (eflag) break ;
              stack[stackframe + 2] -= 2 ;
              out("} ;") ;
              eol() ;
              break }
          } ;
        } ;
        pflag = !eflag ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test("}");
        if (!pflag) bkerr();
        if (eflag) break ;
        out("if (eflag) bkrestore() ;") ;
        eol() ;
        out("bkclear() ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("*");
    if (pflag) {
      while (!eflag) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out("test(") ;
        out(__SCOPE__.__MATCH__) ;
        out(");") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("?");
    if (pflag) {
      while (!eflag) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out("eflag = ") ;
        out(__SCOPE__.__MATCH__) ;
        out(" ? false : true;") ;
        eol() ;
        // Capture all following matches into a different buffer
        if (!pflag) bkerr();
        if (eflag) break ;
        // If an ID is given immediately after, a named buffer is created
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("@");
    if (pflag) {
      while (!eflag) {
        out("outbuf = new WriteBuffer();") ;
        eol() ;
        test("(");
        if (!pflag) bkerr();
        if (eflag) break ;
        ctxpush("EX1") ;
        ruleEX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(")");
        if (!pflag) bkerr();
        if (eflag) break ;
        // Store the buffer into the stack where it can be collected later.
        if (!pflag) bkerr();
        if (eflag) break ;
        out("__STACK__.push(outbuf);") ;
        eol() ;
        // Revert the output buffer back to the standard buffer
        if (!pflag) bkerr();
        if (eflag) break ;
        out("outbuf = stdout;") ;
        eol() ;
        // Collect the last value on the stack
        if (!pflag) bkerr();
        if (eflag) break ;
        // @example @(ID) ~ &id
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("~");
    if (pflag) {
      while (!eflag) {
        test("&");
        if (pflag) {
          while (!eflag) {
            ctxpush("ID") ;
            ruleID();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            out(__SCOPE__.__MATCH__) ;
            out(" = __STACK__.pop();") ;
            eol() ;
            break }
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("IMPORT_COMMAND") ;
    ruleIMPORT_COMMAND();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("CAPTURE_SINGLE_NODE") ;
    ruleCAPTURE_SINGLE_NODE();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("CAPTURE_LAST_NODES") ;
    ruleCAPTURE_LAST_NODES();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("LISP") ;
    ruleLISP();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("COMMENT") ;
    ruleCOMMENT();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
}

// ------------------------- Parsing Rule Arguments ----------------------------
function rulePARSE_RULE_ARGUMENT_LIST(){
  ctxpush("PARSE_RULE_ARGUMENT") ;
  rulePARSE_RULE_ARGUMENT();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out(__SCOPE__.__MATCH__) ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("PARSE_RULE_ARGUMENT") ;
        rulePARSE_RULE_ARGUMENT();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(", ") ;
            out(__SCOPE__.__MATCH__) ;
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function rulePARSE_RULE_ARGUMENT(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("RAWSTRING") ;
    ruleRAWSTRING();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("NUMBER") ;
    ruleNUMBER();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
}

// Matches an argument passed to a match rule as a parameter.
function rulePARSE_RULE_ARGUMENT_DEFINITION(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out(__SCOPE__.__MATCH__) ;
      test(":");
      if (pflag) {
        while (!eflag) {
          ctxpush("TYPE") ;
          ruleTYPE();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          out("/*") ;
          out(":") ;
          out(__SCOPE__.__MATCH__) ;
          out("*/") ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test("=");
      if (pflag) {
        while (!eflag) {
          ctxpush("ID") ;
          ruleID();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
          if ((!pflag) && (!eflag)) {
            ctxpush("RAWSTRING") ;
            ruleRAWSTRING();
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                break }
            } ;
          } ;
          if ((!pflag) && (!eflag)) {
            ctxpush("NUMBER") ;
            ruleNUMBER();
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                break }
            } ;
          } ;
          if (!pflag) bkerr();
          if (eflag) break ;
          out(" = ") ;
          out(__SCOPE__.__MATCH__) ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function rulePARSE_RULE_ARGUMENT_DEFINITION_LIST(){
  ctxpush("PARSE_RULE_ARGUMENT_DEFINITION") ;
  rulePARSE_RULE_ARGUMENT_DEFINITION();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("PARSE_RULE_ARGUMENT_DEFINITION") ;
        rulePARSE_RULE_ARGUMENT_DEFINITION();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

// --------------------------- Output expressions ------------------------------
function ruleOUTPUT(){
  test("->");
  if (pflag) {
    while (!eflag) {
      test("(");
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("OUT1") ;
        ruleOUT1();
        ctxpop() ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(")");
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleOUT1(){
  test("**");
  if (pflag) {
    while (!eflag) {
      test("[");
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("NUMBER") ;
      ruleNUMBER();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("out(__SCOPE__.__MATCHES__.at(") ;
      out(__SCOPE__.__MATCH__) ;
      out("));") ;
      eol() ;
      test("]");
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test("*");
    if (pflag) {
      while (!eflag) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out("out(") ;
            out(__SCOPE__.__MATCH__) ;
            out(");") ;
            eol() ;
            break }
        } ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          pflag = true ;
          if (pflag) {
            while (!eflag) {
              out("out(__SCOPE__.__MATCH__) ;") ;
              eol() ;
              break }
          } ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("STRING") ;
    ruleSTRING();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out("out(") ;
        out(String.fromCharCode(34)) ;
        out(__SCOPE__.__MATCH__) ;
        out(String.fromCharCode(34)) ;
        out(") ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("NUMBER") ;
    ruleNUMBER();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out("out(String.fromCharCode(") ;
        out(__SCOPE__.__MATCH__) ;
        out(")) ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("#");
    if (pflag) {
      while (!eflag) {
        out("if (stack[stackframe + 0] == 0) {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        out("stack[stackframe + 0] = labelcount ;") ;
        eol() ;
        out("labelcount++ ; } ;") ;
        stack[stackframe + 2] -= 2 ;
        eol() ;
        out("out(stack[stackframe + 0]) ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".NL");
    if (pflag) {
      while (!eflag) {
        out("eol() ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".LB");
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".TB");
    if (pflag) {
      while (!eflag) {
        out("out(") ;
        out(String.fromCharCode(34)) ;
        out(String.fromCharCode(92)) ;
        out("t") ;
        out(String.fromCharCode(34)) ;
        out(") ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".LM+");
    if (pflag) {
      while (!eflag) {
        out("stack[stackframe + 2] += 2 ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".LM-");
    if (pflag) {
      while (!eflag) {
        out("stack[stackframe + 2] -= 2 ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("@");
    if (pflag) {
      while (!eflag) {
        ctxpush("ID") ;
        ruleID();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out("outbuf.write(") ;
            out(__SCOPE__.__MATCH__) ;
            out(".toString());") ;
            eol() ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          pflag = true ;
          if (pflag) {
            while (!eflag) {
              out("outbuf.write(outbuf.toString());") ;
              eol() ;
              break }
          } ;
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
}

// ---------------------------- Token expressions ------------------------------
function ruleTX1(){
  ctxpush("TX2") ;
  ruleTX2();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      pflag = true ;
      while (pflag && !eflag) {
        test("/");
        if (pflag) {
          while (!eflag) {
            out("if (!pflag) {") ;
            stack[stackframe + 2] += 2 ;
            eol() ;
            ctxpush("TX2") ;
            ruleTX2();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            stack[stackframe + 2] -= 2 ;
            out("} ;") ;
            eol() ;
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleTX2(){
  ctxpush("TX3") ;
  ruleTX3();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out("if (pflag) {") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("TX3") ;
        ruleTX3();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out("if (!pflag) return;") ;
            eol() ;
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      stack[stackframe + 2] -= 2 ;
      out("} ;") ;
      eol() ;
      break }
  } ;
}

function ruleTX3(){
  test(".TOKEN");
  if (pflag) {
    while (!eflag) {
      out("tflag = true ; ") ;
      eol() ;
      out("__SCOPE__.__MATCH__ = ") ;
      out(String.fromCharCode(34)) ;
      out(String.fromCharCode(34)) ;
      out(" ;") ;
      eol() ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test(".DELTOK");
    if (pflag) {
      while (!eflag) {
        out("tflag = false ;") ;
        eol() ;
        out("__SCOPE__.__MATCHES__.push(__SCOPE__.__MATCH__);") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("$");
    if (pflag) {
      while (!eflag) {
        out("pflag = true ;") ;
        eol() ;
        out("while (pflag) {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        ctxpush("TX3") ;
        ruleTX3();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        stack[stackframe + 2] -= 2 ;
        out("};") ;
        eol() ;
        break }
    } ;
  } ;
  if (pflag) {
    while (!eflag) {
      out("pflag = true ;") ;
      eol() ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test(".ANYBUT(");
    if (pflag) {
      while (!eflag) {
        ctxpush("CX1") ;
        ruleCX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(")");
        if (!pflag) bkerr();
        if (eflag) break ;
        out("pflag = !pflag ;") ;
        eol() ;
        out("if (pflag) {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        out("if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;") ;
        eol() ;
        out("__SCOPE__.__CURSOR__++ } ;") ;
        stack[stackframe + 2] -= 2 ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".ANY(");
    if (pflag) {
      while (!eflag) {
        ctxpush("CX1") ;
        ruleCX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(")");
        if (!pflag) bkerr();
        if (eflag) break ;
        out("if (pflag) {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        out("if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;") ;
        eol() ;
        out("__SCOPE__.__CURSOR__++ } ;") ;
        stack[stackframe + 2] -= 2 ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("ID") ;
    ruleID();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out("ctxpush(") ;
        out(String.fromCharCode(34)) ;
        out(__SCOPE__.__MATCH__) ;
        out(String.fromCharCode(34)) ;
        out(") ;") ;
        eol() ;
        out("rule") ;
        out(__SCOPE__.__MATCH__) ;
        out("() ;") ;
        eol() ;
        out("ctxpop() ;") ;
        eol() ;
        out("if (eflag) return ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("(");
    if (pflag) {
      while (!eflag) {
        ctxpush("TX1") ;
        ruleTX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(")");
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
}

// -------------------------- Character expressions ----------------------------
function ruleCX1(){
  out("pflag = ") ;
  stack[stackframe + 2] += 2 ;
  eol() ;
  if (true) {
    while (!eflag) {
      ctxpush("CX2") ;
      ruleCX2();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag && !eflag) {
        test("!");
        if (pflag) {
          while (!eflag) {
            out(" ||") ;
            eol() ;
            ctxpush("CX2") ;
            ruleCX2();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      stack[stackframe + 2] -= 2 ;
      out(" ;") ;
      eol() ;
      break }
  } ;
}

function ruleCX2(){
  ctxpush("CX3") ;
  ruleCX3();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      test(":");
      if (pflag) {
        while (!eflag) {
          out("((inbuf.charCodeAt(__SCOPE__.__CURSOR__) >= ") ;
          out(__SCOPE__.__MATCH__) ;
          out(") &&") ;
          eol() ;
          ctxpush("CX3") ;
          ruleCX3();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          out(" (inbuf.charCodeAt(__SCOPE__.__CURSOR__) <= ") ;
          out(__SCOPE__.__MATCH__) ;
          out(")  )") ;
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            out("(inbuf.charCodeAt(__SCOPE__.__CURSOR__) == ") ;
            out(__SCOPE__.__MATCH__) ;
            out(") ") ;
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleCX3(){
  ctxpush("NUMBER") ;
  ruleNUMBER();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("SQUOTE") ;
    ruleSQUOTE();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        __SCOPE__.__MATCH__ = inbuf.charCodeAt(__SCOPE__.__CURSOR__) ;
        __SCOPE__.__MATCHES__.push(__SCOPE__.__MATCH__);
        __SCOPE__.__CURSOR__++ ;
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
}

function rulePREFIX() {
  pflag = true ;
  while (pflag) {
    pflag = 
      (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 32)  ||
      (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 9)  ||
      (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 13)  ||
      (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 10)  ;
    if (pflag) {
      if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
      __SCOPE__.__CURSOR__++ } ;
  };
  pflag = true ;
  if (pflag) {
  } ;
}

function ruleID() {
  ctxpush("PREFIX") ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    tflag = true ; 
    __SCOPE__.__MATCH__ = "" ;
    pflag = true ;
    if (!pflag) return;
    ctxpush("ALPHA") ;
    ruleALPHA() ;
    ctxpop() ;
    if (eflag) return ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      ctxpush("ALPHA") ;
      ruleALPHA() ;
      ctxpop() ;
      if (eflag) return ;
      if (pflag) {
      } ;
      if (!pflag) {
        ctxpush("DIGIT") ;
        ruleDIGIT() ;
        ctxpop() ;
        if (eflag) return ;
        if (pflag) {
        } ;
      } ;
    };
    pflag = true ;
    if (!pflag) return;
    tflag = false ;
    __SCOPE__.__MATCHES__.push(__SCOPE__.__MATCH__);
    pflag = true ;
    if (!pflag) return;
  } ;
}

function ruleNUMBER() {
  ctxpush("PREFIX") ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    tflag = true ; 
    __SCOPE__.__MATCH__ = "" ;
    pflag = true ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      pflag = 
        (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 45)  ;
      if (pflag) {
        if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
        __SCOPE__.__CURSOR__++ } ;
    };
    pflag = true ;
    if (!pflag) return;
    ctxpush("DIGIT") ;
    ruleDIGIT() ;
    ctxpop() ;
    if (eflag) return ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      ctxpush("DIGIT") ;
      ruleDIGIT() ;
      ctxpop() ;
      if (eflag) return ;
    };
    pflag = true ;
    if (!pflag) return;
    tflag = false ;
    __SCOPE__.__MATCHES__.push(__SCOPE__.__MATCH__);
    pflag = true ;
    if (!pflag) return;
  } ;
}

function ruleSTRING() {
  ctxpush("PREFIX") ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    pflag = 
      (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 34)  ;
    if (pflag) {
      if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
      __SCOPE__.__CURSOR__++ } ;
    if (!pflag) return;
    tflag = true ; 
    __SCOPE__.__MATCH__ = "" ;
    pflag = true ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      pflag = 
        (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 13)  ||
        (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 10)  ||
        (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 34)  ;
      pflag = !pflag ;
      if (pflag) {
        if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
        __SCOPE__.__CURSOR__++ } ;
    };
    pflag = true ;
    if (!pflag) return;
    tflag = false ;
    __SCOPE__.__MATCHES__.push(__SCOPE__.__MATCH__);
    pflag = true ;
    if (!pflag) return;
    pflag = 
      (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 34)  ;
    if (pflag) {
      if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
      __SCOPE__.__CURSOR__++ } ;
    if (!pflag) return;
  } ;
}

function ruleRAWSTRING() {
  ctxpush("PREFIX") ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    tflag = true ; 
    __SCOPE__.__MATCH__ = "" ;
    pflag = true ;
    if (!pflag) return;
    pflag = 
      (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 34)  ;
    if (pflag) {
      if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
      __SCOPE__.__CURSOR__++ } ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      pflag = 
        (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 13)  ||
        (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 10)  ||
        (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 34)  ;
      pflag = !pflag ;
      if (pflag) {
        if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
        __SCOPE__.__CURSOR__++ } ;
    };
    pflag = true ;
    if (!pflag) return;
    pflag = 
      (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 34)  ;
    if (pflag) {
      if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
      __SCOPE__.__CURSOR__++ } ;
    if (!pflag) return;
    tflag = false ;
    __SCOPE__.__MATCHES__.push(__SCOPE__.__MATCH__);
    pflag = true ;
    if (!pflag) return;
  } ;
}

function ruleALPHA() {
  pflag = 
    ((inbuf.charCodeAt(__SCOPE__.__CURSOR__) >= 65) &&
     (inbuf.charCodeAt(__SCOPE__.__CURSOR__) <= 90)  ) ||
    ((inbuf.charCodeAt(__SCOPE__.__CURSOR__) >= 97) &&
     (inbuf.charCodeAt(__SCOPE__.__CURSOR__) <= 122)  ) ||
    (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 95)  ;
  if (pflag) {
    if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
    __SCOPE__.__CURSOR__++ } ;
  if (pflag) {
  } ;
}

function ruleDIGIT() {
  pflag = 
    ((inbuf.charCodeAt(__SCOPE__.__CURSOR__) >= 48) &&
     (inbuf.charCodeAt(__SCOPE__.__CURSOR__) <= 57)  ) ;
  if (pflag) {
    if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
    __SCOPE__.__CURSOR__++ } ;
  if (pflag) {
  } ;
}

function ruleSQUOTE() {
  ctxpush("PREFIX") ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    pflag = 
      (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 39)  ;
    if (pflag) {
      if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
      __SCOPE__.__CURSOR__++ } ;
    if (!pflag) return;
  } ;
}

function ruleCMLINE() {
  tflag = true ; 
  __SCOPE__.__MATCH__ = "" ;
  pflag = true ;
  if (pflag) {
    pflag = true ;
    while (pflag) {
      pflag = 
        (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 10)  ||
        (inbuf.charCodeAt(__SCOPE__.__CURSOR__) == 13)  ;
      pflag = !pflag ;
      if (pflag) {
        if (tflag) __SCOPE__.__MATCH__ += inbuf.charAt(__SCOPE__.__CURSOR__) ;
        __SCOPE__.__CURSOR__++ } ;
    };
    pflag = true ;
    if (!pflag) return;
    tflag = false ;
    __SCOPE__.__MATCHES__.push(__SCOPE__.__MATCH__);
    pflag = true ;
    if (!pflag) return;
  } ;
}

