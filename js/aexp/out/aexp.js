// AEXP compiler
import * as fs from "fs";
export function compile(input) {
  // initialize compiler variables
  inbuf = new ReadBuffer(input);
  stdin = inbuf;
  initialize() ;
  // call the first rule
  ctxpush("AEXP") ;
  ruleAEXP() ;
  ctxpop() ;
  // special case handling of first rule failure
  if ((!eflag) && (!pflag)) {
    eflag = true ;
    erule = "AEXP" ;
    einput = inp ; } ;
  return { outbuf, eflag, inp, inbuf, parsetree };
}

function ruleAEXP(){
  ctxpush("AS") ;
  ruleAS();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      pflag = true ;
      while (pflag & !eflag) {
        ctxpush("AS") ;
        ruleAS();
        ctxpop() ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleAS(){
  let Identifier = new WriteBuffer();
  outbuf = Identifier
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out(token) ;
      break }
  } ;
  if (pflag) {
    while (!eflag) {
      outbuf = stdout;
      if (!pflag) bkerr();
      if (eflag) break ;
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
      combineParseTreeChildren("VariableDeclaration",{id: Identifier.toString(),},1);
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleEX1(){
  ctxpush("EX2") ;
  ruleEX2();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      pflag = true ;
      while (pflag & !eflag) {
        test("+");
        if (pflag) {
          while (!eflag) {
            ctxpush("EX2") ;
            ruleEX2();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            combineParseTreeChildren("BinaryExpression",{operator: "+",},2);
            if (!pflag) bkerr();
            if (eflag) break ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          test("-");
          if (pflag) {
            while (!eflag) {
              ctxpush("EX2") ;
              ruleEX2();
              ctxpop() ;
              if (!pflag) bkerr();
              if (eflag) break ;
              combineParseTreeChildren("BinaryExpression",{operator: "-",},2);
              if (!pflag) bkerr();
              if (eflag) break ;
              break }
          } ;
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
      pflag = true ;
      while (pflag & !eflag) {
        test("*");
        if (pflag) {
          while (!eflag) {
            ctxpush("EX3") ;
            ruleEX3();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            combineParseTreeChildren("BinaryExpression",{operator: "*",},2);
            if (!pflag) bkerr();
            if (eflag) break ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          test("/");
          if (pflag) {
            while (!eflag) {
              ctxpush("EX3") ;
              ruleEX3();
              ctxpop() ;
              if (!pflag) bkerr();
              if (eflag) break ;
              combineParseTreeChildren("BinaryExpression",{operator: "/",},2);
              if (!pflag) bkerr();
              if (eflag) break ;
              break }
          } ;
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleEX3(){
  ctxpush("EX4") ;
  ruleEX4();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      pflag = true ;
      while (pflag & !eflag) {
        test("^");
        if (pflag) {
          while (!eflag) {
            ctxpush("EX3") ;
            ruleEX3();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            combineParseTreeChildren("BinaryExpression",{operator: "^",},2);
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
}

function ruleEX4(){
  test("+");
  if (pflag) {
    while (!eflag) {
      combineParseTreeChildren("UnaryExpression",{operator: "+",},1);
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush("EX5") ;
      ruleEX5();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test("-");
    if (pflag) {
      while (!eflag) {
        ctxpush("EX5") ;
        ruleEX5();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        combineParseTreeChildren("UnaryExpression",{operator: "-",},1);
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("EX5") ;
    ruleEX5();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
}

function ruleEX5(){
  ctxpush("ID") ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      currentparsetree.children.push({type: "Identifier", start: stack[stackframe + 3], end: inp, value: token});
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush("NUMBER") ;
    ruleNUMBER();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        currentparsetree.children.push({type: "Literal", start: stack[stackframe + 3], end: inp, value: token});
        if (!pflag) bkerr();
        if (eflag) break ;
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
}

function rulePREFIX() {
  pflag = true ;
  while (pflag) {
    pflag = 
      (inbuf.charCodeAt(inp) == 32)  ||
      (inbuf.charCodeAt(inp) == 9)  ||
      (inbuf.charCodeAt(inp) == 13)  ||
      (inbuf.charCodeAt(inp) == 10)  ;
    if (pflag) {
      if (tflag) token += inbuf.charAt(inp) ;
      inp++ } ;
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
    token = "" ;
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
    outbuf.captures.push(token);
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
    token = "" ;
    pflag = true ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      pflag = 
        (inbuf.charCodeAt(inp) == 45)  ;
      if (pflag) {
        if (tflag) token += inbuf.charAt(inp) ;
        inp++ } ;
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
    outbuf.captures.push(token);
    pflag = true ;
    if (!pflag) return;
  } ;
}

function ruleALPHA() {
  pflag = 
    ((inbuf.charCodeAt(inp) >= 65) &&
     (inbuf.charCodeAt(inp) <= 90)  ) ||
    ((inbuf.charCodeAt(inp) >= 97) &&
     (inbuf.charCodeAt(inp) <= 122)  ) ||
    (inbuf.charCodeAt(inp) == 95)  ;
  if (pflag) {
    if (tflag) token += inbuf.charAt(inp) ;
    inp++ } ;
  if (pflag) {
  } ;
}

function ruleDIGIT() {
  pflag = 
    ((inbuf.charCodeAt(inp) >= 48) &&
     (inbuf.charCodeAt(inp) <= 57)  ) ;
  if (pflag) {
    if (tflag) token += inbuf.charAt(inp) ;
    inp++ } ;
  if (pflag) {
  } ;
}

class WriteBuffer {
  constructor() {
    this.buffer = '';
    this.captures = [];
  }
  write(s) {
    this.buffer += s;
  }
  writeln(s) {
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
  constructor(value) {
    this.buffer = value;
  }
  charAt(pos) {
    return this.buffer.charAt(pos);
  }
  charCodeAt(pos) {
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
let pflag = false
let tflag = false
let eflag = false
let inp = 0
let inbuf = new ReadBuffer("")
let stdin = inbuf;
let outbuf = new WriteBuffer()
let stdout = outbuf;
let erule =  ""
let einput = 0
let token = ""
let labelcount = 0
let stackframesize = 6
let stackframe = 0
let stos = -1
let parsetree = {type:"", children: []}
let currentparsetree = parsetree
let stack = []

function combineParseTreeChildren(type, obj, count) {
  let children = currentparsetree.children.slice(-count);
  currentparsetree.children = currentparsetree.children.slice(0, -count);
  currentparsetree.children.push({ type, ...obj, start: stack[stackframe + 3], end: inp, children });
}

export function initialize() {
  // initialize for another compile
  pflag = false ;
  tflag = false ;
  eflag = false ;
  inp = 0 ;
  outbuf = new WriteBuffer();
  stdout = outbuf;
  erule = "" ;
  einput = 0 ;
  token = "" ;
  parsetree = {type: "Program", children: []};
  currentparsetree = parsetree;
  labelcount = 1 ;
  stackframe = -1 ;
  stos = -1 ;
  stack = [] ;
}

function ctxpush(rulename) {
  // push and initialize a new stackframe
  var LM ;
  // new context inherits current context left margin
  LM = 0; if (stackframe >= 0) LM = stack[stackframe + 2] ;
  stos++ ;
  stackframe = stos * stackframesize ;
  // stackframe definition
  stack[stackframe + 0] = 0 ;        // generated label
  stack[stackframe + 1] = rulename ; // called rule name
  stack[stackframe + 2] = LM ;       // left margin
  stack[stackframe + 3] = inp ;       // left margin
  // clear additional stackframe backtracking entries
  bkclear() ;
}

function ctxpop(){
  // pop and possibly deallocate old stackframe
  stos-- ; // pop stackframe
  stackframe = stos * stackframesize ;
}

function out(s){
  // output string
  var i ;
  // if newline last output, add left margin before string
  if (outbuf.buffer.charAt(outbuf.length - 1) == "\n") {
    i = stack[stackframe + 2] ;
    while (i>0) { outbuf.write(" "); i-- } ; } ;
  outbuf.write(s);
}

function eol(){
  // output end of line
  outbuf.write("\n");
}

function test(s) {
  // test for a string in the input
  var i ;
  // delete whitespace
  while ((inbuf.charAt(inp) == " ")  ||
         (inbuf.charAt(inp) == "\n") ||
         (inbuf.charAt(inp) == "\r") ||
         (inbuf.charAt(inp) == "\t") ) inp++ ;
  // test string case insensitive
  pflag = true ; i = 0 ;
  while (pflag && (i < s.length) && ((inp+i) < inbuf.length) )
  { pflag = (s.charAt(i).toUpperCase() ==
                  inbuf.charAt(inp+i).toUpperCase()) ;
    i++ ; } ;
  pflag = pflag && (i == s.length) ;
  // advance input if found
  if (pflag) inp = inp + s.length ;
}

function bkerr() {
  // compilation error, provide error indication and context
  eflag = true ;
  erule = stack[stackframe + 1] ;
  einput = inp ;
}

function bkset() {
  // set backtrack context on stack
  stack[stackframe + 4] = inp ;           // input position
  stack[stackframe + 5] = outbuf.length ; // output position
  stack[stackframe + 6] = token ;         // current token
}

function bkclear() {
  // clear backtrack context on stack
  stack[stackframe + 4] = -1 ; // input position
  stack[stackframe + 5] = -1 ; // output position
  stack[stackframe + 6] = "" ; // current token
}

function bkrestore() {
  // restore context for backtracking
  eflag = false ;
  inp = stack[stackframe + 4] ;           // input position
  outbuf.buffer = outbuf.buffer.substring(0,stack[stackframe + 5]) ; // output position
  token = stack[stackframe + 6] ;         // current token
  outbuf.captures.push(token);
}

