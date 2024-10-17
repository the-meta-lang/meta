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
}//  @author Letsmoe
//  @email moritz.utcke@gmx.de
//  @create date 2024-09-25 16:14:01
//  @modify date 2024-09-25 16:14:01
//  @desc The syntax definition of the META Compiler writing language.
//  - pflag: Indicates if the last parse rule succeeded.
//  - eflag: Indicates if the last parse rule encountered an error.
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

// body of compiler definition 
function rulePROGRAM(){
  pflag = true ;
  while (pflag && !eflag) {
    ctxpush("ENTRY_RULE") ;
    ruleENTRY_RULE();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
    if ((!pflag) && (!eflag)) {
      ctxpush("PARSE_RULE") ;
      rulePARSE_RULE();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
    } ;
    if ((!pflag) && (!eflag)) {
      ctxpush("TOKEN_RULE") ;
      ruleTOKEN_RULE();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
    } ;
    if ((!pflag) && (!eflag)) {
      ctxpush("IGNORE_RULE") ;
      ruleIGNORE_RULE();
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
  if (pflag) {
    while (!eflag) {
      break }
  } ;
}

function ruleENTRY_RULE(){
  test("entry");
  if (pflag) {
    while (!eflag) {
      ctxpush("ID") ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(";");
      if (!pflag) bkerr();
      if (eflag) break ;
      out("func compile(input string) Match {") ;
      eol() ;
      out("var ok bool") ;
      eol() ;
      out("var match Match") ;
      eol() ;
      out("var program []Match") ;
      eol() ;
      out("ctx := Context{") ;
      eol() ;
      out("stdin:  input,") ;
      eol() ;
      out("stdout: os.Stdout,") ;
      eol() ;
      out("stderr: os.Stderr,") ;
      eol() ;
      out("cursor: 0,") ;
      eol() ;
      out("}") ;
      eol() ;
      out("ok, match = _") ;
      out(__SCOPE__.__MATCH__) ;
      out("(&ctx)") ;
      eol() ;
      out("program = append(program, match)") ;
      eol() ;
      out("if !ok {") ;
      eol() ;
      out("error(&ctx, ") ;
      out(String.fromCharCode(34)) ;
      out("Failed to parse program") ;
      out(String.fromCharCode(34)) ;
      out(")") ;
      eol() ;
      out("}") ;
      eol() ;
      out("return match") ;
      eol() ;
      out("}") ;
      eol() ;
      out("func main() {") ;
      eol() ;
      out("buffer := make([]byte, 1024)") ;
      eol() ;
      out("n, _ := os.Open(") ;
      out(String.fromCharCode(34)) ;
      out("input.txt") ;
      out(String.fromCharCode(34)) ;
      out(")") ;
      eol() ;
      out("n.Read(buffer)") ;
      eol() ;
      out("compile(string(buffer))") ;
      eol() ;
      out("}") ;
      eol() ;
      break }
  } ;
}

function ruleIGNORE_RULE(){
  test("ignore");
  if (pflag) {
    while (!eflag) {
      ctxpush("TX1") ;
      ruleTX1();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(";");
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

// parsing rule definition 
// @example PARSE_RULE<argument, argument2>
function rulePARSE_RULE(){
  test("rule");
  if (pflag) {
    while (!eflag) {
      ctxpush("ID") ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("func _") ;
      out(__SCOPE__.__MATCH__) ;
      test("(");
      if (pflag) {
        while (!eflag) {
          out("(ctx *Context,") ;
          ctxpush("PARSE_RULE_ARGUMENT_DEFINITION_LIST") ;
          rulePARSE_RULE_ARGUMENT_DEFINITION_LIST();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          test(")");
          if (!pflag) bkerr();
          if (eflag) break ;
          out(") (bool, Match)") ;
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
            out("(ctx *Context) (bool, Match)") ;
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
      out("var match Match") ;
      eol() ;
      out("var ok bool") ;
      eol() ;
      out("var matches []Match") ;
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
      out("return ok, match") ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out("}") ;
      eol() ;
      eol() ;
      break }
  } ;
}

// token rule definition 
function ruleTOKEN_RULE(){
  test("token");
  if (pflag) {
    while (!eflag) {
      ctxpush("ID") ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("func _") ;
      out(__SCOPE__.__MATCH__) ;
      out("(ctx *Context) (bool, Match) {") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out("var match Match") ;
      eol() ;
      out("var ok bool") ;
      eol() ;
      test("=");
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
      out("return ok, match") ;
      eol() ;
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
            out("if !ok {") ;
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
      out("if ok {") ;
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
        out("if true {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        break }
    } ;
  } ;
  if (pflag) {
    while (!eflag) {
      out("for !ctx.eflag {") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("EX3") ;
        ruleEX3();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out("if !ok {bkerr()}") ;
            eol() ;
            out("if ctx.eflag {break}") ;
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
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out("break }") ;
      stack[stackframe + 2] -= 2 ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out("}") ;
      eol() ;
      break }
  } ;
}

function ruleEX3(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out("ok, match = _") ;
      out(__SCOPE__.__MATCH__) ;
      out("(ctx,") ;
      test("{");
      if (pflag) {
        while (!eflag) {
          ctxpush("PARSE_RULE_ARGUMENT_LIST") ;
          rulePARSE_RULE_ARGUMENT_LIST();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          test("}");
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
      out("matches = append(matches, match)") ;
      eol() ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("STRING") ;
    ruleSTRING();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out("ok, match = test(ctx, ") ;
        out(String.fromCharCode(34)) ;
        out(__SCOPE__.__MATCH__) ;
        out(String.fromCharCode(34)) ;
        out(");") ;
        eol() ;
        out("matches = append(matches, match)") ;
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
        out("ok = true") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".LITCHR");
    if (pflag) {
      while (!eflag) {
        out("match = ctx.stdin.charCodeAt(cursor) ;") ;
        eol() ;
        out("cursor++ ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".PASS");
    if (pflag) {
      while (!eflag) {
        out("ctx.cursor = 0") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("$");
    if (pflag) {
      while (!eflag) {
        out("ok = true") ;
        eol() ;
        out("for ok && !ctx.eflag {") ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        ctxpush("EX3") ;
        ruleEX3();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        stack[stackframe + 2] -= 2 ;
        out("}") ;
        eol() ;
        out("ok = !ctx.eflag ;") ;
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
              out("if (ctx.eflag) bkrestore() ;") ;
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
        out("if (ctx.eflag) bkrestore() ;") ;
        eol() ;
        out("bkclear() ;") ;
        eol() ;
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
      test("{");
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
      test("}");
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleOUT1(){
  test("$");
  if (pflag) {
    while (!eflag) {
      ctxpush("NUMBER") ;
      ruleNUMBER();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          out("fmt.Print(matches[") ;
          out(__SCOPE__.__MATCH__) ;
          out("].Value)") ;
          eol() ;
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            out("fmt.Print(matches[len(matches) - 1].Value)") ;
            eol() ;
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("ID") ;
    ruleID();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out("fmt.Print(") ;
        out(__SCOPE__.__MATCH__) ;
        out(");") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("STRING") ;
    ruleSTRING();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out("fmt.Print(") ;
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
        out("fmt.Print(string(rune(") ;
        out(__SCOPE__.__MATCH__) ;
        out("))) ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".NL");
    if (pflag) {
      while (!eflag) {
        out("fmt.Print('\n') ;") ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test(".TB");
    if (pflag) {
      while (!eflag) {
        out("fmt.Print('\t') ;") ;
        eol() ;
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
        test("|");
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
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("TX3") ;
        ruleTX3();
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

function ruleTX3(){
  test(".TOKEN");
  if (pflag) {
    while (!eflag) {
      out("tflag = true ; ") ;
      eol() ;
      out("match = ") ;
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
        out("match.Value += string(ctx.stdin[ctx.cursor])") ;
        eol() ;
        out("ctx.cursor++ } ;") ;
        stack[stackframe + 2] -= 2 ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test("[");
    if (pflag) {
      while (!eflag) {
        ctxpush("CX1") ;
        ruleCX1();
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
        out("$") ;
        out(__SCOPE__.__MATCH__) ;
        out("() ;") ;
        eol() ;
        out("ctxpop() ;") ;
        eol() ;
        out("if (ctx.eflag) return ;") ;
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
  out("for ") ;
  if (true) {
    while (!eflag) {
      ctxpush("CX2") ;
      ruleCX2();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out(" || ") ;
      pflag = true ;
      while (pflag && !eflag) {
        ctxpush("CX2") ;
        ruleCX2();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(" || ") ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          out("false") ;
          if (true) {
            while (!eflag) {
              break }
          } ;
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out(" {") ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out("ok = true") ;
      eol() ;
      out("match.Value += string(ctx.stdin[ctx.cursor])") ;
      eol() ;
      out("ctx.cursor++") ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out("}") ;
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
      test("-");
      if (pflag) {
        while (!eflag) {
          out("(([]rune(ctx.stdin)[ctx.cursor] >= ") ;
          out(__SCOPE__.__MATCH__) ;
          out(") &&") ;
          ctxpush("CX3") ;
          ruleCX3();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          out(" ([]rune(ctx.stdin)[ctx.cursor] <= ") ;
          out(__SCOPE__.__MATCH__) ;
          out("))") ;
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            out("([]rune(ctx.stdin)[ctx.cursor] == ") ;
            out(__SCOPE__.__MATCH__) ;
            out(")") ;
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleCX3(){
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
}

// [A-Za-z_$]+
// i := 0
// for char >= "A" && char <= "Z" || char >= "a" && char <= "z" || char == "_" || char == "$" {
// 	match.Value += char;
// }
// pflag = len(match.Value) > 0
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

