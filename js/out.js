// PROGRAM compiler
export function compile(input) {
  // initialize compiler variables
  inbuf = input ;
  initialize() ;
  // call the first rule
  ctxpush('PROGRAM') ;
  rulePROGRAM() ;
  parsetree.name = 'PROGRAM';
  ctxpop() ;
  // special case handling of first rule failure
  if ((!eflag) && (!pflag)) {
    eflag = true ;
    erule = 'PROGRAM' ;
    einput = inp ; } ;
  return { outbuf, eflag, inp, inbuf };
}

// body of compiler definition 
function rulePROGRAM(){
  test('.SYNTAX');
  if (pflag) {
    while (!eflag) {
      ctxpush('ID') ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out('// ') ;
      out(token) ;
      out(' compiler') ;
      eol() ;
      ctxpush('PREAMBLE') ;
      rulePREAMBLE();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag & !eflag) {
        ctxpush('PR') ;
        rulePR();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush('COMMENT') ;
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
      test('.CODE');
      if (pflag) {
        while (!eflag) {
          pflag = true ;
          while (pflag & !eflag) {
            ctxpush('CODE_RULE') ;
            ruleCODE_RULE();
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                break }
            } ;
            if ((!pflag) && (!eflag)) {
              ctxpush('COMMENT') ;
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
      test('.TOKENS');
      if (pflag) {
        while (!eflag) {
          pflag = true ;
          while (pflag & !eflag) {
            ctxpush('TR') ;
            ruleTR();
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                break }
            } ;
            if ((!pflag) && (!eflag)) {
              ctxpush('COMMENT') ;
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
      test('.END');
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush('POSTAMBLE') ;
      rulePOSTAMBLE();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

// object definition preamble 
function rulePREAMBLE(){
  out('export function compile(input) {') ;
  stack[stackframe + 2] += 2 ;
  eol() ;
  if (true) {
    while (!eflag) {
      out('// initialize compiler variables') ;
      eol() ;
      out('inbuf = input ;') ;
      eol() ;
      out('initialize() ;') ;
      eol() ;
      out('// call the first rule') ;
      eol() ;
      out('ctxpush(') ;
      out(String.fromCharCode(39)) ;
      out(token) ;
      out(String.fromCharCode(39)) ;
      out(') ;') ;
      eol() ;
      out('rule') ;
      out(token) ;
      out('() ;') ;
      eol() ;
      out('parsetree.name = ') ;
      out(String.fromCharCode(39)) ;
      out(token) ;
      out(String.fromCharCode(39)) ;
      out(';') ;
      eol() ;
      out('ctxpop() ;') ;
      eol() ;
      out('// special case handling of first rule failure') ;
      eol() ;
      out('if ((!eflag) && (!pflag)) {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('eflag = true ;') ;
      eol() ;
      out('erule = ') ;
      out(String.fromCharCode(39)) ;
      out(token) ;
      out(String.fromCharCode(39)) ;
      out(' ;') ;
      eol() ;
      out('einput = inp ; } ;') ;
      stack[stackframe + 2] -= 2 ;
      eol() ;
      out('return { outbuf, eflag, inp, inbuf };') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      break }
  } ;
}

// runtime and object definition postamble  
function rulePOSTAMBLE(){
  out('// runtime variables') ;
  eol() ;
  if (true) {
    while (!eflag) {
      out('let pflag = false') ;
      eol() ;
      out('let tflag = false') ;
      eol() ;
      out('let eflag = false') ;
      eol() ;
      out('let inp = 0') ;
      eol() ;
      out('let inbuf =  ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out('') ;
      eol() ;
      out('let outbuf =  ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out('') ;
      eol() ;
      out('let erule =  ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out('') ;
      eol() ;
      out('let einput = 0') ;
      eol() ;
      out('let token = ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out('') ;
      eol() ;
      out('let labelcount = 0') ;
      eol() ;
      out('let stackframesize = 6') ;
      eol() ;
      out('let stackframe = 0') ;
      eol() ;
      out('let stos = -1') ;
      eol() ;
      out('export const parsetree = {name:') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out(', children: []}') ;
      eol() ;
      out('let currentparsetree = parsetree') ;
      eol() ;
      out('let stack = []') ;
      eol() ;
      eol() ;
      out('export function initialize() {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// initialize for another compile') ;
      eol() ;
      out('pflag = false ;') ;
      eol() ;
      out('tflag = false ;') ;
      eol() ;
      out('eflag = false ;') ;
      eol() ;
      out('inp = 0 ;') ;
      eol() ;
      out('outbuf = ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out(' ;') ;
      eol() ;
      out('erule = ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out(' ;') ;
      eol() ;
      out('einput = 0 ;') ;
      eol() ;
      out('token = ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out(' ;') ;
      eol() ;
      out('labelcount = 1 ;') ;
      eol() ;
      out('stackframe = -1 ;') ;
      eol() ;
      out('stos = -1 ;') ;
      eol() ;
      out('stack = [] ;') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      out('function ctxpush(rulename) {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// push and initialize a new stackframe') ;
      eol() ;
      out('var LM ;') ;
      eol() ;
      out('// new context inherits current context left margin') ;
      eol() ;
      out('LM = 0; if (stackframe >= 0) LM = stack[stackframe + 2] ;') ;
      eol() ;
      out('stos++ ;') ;
      eol() ;
      out('stackframe = stos * stackframesize ;') ;
      eol() ;
      out('// stackframe definition') ;
      eol() ;
      out('stack[stackframe + 0] = 0 ;        // generated label') ;
      eol() ;
      out('stack[stackframe + 1] = rulename ; // called rule name') ;
      eol() ;
      out('stack[stackframe + 2] = LM ;       // left margin') ;
      eol() ;
      out('// clear additional stackframe backtracking entries') ;
      eol() ;
      out('bkclear() ;') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      out('function ctxpop(){') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// pop and possibly deallocate old stackframe') ;
      eol() ;
      out('stos-- ; // pop stackframe') ;
      eol() ;
      out('stackframe = stos * stackframesize ;') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      out('function out(s){') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// output string') ;
      eol() ;
      out('var i ;') ;
      eol() ;
      out('// if newline last output, add left margin before string') ;
      eol() ;
      out('if (outbuf.charAt(outbuf.length - 1) == ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(92)) ;
      out('n') ;
      out(String.fromCharCode(39)) ;
      out(') {') ;
      eol() ;
      out('  i = stack[stackframe + 2] ;') ;
      eol() ;
      out('  while (i>0) { outbuf += ') ;
      out(String.fromCharCode(39)) ;
      out(' ') ;
      out(String.fromCharCode(39)) ;
      out(' ; i-- } ; } ;') ;
      eol() ;
      out('outbuf += s ;') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      out('function eol(){') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// output end of line') ;
      eol() ;
      out('outbuf += ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(92)) ;
      out('n') ;
      out(String.fromCharCode(39)) ;
      out(' ;') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      out('function test(s) {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// test for a string in the input') ;
      eol() ;
      out('var i ;') ;
      eol() ;
      out('// delete whitespace') ;
      eol() ;
      out('while ((inbuf.charAt(inp) == ') ;
      out(String.fromCharCode(39)) ;
      out(' ') ;
      out(String.fromCharCode(39)) ;
      out(')  ||') ;
      eol() ;
      out('       (inbuf.charAt(inp) == ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(92)) ;
      out('n') ;
      out(String.fromCharCode(39)) ;
      out(') ||') ;
      eol() ;
      out('       (inbuf.charAt(inp) == ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(92)) ;
      out('r') ;
      out(String.fromCharCode(39)) ;
      out(') ||') ;
      eol() ;
      out('       (inbuf.charAt(inp) == ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(92)) ;
      out('t') ;
      out(String.fromCharCode(39)) ;
      out(') ) inp++ ;') ;
      eol() ;
      out('// test string case insensitive') ;
      eol() ;
      out('pflag = true ; i = 0 ;') ;
      eol() ;
      out('while (pflag && (i < s.length) && ((inp+i) < inbuf.length) )') ;
      eol() ;
      out('{ pflag = (s.charAt(i).toUpperCase() ==') ;
      eol() ;
      out('                inbuf.charAt(inp+i).toUpperCase()) ;') ;
      eol() ;
      out('  i++ ; } ;') ;
      eol() ;
      out('pflag = pflag && (i == s.length) ;') ;
      eol() ;
      out('// advance input if found') ;
      eol() ;
      out('if (pflag) inp = inp + s.length ;') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      out('function bkerr() {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// compilation error, provide error indication and context') ;
      eol() ;
      out('eflag = true ;') ;
      eol() ;
      out('erule = stack[stackframe + 1] ;') ;
      eol() ;
      out('einput = inp ;') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      out('function bkset() {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// set backtrack context on stack') ;
      eol() ;
      out('stack[stackframe + 3] = inp ;           // input position') ;
      eol() ;
      out('stack[stackframe + 4] = outbuf.length ; // output position') ;
      eol() ;
      out('stack[stackframe + 5] = token ;         // current token') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      out('function bkclear() {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// clear backtrack context on stack') ;
      eol() ;
      out('stack[stackframe + 3] = -1 ; // input position') ;
      eol() ;
      out('stack[stackframe + 4] = -1 ; // output position') ;
      eol() ;
      out('stack[stackframe + 5] = ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out(' ; // current token') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      out('function bkrestore() {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      out('// restore context for backtracking') ;
      eol() ;
      out('eflag = false ;') ;
      eol() ;
      out('inp = stack[stackframe + 3] ;           // input position') ;
      eol() ;
      out('outbuf = outbuf.substring(0,stack[stackframe + 4]) ; // output position') ;
      eol() ;
      out('token = stack[stackframe + 5] ;         // current token') ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      break }
  } ;
}

// parsing rule definition 
// @example PARSE_RULE<argument, argument2>
function rulePR(){
  ctxpush('ID') ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out('function rule') ;
      out(token) ;
      test('<');
      if (pflag) {
        while (!eflag) {
          ctxpush('ID') ;
          ruleID();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          out('(') ;
          out(token) ;
          pflag = true ;
          while (pflag & !eflag) {
            ctxpush('ID') ;
            ruleID();
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                out(', ') ;
                out(token) ;
                break }
            } ;
          } ;
          pflag = !eflag ;
          if (!pflag) bkerr();
          if (eflag) break ;
          test('>');
          if (!pflag) bkerr();
          if (eflag) break ;
          out(')') ;
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
            out('()') ;
            break }
        } ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out('{') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      test('=');
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush('EX1') ;
      ruleEX1();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(';');
      if (!pflag) bkerr();
      if (eflag) break ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      break }
  } ;
}

// token rule definition 
function ruleTR(){
  ctxpush('ID') ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out('function rule') ;
      out(token) ;
      out('() {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      test(':');
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush('TX1') ;
      ruleTX1();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(';');
      if (!pflag) bkerr();
      if (eflag) break ;
      stack[stackframe + 2] -= 2 ;
      out('}') ;
      eol() ;
      eol() ;
      break }
  } ;
}

// comment definition 
function ruleCOMMENT(){
  test('//');
  if (pflag) {
    while (!eflag) {
      ctxpush('CMLINE') ;
      ruleCMLINE();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out('//') ;
      out(token) ;
      eol() ;
      break }
  } ;
}

// -------------------------- Parse Tree Operators -----------------------------
function ruleCAPTURE_SINGLE_NODE(){
  test('::');
  if (pflag) {
    while (!eflag) {
      ctxpush('ID') ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out('currentparsetree.children.push({ name: ') ;
      out(String.fromCharCode(39)) ;
      out(token) ;
      out(String.fromCharCode(39)) ;
      out(', loc: inp, value: token});') ;
      eol() ;
      break }
  } ;
}

// -------------------------- META Lisp Definitions ----------------------------
function ruleCODE_RULE(){
  ctxpush('LISP') ;
  ruleLISP();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
}

function ruleLISPARG(){
  bkset() ;
  ctxpush('LISP_OBJECT_ACCESSOR') ;
  ruleLISP_OBJECT_ACCESSOR();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  if (!pflag) {
    if (eflag) bkrestore() ;
    ctxpush('ID') ;
    ruleID();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
    if ((!pflag) && (!eflag)) {
      ctxpush('NUMBER') ;
      ruleNUMBER();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
    } ;
    if ((!pflag) && (!eflag)) {
      ctxpush('RAWSTRING') ;
      ruleRAWSTRING();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
    } ;
    if (pflag) {
      while (!eflag) {
        out(token) ;
        break }
    } ;
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

function ruleLISP_OBJECT_ACCESSOR(){
  ctxpush('ID') ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out(token) ;
      out('.') ;
      test('::');
      if (!pflag) bkerr();
      if (eflag) break ;
      ctxpush('ID') ;
      ruleID();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out(token) ;
      break }
  } ;
}

function ruleLISP_LANGUAGE_CONSTRUCTS(){
  test('while');
  if (pflag) {
    while (!eflag) {
      ctxpush('LISPARG') ;
      ruleLISPARG();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      out('while (') ;
      out(token) ;
      out(') {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      ctxpush('LISPARG') ;
      ruleLISPARG();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      stack[stackframe + 2] -= 2 ;
      out('} ;') ;
      eol() ;
      break }
  } ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test('if');
    if (pflag) {
      while (!eflag) {
        out('if (') ;
        ctxpush('LISP') ;
        ruleLISP();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush('LISPARG') ;
          ruleLISPARG();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              out(token) ;
              break }
          } ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
        } ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(') {') ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        ctxpush('LISP') ;
        ruleLISP();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        stack[stackframe + 2] -= 2 ;
        out('} ;') ;
        eol() ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('set');
    if (pflag) {
      while (!eflag) {
        ctxpush('ID') ;
        ruleID();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(token) ;
        out(' = ') ;
        ctxpush('LISPARG') ;
        ruleLISPARG();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(token) ;
        out(';') ;
        eol() ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('defunc');
    if (pflag) {
      while (!eflag) {
        ctxpush('ID') ;
        ruleID();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out('function ') ;
        out(token) ;
        out('(') ;
        test('[');
        if (!pflag) bkerr();
        if (eflag) break ;
        ctxpush('ID') ;
        ruleID();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(token) ;
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
        while (pflag & !eflag) {
          ctxpush('ID') ;
          ruleID();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              out(', ') ;
              out(token) ;
              break }
          } ;
        } ;
        pflag = !eflag ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(']');
        if (!pflag) bkerr();
        if (eflag) break ;
        out(') {') ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        pflag = true ;
        while (pflag & !eflag) {
          ctxpush('LISP') ;
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
        out('}') ;
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
    test('define');
    if (pflag) {
      while (!eflag) {
        ctxpush('ID') ;
        ruleID();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out('let ') ;
        out(token) ;
        out(' = ') ;
        ctxpush('LISPARG') ;
        ruleLISPARG();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out(token) ;
        out(';') ;
        eol() ;
        break }
    } ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("+");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("-");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("*");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("/");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD(">");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("<");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("==");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("!=");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("<=");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD(">=");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("&&");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_OPERATOR_METHOD') ;
    ruleLISP_OPERATOR_METHOD("||");
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP_FUNCTION_CALL') ;
    ruleLISP_FUNCTION_CALL();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
}

function ruleLISP_FUNCTION_CALL(){
  ctxpush('ID') ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out(token) ;
      out('(') ;
      ctxpush('LISPARG') ;
      ruleLISPARG();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          out(token) ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        ctxpush('LISP') ;
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
      while (pflag & !eflag) {
        ctxpush('LISPARG') ;
        ruleLISPARG();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(', ') ;
            out(token) ;
            break }
        } ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush('LISP') ;
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
      out(');') ;
      eol() ;
      break }
  } ;
}

function ruleLISP_OPERATOR_METHOD(operator){
  test(operator);
  if (pflag) {
    while (!eflag) {
      ctxpush('LISPARG') ;
      ruleLISPARG();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          out(token) ;
          break }
      } ;
      if (pflag) {
        while (!eflag) {
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        ctxpush('LISP') ;
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
      while (pflag & !eflag) {
        ctxpush('LISPARG') ;
        ruleLISPARG();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out(operator);
            out(token) ;
            break }
        } ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush('LISP') ;
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
      break }
  } ;
}

function ruleLISP(){
  test('[');
  if (pflag) {
    while (!eflag) {
      ctxpush('LISP_LANGUAGE_CONSTRUCTS') ;
      ruleLISP_LANGUAGE_CONSTRUCTS();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(']');
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test('[');
    if (pflag) {
      while (!eflag) {
        ctxpush('LISP') ;
        ruleLISP();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(']');
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('COMMENT') ;
    ruleCOMMENT();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
}

// --------------------------- Parsing expressions -----------------------------
function ruleEX1(){
  ctxpush('EX2') ;
  ruleEX2();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      pflag = true ;
      while (pflag & !eflag) {
        ctxpush('CAPTURE_SINGLE_NODE') ;
        ruleCAPTURE_SINGLE_NODE();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag & !eflag) {
        test('|');
        if (pflag) {
          while (!eflag) {
            out('if ((!pflag) && (!eflag)) {') ;
            stack[stackframe + 2] += 2 ;
            eol() ;
            ctxpush('EX2') ;
            ruleEX2();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            pflag = true ;
            while (pflag & !eflag) {
              ctxpush('CAPTURE_SINGLE_NODE') ;
              ruleCAPTURE_SINGLE_NODE();
              ctxpop() ;
              if (pflag) {
                while (!eflag) {
                  break }
              } ;
            } ;
            pflag = !eflag ;
            if (!pflag) bkerr();
            if (eflag) break ;
            stack[stackframe + 2] -= 2 ;
            out('} ;') ;
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
  ctxpush('EX3') ;
  ruleEX3();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out('if (pflag) {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('OUTPUT') ;
    ruleOUTPUT();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out('if (true) {') ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        break }
    } ;
  } ;
  if (pflag) {
    while (!eflag) {
      out('while (!eflag) {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      pflag = true ;
      while (pflag & !eflag) {
        ctxpush('EX3') ;
        ruleEX3();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out('if (!pflag) bkerr();') ;
            eol() ;
            out('if (eflag) break ;') ;
            eol() ;
            break }
        } ;
        if ((!pflag) && (!eflag)) {
          ctxpush('OUTPUT') ;
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
      out('break }') ;
      stack[stackframe + 2] -= 2 ;
      eol() ;
      stack[stackframe + 2] -= 2 ;
      out('} ;') ;
      eol() ;
      break }
  } ;
}

function ruleEX3(){
  ctxpush('ID') ;
  ruleID();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out('ctxpush(') ;
      out(String.fromCharCode(39)) ;
      out(token) ;
      out(String.fromCharCode(39)) ;
      out(') ;') ;
      eol() ;
      out('rule') ;
      out(token) ;
      out('(') ;
      test('<');
      if (pflag) {
        while (!eflag) {
          ctxpush('ID') ;
          ruleID();
          ctxpop() ;
          if (pflag) {
            while (!eflag) {
              break }
          } ;
          if ((!pflag) && (!eflag)) {
            ctxpush('RAWSTRING') ;
            ruleRAWSTRING();
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                break }
            } ;
          } ;
          if ((!pflag) && (!eflag)) {
            ctxpush('NUMBER') ;
            ruleNUMBER();
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                break }
            } ;
          } ;
          if (!pflag) bkerr();
          if (eflag) break ;
          out(token) ;
          pflag = true ;
          while (pflag & !eflag) {
            ctxpush('ID') ;
            ruleID();
            ctxpop() ;
            if (pflag) {
              while (!eflag) {
                break }
            } ;
            if ((!pflag) && (!eflag)) {
              ctxpush('RAWSTRING') ;
              ruleRAWSTRING();
              ctxpop() ;
              if (pflag) {
                while (!eflag) {
                  break }
              } ;
            } ;
            if ((!pflag) && (!eflag)) {
              ctxpush('NUMBER') ;
              ruleNUMBER();
              ctxpop() ;
              if (pflag) {
                while (!eflag) {
                  break }
              } ;
            } ;
            if (pflag) {
              while (!eflag) {
                out(', ') ;
                out(token) ;
                break }
            } ;
          } ;
          pflag = !eflag ;
          if (!pflag) bkerr();
          if (eflag) break ;
          test('>');
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
      out(');') ;
      eol() ;
      out('ctxpop() ;') ;
      eol() ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('STRING') ;
    ruleSTRING();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out('test(') ;
        out(String.fromCharCode(39)) ;
        out(token) ;
        out(String.fromCharCode(39)) ;
        out(');') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('(');
    if (pflag) {
      while (!eflag) {
        ctxpush('EX1') ;
        ruleEX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(')');
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('.EMPTY');
    if (pflag) {
      while (!eflag) {
        out('pflag = true ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('.LITCHR');
    if (pflag) {
      while (!eflag) {
        out('token = inbuf.charCodeAt(inp) ;') ;
        eol() ;
        out('inp++ ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('.PASS');
    if (pflag) {
      while (!eflag) {
        out('inp = 0 ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('$');
    if (pflag) {
      while (!eflag) {
        out('pflag = true ;') ;
        eol() ;
        out('while (pflag & !eflag) {') ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        ctxpush('EX3') ;
        ruleEX3();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        stack[stackframe + 2] -= 2 ;
        out('} ;') ;
        eol() ;
        out('pflag = !eflag ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('{');
    if (pflag) {
      while (!eflag) {
        out('bkset() ;') ;
        eol() ;
        ctxpush('EX1') ;
        ruleEX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        pflag = true ;
        while (pflag & !eflag) {
          test('/');
          if (pflag) {
            while (!eflag) {
              out('if (!pflag) {') ;
              stack[stackframe + 2] += 2 ;
              eol() ;
              out('if (eflag) bkrestore() ;') ;
              eol() ;
              ctxpush('EX1') ;
              ruleEX1();
              ctxpop() ;
              if (!pflag) bkerr();
              if (eflag) break ;
              stack[stackframe + 2] -= 2 ;
              out('} ;') ;
              eol() ;
              break }
          } ;
        } ;
        pflag = !eflag ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test('}');
        if (!pflag) bkerr();
        if (eflag) break ;
        out('if (eflag) bkrestore() ;') ;
        eol() ;
        out('bkclear() ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('*');
    if (pflag) {
      while (!eflag) {
        ctxpush('ID') ;
        ruleID();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        out('test(') ;
        out(token) ;
        out(');') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('LISP') ;
    ruleLISP();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
}

// output expressions 
function ruleOUTPUT(){
  test('->');
  if (pflag) {
    while (!eflag) {
      test('(');
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag & !eflag) {
        ctxpush('OUT1') ;
        ruleOUT1();
        ctxpop() ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      test(')');
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleOUT1(){
  test('*');
  if (pflag) {
    while (!eflag) {
      ctxpush('ID') ;
      ruleID();
      ctxpop() ;
      if (pflag) {
        while (!eflag) {
          out('out(') ;
          out(token) ;
          out(');') ;
          eol() ;
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            out('out(token) ;') ;
            eol() ;
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('STRING') ;
    ruleSTRING();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out('out(') ;
        out(String.fromCharCode(39)) ;
        out(token) ;
        out(String.fromCharCode(39)) ;
        out(') ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('NUMBER') ;
    ruleNUMBER();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out('out(String.fromCharCode(') ;
        out(token) ;
        out(')) ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('#');
    if (pflag) {
      while (!eflag) {
        out('if (stack[stackframe + 0] == 0) {') ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        out('stack[stackframe + 0] = labelcount ;') ;
        eol() ;
        out('labelcount++ ; } ;') ;
        stack[stackframe + 2] -= 2 ;
        eol() ;
        out('out(stack[stackframe + 0]) ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('.NL');
    if (pflag) {
      while (!eflag) {
        out('eol() ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('.LB');
    if (pflag) {
      while (!eflag) {
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('.TB');
    if (pflag) {
      while (!eflag) {
        out('out(') ;
        out(String.fromCharCode(39)) ;
        out(String.fromCharCode(92)) ;
        out('t') ;
        out(String.fromCharCode(39)) ;
        out(') ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('.LM+');
    if (pflag) {
      while (!eflag) {
        out('stack[stackframe + 2] += 2 ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('.LM-');
    if (pflag) {
      while (!eflag) {
        out('stack[stackframe + 2] -= 2 ;') ;
        eol() ;
        break }
    } ;
  } ;
}

// token expressions 
function ruleTX1(){
  ctxpush('TX2') ;
  ruleTX2();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      pflag = true ;
      while (pflag & !eflag) {
        test('/');
        if (pflag) {
          while (!eflag) {
            out('if (!pflag) {') ;
            stack[stackframe + 2] += 2 ;
            eol() ;
            ctxpush('TX2') ;
            ruleTX2();
            ctxpop() ;
            if (!pflag) bkerr();
            if (eflag) break ;
            stack[stackframe + 2] -= 2 ;
            out('} ;') ;
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
  ctxpush('TX3') ;
  ruleTX3();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      out('if (pflag) {') ;
      stack[stackframe + 2] += 2 ;
      eol() ;
      pflag = true ;
      while (pflag & !eflag) {
        ctxpush('TX3') ;
        ruleTX3();
        ctxpop() ;
        if (pflag) {
          while (!eflag) {
            out('if (!pflag) return;') ;
            eol() ;
            break }
        } ;
      } ;
      pflag = !eflag ;
      if (!pflag) bkerr();
      if (eflag) break ;
      stack[stackframe + 2] -= 2 ;
      out('} ;') ;
      eol() ;
      break }
  } ;
}

function ruleTX3(){
  test('.TOKEN');
  if (pflag) {
    while (!eflag) {
      out('tflag = true ; ') ;
      eol() ;
      out('token = ') ;
      out(String.fromCharCode(39)) ;
      out(String.fromCharCode(39)) ;
      out(' ;') ;
      eol() ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test('.DELTOK');
    if (pflag) {
      while (!eflag) {
        out('tflag = false ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('$');
    if (pflag) {
      while (!eflag) {
        out('pflag = true ;') ;
        eol() ;
        out('while (pflag) {') ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        ctxpush('TX3') ;
        ruleTX3();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        stack[stackframe + 2] -= 2 ;
        out('};') ;
        eol() ;
        break }
    } ;
  } ;
  if (pflag) {
    while (!eflag) {
      out('pflag = true ;') ;
      eol() ;
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    test('.ANYBUT(');
    if (pflag) {
      while (!eflag) {
        ctxpush('CX1') ;
        ruleCX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(')');
        if (!pflag) bkerr();
        if (eflag) break ;
        out('pflag = !pflag ;') ;
        eol() ;
        out('if (pflag) {') ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        out('if (tflag) token += inbuf.charAt(inp) ;') ;
        eol() ;
        out('inp++ } ;') ;
        stack[stackframe + 2] -= 2 ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('.ANY(');
    if (pflag) {
      while (!eflag) {
        ctxpush('CX1') ;
        ruleCX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(')');
        if (!pflag) bkerr();
        if (eflag) break ;
        out('if (pflag) {') ;
        stack[stackframe + 2] += 2 ;
        eol() ;
        out('if (tflag) token += inbuf.charAt(inp) ;') ;
        eol() ;
        out('inp++ } ;') ;
        stack[stackframe + 2] -= 2 ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('ID') ;
    ruleID();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        out('ctxpush(') ;
        out(String.fromCharCode(39)) ;
        out(token) ;
        out(String.fromCharCode(39)) ;
        out(') ;') ;
        eol() ;
        out('rule') ;
        out(token) ;
        out('() ;') ;
        eol() ;
        out('ctxpop() ;') ;
        eol() ;
        out('if (eflag) return ;') ;
        eol() ;
        break }
    } ;
  } ;
  if ((!pflag) && (!eflag)) {
    test('(');
    if (pflag) {
      while (!eflag) {
        ctxpush('TX1') ;
        ruleTX1();
        ctxpop() ;
        if (!pflag) bkerr();
        if (eflag) break ;
        test(')');
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
}

// character expressions             
function ruleCX1(){
  out('pflag = ') ;
  stack[stackframe + 2] += 2 ;
  eol() ;
  if (true) {
    while (!eflag) {
      ctxpush('CX2') ;
      ruleCX2();
      ctxpop() ;
      if (!pflag) bkerr();
      if (eflag) break ;
      pflag = true ;
      while (pflag & !eflag) {
        test('!');
        if (pflag) {
          while (!eflag) {
            out(' ||') ;
            eol() ;
            ctxpush('CX2') ;
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
      out(' ;') ;
      eol() ;
      break }
  } ;
}

function ruleCX2(){
  ctxpush('CX3') ;
  ruleCX3();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      test(':');
      if (pflag) {
        while (!eflag) {
          out('((inbuf.charCodeAt(inp) >= ') ;
          out(token) ;
          out(') &&') ;
          eol() ;
          ctxpush('CX3') ;
          ruleCX3();
          ctxpop() ;
          if (!pflag) bkerr();
          if (eflag) break ;
          out(' (inbuf.charCodeAt(inp) <= ') ;
          out(token) ;
          out(')  )') ;
          break }
      } ;
      if ((!pflag) && (!eflag)) {
        pflag = true ;
        if (pflag) {
          while (!eflag) {
            out('(inbuf.charCodeAt(inp) == ') ;
            out(token) ;
            out(') ') ;
            break }
        } ;
      } ;
      if (!pflag) bkerr();
      if (eflag) break ;
      break }
  } ;
}

function ruleCX3(){
  ctxpush('NUMBER') ;
  ruleNUMBER();
  ctxpop() ;
  if (pflag) {
    while (!eflag) {
      break }
  } ;
  if ((!pflag) && (!eflag)) {
    ctxpush('SQUOTE') ;
    ruleSQUOTE();
    ctxpop() ;
    if (pflag) {
      while (!eflag) {
        token = inbuf.charCodeAt(inp) ;
        inp++ ;
        if (!pflag) bkerr();
        if (eflag) break ;
        break }
    } ;
  } ;
}

let x = console.loglog;
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
  ctxpush('PREFIX') ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    tflag = true ; 
    token = '' ;
    pflag = true ;
    if (!pflag) return;
    ctxpush('ALPHA') ;
    ruleALPHA() ;
    ctxpop() ;
    if (eflag) return ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      ctxpush('ALPHA') ;
      ruleALPHA() ;
      ctxpop() ;
      if (eflag) return ;
      if (pflag) {
      } ;
      if (!pflag) {
        ctxpush('DIGIT') ;
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
    pflag = true ;
    if (!pflag) return;
  } ;
}

function ruleNUMBER() {
  ctxpush('PREFIX') ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    tflag = true ; 
    token = '' ;
    pflag = true ;
    if (!pflag) return;
    ctxpush('DIGIT') ;
    ruleDIGIT() ;
    ctxpop() ;
    if (eflag) return ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      ctxpush('DIGIT') ;
      ruleDIGIT() ;
      ctxpop() ;
      if (eflag) return ;
    };
    pflag = true ;
    if (!pflag) return;
    tflag = false ;
    pflag = true ;
    if (!pflag) return;
  } ;
}

function ruleSTRING() {
  ctxpush('PREFIX') ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    pflag = 
      (inbuf.charCodeAt(inp) == 34)  ;
    if (pflag) {
      if (tflag) token += inbuf.charAt(inp) ;
      inp++ } ;
    if (!pflag) return;
    tflag = true ; 
    token = '' ;
    pflag = true ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      pflag = 
        (inbuf.charCodeAt(inp) == 13)  ||
        (inbuf.charCodeAt(inp) == 10)  ||
        (inbuf.charCodeAt(inp) == 34)  ;
      pflag = !pflag ;
      if (pflag) {
        if (tflag) token += inbuf.charAt(inp) ;
        inp++ } ;
    };
    pflag = true ;
    if (!pflag) return;
    tflag = false ;
    pflag = true ;
    if (!pflag) return;
    pflag = 
      (inbuf.charCodeAt(inp) == 34)  ;
    if (pflag) {
      if (tflag) token += inbuf.charAt(inp) ;
      inp++ } ;
    if (!pflag) return;
  } ;
}

function ruleRAWSTRING() {
  ctxpush('PREFIX') ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    tflag = true ; 
    token = '' ;
    pflag = true ;
    if (!pflag) return;
    pflag = 
      (inbuf.charCodeAt(inp) == 34)  ;
    if (pflag) {
      if (tflag) token += inbuf.charAt(inp) ;
      inp++ } ;
    if (!pflag) return;
    pflag = true ;
    while (pflag) {
      pflag = 
        (inbuf.charCodeAt(inp) == 13)  ||
        (inbuf.charCodeAt(inp) == 10)  ||
        (inbuf.charCodeAt(inp) == 34)  ;
      pflag = !pflag ;
      if (pflag) {
        if (tflag) token += inbuf.charAt(inp) ;
        inp++ } ;
    };
    pflag = true ;
    if (!pflag) return;
    pflag = 
      (inbuf.charCodeAt(inp) == 34)  ;
    if (pflag) {
      if (tflag) token += inbuf.charAt(inp) ;
      inp++ } ;
    if (!pflag) return;
    tflag = false ;
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

function ruleSQUOTE() {
  ctxpush('PREFIX') ;
  rulePREFIX() ;
  ctxpop() ;
  if (eflag) return ;
  if (pflag) {
    pflag = 
      (inbuf.charCodeAt(inp) == 39)  ;
    if (pflag) {
      if (tflag) token += inbuf.charAt(inp) ;
      inp++ } ;
    if (!pflag) return;
  } ;
}

function ruleCMLINE() {
  tflag = true ; 
  token = '' ;
  pflag = true ;
  if (pflag) {
    pflag = true ;
    while (pflag) {
      pflag = 
        (inbuf.charCodeAt(inp) == 10)  ||
        (inbuf.charCodeAt(inp) == 13)  ;
      pflag = !pflag ;
      if (pflag) {
        if (tflag) token += inbuf.charAt(inp) ;
        inp++ } ;
    };
    pflag = true ;
    if (!pflag) return;
    tflag = false ;
    pflag = true ;
    if (!pflag) return;
  } ;
}

// runtime variables
let pflag = false
let tflag = false
let eflag = false
let inp = 0
let inbuf =  ''
let outbuf =  ''
let erule =  ''
let einput = 0
let token = ''
let labelcount = 0
let stackframesize = 6
let stackframe = 0
let stos = -1
export const parsetree = {name:'', children: []}
let currentparsetree = parsetree
let stack = []

export function initialize() {
  // initialize for another compile
  pflag = false ;
  tflag = false ;
  eflag = false ;
  inp = 0 ;
  outbuf = '' ;
  erule = '' ;
  einput = 0 ;
  token = '' ;
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
  if (outbuf.charAt(outbuf.length - 1) == '\n') {
    i = stack[stackframe + 2] ;
    while (i>0) { outbuf += ' ' ; i-- } ; } ;
  outbuf += s ;
}

function eol(){
  // output end of line
  outbuf += '\n' ;
}

function test(s) {
  // test for a string in the input
  var i ;
  // delete whitespace
  while ((inbuf.charAt(inp) == ' ')  ||
         (inbuf.charAt(inp) == '\n') ||
         (inbuf.charAt(inp) == '\r') ||
         (inbuf.charAt(inp) == '\t') ) inp++ ;
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
  stack[stackframe + 3] = inp ;           // input position
  stack[stackframe + 4] = outbuf.length ; // output position
  stack[stackframe + 5] = token ;         // current token
}

function bkclear() {
  // clear backtrack context on stack
  stack[stackframe + 3] = -1 ; // input position
  stack[stackframe + 4] = -1 ; // output position
  stack[stackframe + 5] = '' ; // current token
}

function bkrestore() {
  // restore context for backtracking
  eflag = false ;
  inp = stack[stackframe + 3] ;           // input position
  outbuf = outbuf.substring(0,stack[stackframe + 4]) ; // output position
  token = stack[stackframe + 5] ;         // current token
}

