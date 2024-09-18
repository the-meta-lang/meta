// PROGRAM compiler
export const Compiler = {

  compile: function (input) {
    // initialize compiler variables
    this.inbuf = input ;
    this.initialize() ;
    // call the first rule
    this.ctxpush('PROGRAM') ;
    this.rulePROGRAM() ;
    this.ctxpop() ;
    // special case handling of first rule failure
    if ((!this.eflag) && (!this.pflag)) {
      this.eflag = true ;
      this.erule = 'PROGRAM' ;
      this.einput = this.inp ; } ;
    return this.eflag ;
  },

  // body of compiler definition 
  rulePROGRAM: function(){
    this.test('.SYNTAX');
    if (this.pflag) {
      while (!this.eflag) {
        this.ctxpush('ID') ;
        this.ruleID();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out('// ') ;
        this.out(this.token) ;
        this.out(' compiler') ;
        this.eol() ;
        this.out('export const Compiler = {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.eol() ;
        this.ctxpush('PREAMBLE') ;
        this.rulePREAMBLE();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.pflag = true ;
        while (this.pflag & !this.eflag) {
          this.ctxpush('PR') ;
          this.rulePR();
          this.ctxpop() ;
          if (this.pflag) {
            while (!this.eflag) {
              break }
          } ;
          if ((!this.pflag) && (!this.eflag)) {
            this.ctxpush('COMMENT') ;
            this.ruleCOMMENT();
            this.ctxpop() ;
            if (this.pflag) {
              while (!this.eflag) {
                break }
            } ;
          } ;
        } ;
        this.pflag = !this.eflag ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.test('.CODE');
        if (this.pflag) {
          while (!this.eflag) {
            this.pflag = true ;
            while (this.pflag & !this.eflag) {
              this.ctxpush('CODE_RULE') ;
              this.ruleCODE_RULE();
              this.ctxpop() ;
              if (this.pflag) {
                while (!this.eflag) {
                  break }
              } ;
              if ((!this.pflag) && (!this.eflag)) {
                this.ctxpush('COMMENT') ;
                this.ruleCOMMENT();
                this.ctxpop() ;
                if (this.pflag) {
                  while (!this.eflag) {
                    break }
                } ;
              } ;
            } ;
            this.pflag = !this.eflag ;
            if (!this.pflag) this.bkerr();
            if (this.eflag) break ;
            break }
        } ;
        if (this.pflag) {
          while (!this.eflag) {
            break }
        } ;
        if ((!this.pflag) && (!this.eflag)) {
          this.pflag = true ;
          if (this.pflag) {
            while (!this.eflag) {
              break }
          } ;
        } ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.test('.TOKENS');
        if (this.pflag) {
          while (!this.eflag) {
            this.pflag = true ;
            while (this.pflag & !this.eflag) {
              this.ctxpush('TR') ;
              this.ruleTR();
              this.ctxpop() ;
              if (this.pflag) {
                while (!this.eflag) {
                  break }
              } ;
              if ((!this.pflag) && (!this.eflag)) {
                this.ctxpush('COMMENT') ;
                this.ruleCOMMENT();
                this.ctxpop() ;
                if (this.pflag) {
                  while (!this.eflag) {
                    break }
                } ;
              } ;
            } ;
            this.pflag = !this.eflag ;
            if (!this.pflag) this.bkerr();
            if (this.eflag) break ;
            break }
        } ;
        if (this.pflag) {
          while (!this.eflag) {
            break }
        } ;
        if ((!this.pflag) && (!this.eflag)) {
          this.pflag = true ;
          if (this.pflag) {
            while (!this.eflag) {
              break }
          } ;
        } ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.test('.END');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.ctxpush('POSTAMBLE') ;
        this.rulePOSTAMBLE();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('}') ;
        this.eol() ;
        break }
    } ;
  } ,

  // object definition preamble 
  rulePREAMBLE: function(){
    this.out('compile: function (input) {') ;
    this.stack[this.stackframe + 2] += 2 ;
    this.eol() ;
    if (true) {
      while (!this.eflag) {
        this.out('// initialize compiler variables') ;
        this.eol() ;
        this.out('this.inbuf = input ;') ;
        this.eol() ;
        this.out('this.initialize() ;') ;
        this.eol() ;
        this.out('// call the first rule') ;
        this.eol() ;
        this.out('this.ctxpush(') ;
        this.out(String.fromCharCode(39)) ;
        this.out(this.token) ;
        this.out(String.fromCharCode(39)) ;
        this.out(') ;') ;
        this.eol() ;
        this.out('this.rule') ;
        this.out(this.token) ;
        this.out('() ;') ;
        this.eol() ;
        this.out('this.ctxpop() ;') ;
        this.eol() ;
        this.out('// special case handling of first rule failure') ;
        this.eol() ;
        this.out('if ((!this.eflag) && (!this.pflag)) {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('this.eflag = true ;') ;
        this.eol() ;
        this.out('this.erule = ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(this.token) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ;') ;
        this.eol() ;
        this.out('this.einput = this.inp ; } ;') ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.eol() ;
        this.out('return this.eflag ;') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        break }
    } ;
  } ,

  // runtime and object definition postamble  
  rulePOSTAMBLE: function(){
    this.out('// runtime variables') ;
    this.eol() ;
    if (true) {
      while (!this.eflag) {
        this.out('pflag: false ,') ;
        this.eol() ;
        this.out('tflag: false ,') ;
        this.eol() ;
        this.out('eflag: false ,') ;
        this.eol() ;
        this.out('inp: 0 ,') ;
        this.eol() ;
        this.out('inbuf:  ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ,') ;
        this.eol() ;
        this.out('outbuf:  ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ,') ;
        this.eol() ;
        this.out('erule:  ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ,') ;
        this.eol() ;
        this.out('einput: 0 ,') ;
        this.eol() ;
        this.out('token: ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ,') ;
        this.eol() ;
        this.out('labelcount: 0 ,') ;
        this.eol() ;
        this.out('stackframesize: 6 ,') ;
        this.eol() ;
        this.out('stackframe: 0 ,') ;
        this.eol() ;
        this.out('stos: -1 ,') ;
        this.eol() ;
        this.out('stack: [] ,') ;
        this.eol() ;
        this.eol() ;
        this.out('initialize: function () {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// initialize for another compile') ;
        this.eol() ;
        this.out('this.pflag = false ;') ;
        this.eol() ;
        this.out('this.tflag = false ;') ;
        this.eol() ;
        this.out('this.eflag = false ;') ;
        this.eol() ;
        this.out('this.inp = 0 ;') ;
        this.eol() ;
        this.out('this.outbuf = ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ;') ;
        this.eol() ;
        this.out('this.erule = ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ;') ;
        this.eol() ;
        this.out('this.einput = 0 ;') ;
        this.eol() ;
        this.out('this.token = ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ;') ;
        this.eol() ;
        this.out('this.labelcount = 1 ;') ;
        this.eol() ;
        this.out('this.stackframe = -1 ;') ;
        this.eol() ;
        this.out('this.stos = -1 ;') ;
        this.eol() ;
        this.out('this.stack = [] ;') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        this.out('ctxpush: function (rulename){') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// push and initialize a new stackframe') ;
        this.eol() ;
        this.out('var LM ;') ;
        this.eol() ;
        this.out('// new context inherits current context left margin') ;
        this.eol() ;
        this.out('LM = 0; if (this.stackframe >= 0) LM = this.stack[this.stackframe + 2] ;') ;
        this.eol() ;
        this.out('this.stos++ ;') ;
        this.eol() ;
        this.out('this.stackframe = this.stos * this.stackframesize ;') ;
        this.eol() ;
        this.out('// stackframe definition') ;
        this.eol() ;
        this.out('this.stack[this.stackframe + 0] = 0 ;        // generated label') ;
        this.eol() ;
        this.out('this.stack[this.stackframe + 1] = rulename ; // called rule name') ;
        this.eol() ;
        this.out('this.stack[this.stackframe + 2] = LM ;       // left margin') ;
        this.eol() ;
        this.out('// clear additional stackframe backtracking entries') ;
        this.eol() ;
        this.out('this.bkclear() ;') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        this.out('ctxpop: function (){') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// pop and possibly deallocate old stackframe') ;
        this.eol() ;
        this.out('this.stos-- ; // pop stackframe') ;
        this.eol() ;
        this.out('this.stackframe = this.stos * this.stackframesize ;') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        this.out('out: function (s){') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// output string') ;
        this.eol() ;
        this.out('var i ;') ;
        this.eol() ;
        this.out('// if newline last output, add left margin before string') ;
        this.eol() ;
        this.out('if (this.outbuf.charAt(this.outbuf.length - 1) == ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(92)) ;
        this.out('n') ;
        this.out(String.fromCharCode(39)) ;
        this.out(') {') ;
        this.eol() ;
        this.out('  i = this.stack[this.stackframe + 2] ;') ;
        this.eol() ;
        this.out('  while (i>0) { this.outbuf += ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ; i-- } ; } ;') ;
        this.eol() ;
        this.out('this.outbuf += s ;') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        this.out('eol: function (){') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// output end of line') ;
        this.eol() ;
        this.out('this.outbuf += ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(92)) ;
        this.out('n') ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ;') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        this.out('test: function (s) {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// test for a string in the input') ;
        this.eol() ;
        this.out('var i ;') ;
        this.eol() ;
        this.out('// delete whitespace') ;
        this.eol() ;
        this.out('while ((this.inbuf.charAt(this.inp) == ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(')  ||') ;
        this.eol() ;
        this.out('       (this.inbuf.charAt(this.inp) == ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(92)) ;
        this.out('n') ;
        this.out(String.fromCharCode(39)) ;
        this.out(') ||') ;
        this.eol() ;
        this.out('       (this.inbuf.charAt(this.inp) == ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(92)) ;
        this.out('r') ;
        this.out(String.fromCharCode(39)) ;
        this.out(') ||') ;
        this.eol() ;
        this.out('       (this.inbuf.charAt(this.inp) == ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(92)) ;
        this.out('t') ;
        this.out(String.fromCharCode(39)) ;
        this.out(') ) this.inp++ ;') ;
        this.eol() ;
        this.out('// test string case insensitive') ;
        this.eol() ;
        this.out('this.pflag = true ; i = 0 ;') ;
        this.eol() ;
        this.out('while (this.pflag && (i < s.length) && ((this.inp+i) < this.inbuf.length) )') ;
        this.eol() ;
        this.out('{ this.pflag = (s.charAt(i).toUpperCase() ==') ;
        this.eol() ;
        this.out('                this.inbuf.charAt(this.inp+i).toUpperCase()) ;') ;
        this.eol() ;
        this.out('  i++ ; } ;') ;
        this.eol() ;
        this.out('this.pflag = this.pflag && (i == s.length) ;') ;
        this.eol() ;
        this.out('// advance input if found') ;
        this.eol() ;
        this.out('if (this.pflag) this.inp = this.inp + s.length ;') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        this.out('bkerr: function () {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// compilation error, provide error indication and context') ;
        this.eol() ;
        this.out('this.eflag = true ;') ;
        this.eol() ;
        this.out('this.erule = this.stack[this.stackframe + 1] ;') ;
        this.eol() ;
        this.out('this.einput = this.inp ;') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        this.out('bkset: function () {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// set backtrack context on stack') ;
        this.eol() ;
        this.out('this.stack[this.stackframe + 3] = this.inp ;           // input position') ;
        this.eol() ;
        this.out('this.stack[this.stackframe + 4] = this.outbuf.length ; // output position') ;
        this.eol() ;
        this.out('this.stack[this.stackframe + 5] = this.token ;         // current token') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        this.out('bkclear: function () {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// clear backtrack context on stack') ;
        this.eol() ;
        this.out('this.stack[this.stackframe + 3] = -1 ; // input position') ;
        this.eol() ;
        this.out('this.stack[this.stackframe + 4] = -1 ; // output position') ;
        this.eol() ;
        this.out('this.stack[this.stackframe + 5] = ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ; // current token') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('},') ;
        this.eol() ;
        this.eol() ;
        this.out('bkrestore: function () {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.out('// restore context for backtracking') ;
        this.eol() ;
        this.out('this.eflag = false ;') ;
        this.eol() ;
        this.out('this.inp = this.stack[this.stackframe + 3] ;           // input position') ;
        this.eol() ;
        this.out('this.outbuf = this.outbuf.substring(0,this.stack[this.stackframe + 4]) ; // output position') ;
        this.eol() ;
        this.out('this.token = this.stack[this.stackframe + 5] ;         // current token') ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('}') ;
        this.eol() ;
        this.eol() ;
        break }
    } ;
  } ,

  // parsing rule definition 
  // @example PARSE_RULE<argument, argument2>
  rulePR: function(){
    this.ctxpush('ID') ;
    this.ruleID();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        this.out('rule') ;
        this.out(this.token) ;
        this.out(': function') ;
        this.test('<');
        if (this.pflag) {
          while (!this.eflag) {
            this.ctxpush('ID') ;
            this.ruleID();
            this.ctxpop() ;
            if (!this.pflag) this.bkerr();
            if (this.eflag) break ;
            this.out('(') ;
            this.out(this.token) ;
            this.pflag = true ;
            while (this.pflag & !this.eflag) {
              this.ctxpush('ID') ;
              this.ruleID();
              this.ctxpop() ;
              if (this.pflag) {
                while (!this.eflag) {
                  this.out(', ') ;
                  this.out(this.token) ;
                  break }
              } ;
            } ;
            this.pflag = !this.eflag ;
            if (!this.pflag) this.bkerr();
            if (this.eflag) break ;
            this.test('>');
            if (!this.pflag) this.bkerr();
            if (this.eflag) break ;
            this.out(')') ;
            break }
        } ;
        if (this.pflag) {
          while (!this.eflag) {
            break }
        } ;
        if ((!this.pflag) && (!this.eflag)) {
          this.pflag = true ;
          if (this.pflag) {
            while (!this.eflag) {
              this.out('()') ;
              break }
          } ;
          if (this.pflag) {
            while (!this.eflag) {
              break }
          } ;
        } ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out('{') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.test('=');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.ctxpush('EX1') ;
        this.ruleEX1();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.test(';');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('} ,') ;
        this.eol() ;
        this.eol() ;
        break }
    } ;
  } ,

  // token rule definition 
  ruleTR: function(){
    this.ctxpush('ID') ;
    this.ruleID();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        this.out('rule') ;
        this.out(this.token) ;
        this.out(': function () {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.test(':');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.ctxpush('TX1') ;
        this.ruleTX1();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.test(';');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('} ,') ;
        this.eol() ;
        this.eol() ;
        break }
    } ;
  } ,

  // comment definition 
  ruleCOMMENT: function(){
    this.test('//');
    if (this.pflag) {
      while (!this.eflag) {
        this.ctxpush('CMLINE') ;
        this.ruleCMLINE();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out('//') ;
        this.out(this.token) ;
        this.eol() ;
        break }
    } ;
  } ,

  // -------------------------- META Lisp Definitions ----------------------------
  ruleCODE_RULE: function(){
    this.ctxpush('LISP_DEFINE') ;
    this.ruleLISP_DEFINE();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_DEFUNC') ;
      this.ruleLISP_DEFUNC();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
  } ,

  ruleLISPARG: function(){
    this.ctxpush('ID') ;
    this.ruleID();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('NUMBER') ;
      this.ruleNUMBER();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('RAWSTRING') ;
      this.ruleRAWSTRING();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
  } ,

  ruleLISP_DEFINE: function(){
    this.test('[define');
    if (this.pflag) {
      while (!this.eflag) {
        this.ctxpush('ID') ;
        this.ruleID();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out('this.') ;
        this.out(this.token) ;
        this.out(' = ') ;
        this.ctxpush('LISPARG') ;
        this.ruleLISPARG();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out(this.token) ;
        this.out(';') ;
        this.eol() ;
        this.test(']');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        break }
    } ;
  } ,

  ruleLISP_DEFUNC: function(){
    this.test('[defunc');
    if (this.pflag) {
      while (!this.eflag) {
        this.ctxpush('ID') ;
        this.ruleID();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out('function ') ;
        this.out(this.token) ;
        this.out('(') ;
        this.test('[');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.ctxpush('ID') ;
        this.ruleID();
        this.ctxpop() ;
        if (this.pflag) {
          while (!this.eflag) {
            this.out(this.token) ;
            break }
        } ;
        if ((!this.pflag) && (!this.eflag)) {
          this.pflag = true ;
          if (this.pflag) {
            while (!this.eflag) {
              break }
          } ;
        } ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.pflag = true ;
        while (this.pflag & !this.eflag) {
          this.ctxpush('ID') ;
          this.ruleID();
          this.ctxpop() ;
          if (this.pflag) {
            while (!this.eflag) {
              this.out(', ') ;
              this.out(this.token) ;
              break }
          } ;
        } ;
        this.pflag = !this.eflag ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.test(']');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out(') {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.ctxpush('LISP') ;
        this.ruleLISP();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.test(']');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out('}') ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.eol() ;
        break }
    } ;
  } ,

  ruleLISP_IF: function(){
    this.test('[if');
    if (this.pflag) {
      while (!this.eflag) {
        this.out('if (') ;
        this.ctxpush('LISPARG') ;
        this.ruleLISPARG();
        this.ctxpop() ;
        if (this.pflag) {
          while (!this.eflag) {
            this.out(this.token) ;
            break }
        } ;
        if ((!this.pflag) && (!this.eflag)) {
          this.ctxpush('LISP') ;
          this.ruleLISP();
          this.ctxpop() ;
          if (this.pflag) {
            while (!this.eflag) {
              break }
          } ;
        } ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out(') {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.ctxpush('LISP') ;
        this.ruleLISP();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('} ;') ;
        this.eol() ;
        this.test(']');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        break }
    } ;
  } ,

  ruleLISP_WHILE: function(){
    this.test('[while');
    if (this.pflag) {
      while (!this.eflag) {
        this.ctxpush('LISPARG') ;
        this.ruleLISPARG();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out('while (') ;
        this.out(this.token) ;
        this.out(') {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.ctxpush('LISPARG') ;
        this.ruleLISPARG();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('} ;') ;
        this.eol() ;
        this.test(']');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        break }
    } ;
  } ,

  ruleLISP: function(){
    this.test('>');
    if (this.pflag) {
      while (!this.eflag) {
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('<');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('==');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('!=');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('<=');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('>=');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('+');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('-');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('*');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('/');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('&&');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('||');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
  } ,

  ruleLISP_OPERATOR_METHOD: function(operator){
    this.test('[');
    if (this.pflag) {
      while (!this.eflag) {
        this.test(operator);
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.ctxpush('LISPARG') ;
        this.ruleLISPARG();
        this.ctxpop() ;
        if (this.pflag) {
          while (!this.eflag) {
            this.out(this.token) ;
            break }
        } ;
        if (this.pflag) {
          while (!this.eflag) {
            break }
        } ;
        if ((!this.pflag) && (!this.eflag)) {
          this.ctxpush('LISP') ;
          this.ruleLISP();
          this.ctxpop() ;
          if (this.pflag) {
            while (!this.eflag) {
              break }
          } ;
        } ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.pflag = true ;
        while (this.pflag & !this.eflag) {
          this.ctxpush('LISPARG') ;
          this.ruleLISPARG();
          this.ctxpop() ;
          if (this.pflag) {
            while (!this.eflag) {
              this.out(operator);
              this.out(this.token) ;
              break }
          } ;
          if (this.pflag) {
            while (!this.eflag) {
              break }
          } ;
          if ((!this.pflag) && (!this.eflag)) {
            this.ctxpush('LISP') ;
            this.ruleLISP();
            this.ctxpop() ;
            if (this.pflag) {
              while (!this.eflag) {
                break }
            } ;
          } ;
        } ;
        this.pflag = !this.eflag ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.test(']');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        break }
    } ;
  } ,

  ruleLISP: function(){
    this.ctxpush('LISP_DEFINE') ;
    this.ruleLISP_DEFINE();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_IF') ;
      this.ruleLISP_IF();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_WHILE') ;
      this.ruleLISP_WHILE();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("+");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("-");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("*");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("/");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD(">");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("<");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("==");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("!=");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("<=");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD(">=");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("&&");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP_OPERATOR_METHOD') ;
      this.ruleLISP_OPERATOR_METHOD("||");
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('[');
      if (this.pflag) {
        while (!this.eflag) {
          this.ctxpush('LISP') ;
          this.ruleLISP();
          this.ctxpop() ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.test(']');
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          break }
      } ;
    } ;
  } ,

  // --------------------------- Parsing expressions -----------------------------
  ruleEX1: function(){
    this.ctxpush('EX2') ;
    this.ruleEX2();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        this.pflag = true ;
        while (this.pflag & !this.eflag) {
          this.test('|');
          if (this.pflag) {
            while (!this.eflag) {
              this.out('if ((!this.pflag) && (!this.eflag)) {') ;
              this.stack[this.stackframe + 2] += 2 ;
              this.eol() ;
              this.ctxpush('EX2') ;
              this.ruleEX2();
              this.ctxpop() ;
              if (!this.pflag) this.bkerr();
              if (this.eflag) break ;
              this.stack[this.stackframe + 2] -= 2 ;
              this.out('} ;') ;
              this.eol() ;
              break }
          } ;
        } ;
        this.pflag = !this.eflag ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        break }
    } ;
  } ,

  ruleEX2: function(){
    this.ctxpush('EX3') ;
    this.ruleEX3();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        this.out('if (this.pflag) {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('OUTPUT') ;
      this.ruleOUTPUT();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          this.out('if (true) {') ;
          this.stack[this.stackframe + 2] += 2 ;
          this.eol() ;
          break }
      } ;
    } ;
    if (this.pflag) {
      while (!this.eflag) {
        this.out('while (!this.eflag) {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.pflag = true ;
        while (this.pflag & !this.eflag) {
          this.ctxpush('EX3') ;
          this.ruleEX3();
          this.ctxpop() ;
          if (this.pflag) {
            while (!this.eflag) {
              this.out('if (!this.pflag) this.bkerr();') ;
              this.eol() ;
              this.out('if (this.eflag) break ;') ;
              this.eol() ;
              break }
          } ;
          if ((!this.pflag) && (!this.eflag)) {
            this.ctxpush('OUTPUT') ;
            this.ruleOUTPUT();
            this.ctxpop() ;
            if (this.pflag) {
              while (!this.eflag) {
                break }
            } ;
          } ;
        } ;
        this.pflag = !this.eflag ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out('break }') ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.eol() ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('} ;') ;
        this.eol() ;
        break }
    } ;
  } ,

  ruleEX3: function(){
    this.ctxpush('ID') ;
    this.ruleID();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        this.out('this.ctxpush(') ;
        this.out(String.fromCharCode(39)) ;
        this.out(this.token) ;
        this.out(String.fromCharCode(39)) ;
        this.out(') ;') ;
        this.eol() ;
        this.out('this.rule') ;
        this.out(this.token) ;
        this.out('(') ;
        this.test('<');
        if (this.pflag) {
          while (!this.eflag) {
            this.ctxpush('ID') ;
            this.ruleID();
            this.ctxpop() ;
            if (this.pflag) {
              while (!this.eflag) {
                break }
            } ;
            if ((!this.pflag) && (!this.eflag)) {
              this.ctxpush('RAWSTRING') ;
              this.ruleRAWSTRING();
              this.ctxpop() ;
              if (this.pflag) {
                while (!this.eflag) {
                  break }
              } ;
            } ;
            if ((!this.pflag) && (!this.eflag)) {
              this.ctxpush('NUMBER') ;
              this.ruleNUMBER();
              this.ctxpop() ;
              if (this.pflag) {
                while (!this.eflag) {
                  break }
              } ;
            } ;
            if (!this.pflag) this.bkerr();
            if (this.eflag) break ;
            this.out(this.token) ;
            this.pflag = true ;
            while (this.pflag & !this.eflag) {
              this.ctxpush('ID') ;
              this.ruleID();
              this.ctxpop() ;
              if (this.pflag) {
                while (!this.eflag) {
                  break }
              } ;
              if ((!this.pflag) && (!this.eflag)) {
                this.ctxpush('RAWSTRING') ;
                this.ruleRAWSTRING();
                this.ctxpop() ;
                if (this.pflag) {
                  while (!this.eflag) {
                    break }
                } ;
              } ;
              if ((!this.pflag) && (!this.eflag)) {
                this.ctxpush('NUMBER') ;
                this.ruleNUMBER();
                this.ctxpop() ;
                if (this.pflag) {
                  while (!this.eflag) {
                    break }
                } ;
              } ;
              if (this.pflag) {
                while (!this.eflag) {
                  this.out(', ') ;
                  this.out(this.token) ;
                  break }
              } ;
            } ;
            this.pflag = !this.eflag ;
            if (!this.pflag) this.bkerr();
            if (this.eflag) break ;
            this.test('>');
            if (!this.pflag) this.bkerr();
            if (this.eflag) break ;
            break }
        } ;
        if (this.pflag) {
          while (!this.eflag) {
            break }
        } ;
        if ((!this.pflag) && (!this.eflag)) {
          this.pflag = true ;
          if (this.pflag) {
            while (!this.eflag) {
              break }
          } ;
        } ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.out(');') ;
        this.eol() ;
        this.out('this.ctxpop() ;') ;
        this.eol() ;
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('STRING') ;
      this.ruleSTRING();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.test(') ;
          this.out(String.fromCharCode(39)) ;
          this.out(this.token) ;
          this.out(String.fromCharCode(39)) ;
          this.out(');') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('(');
      if (this.pflag) {
        while (!this.eflag) {
          this.ctxpush('EX1') ;
          this.ruleEX1();
          this.ctxpop() ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.test(')');
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.EMPTY');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.pflag = true ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.LITCHR');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.token = this.inbuf.charCodeAt(this.inp) ;') ;
          this.eol() ;
          this.out('this.inp++ ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.PASS');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.inp = 0 ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('$');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.pflag = true ;') ;
          this.eol() ;
          this.out('while (this.pflag & !this.eflag) {') ;
          this.stack[this.stackframe + 2] += 2 ;
          this.eol() ;
          this.ctxpush('EX3') ;
          this.ruleEX3();
          this.ctxpop() ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.stack[this.stackframe + 2] -= 2 ;
          this.out('} ;') ;
          this.eol() ;
          this.out('this.pflag = !this.eflag ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('{');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.bkset() ;') ;
          this.eol() ;
          this.ctxpush('EX1') ;
          this.ruleEX1();
          this.ctxpop() ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.pflag = true ;
          while (this.pflag & !this.eflag) {
            this.test('|');
            if (this.pflag) {
              while (!this.eflag) {
                this.out('if (!this.pflag) {') ;
                this.stack[this.stackframe + 2] += 2 ;
                this.eol() ;
                this.out('if (this.eflag) this.bkrestore() ;') ;
                this.eol() ;
                this.ctxpush('EX1') ;
                this.ruleEX1();
                this.ctxpop() ;
                if (!this.pflag) this.bkerr();
                if (this.eflag) break ;
                this.stack[this.stackframe + 2] -= 2 ;
                this.out('} ;') ;
                this.eol() ;
                break }
            } ;
          } ;
          this.pflag = !this.eflag ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.test('}');
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.out('if (this.eflag) this.bkrestore() ;') ;
          this.eol() ;
          this.out('this.bkclear() ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('*');
      if (this.pflag) {
        while (!this.eflag) {
          this.ctxpush('ID') ;
          this.ruleID();
          this.ctxpop() ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.out('this.test(') ;
          this.out(this.token) ;
          this.out(');') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('LISP') ;
      this.ruleLISP();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
  } ,

  // output expressions 
  ruleOUTPUT: function(){
    this.test('->');
    if (this.pflag) {
      while (!this.eflag) {
        this.test('(');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.pflag = true ;
        while (this.pflag & !this.eflag) {
          this.ctxpush('OUT1') ;
          this.ruleOUT1();
          this.ctxpop() ;
        } ;
        this.pflag = !this.eflag ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.test(')');
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        break }
    } ;
  } ,

  ruleOUT1: function(){
    this.test('*');
    if (this.pflag) {
      while (!this.eflag) {
        this.ctxpush('ID') ;
        this.ruleID();
        this.ctxpop() ;
        if (this.pflag) {
          while (!this.eflag) {
            this.out('this.out(') ;
            this.out(this.token) ;
            this.out(');') ;
            this.eol() ;
            break }
        } ;
        if ((!this.pflag) && (!this.eflag)) {
          this.pflag = true ;
          if (this.pflag) {
            while (!this.eflag) {
              this.out('this.out(this.token) ;') ;
              this.eol() ;
              break }
          } ;
        } ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('STRING') ;
      this.ruleSTRING();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.out(') ;
          this.out(String.fromCharCode(39)) ;
          this.out(this.token) ;
          this.out(String.fromCharCode(39)) ;
          this.out(') ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('NUMBER') ;
      this.ruleNUMBER();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.out(String.fromCharCode(') ;
          this.out(this.token) ;
          this.out(')) ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('#');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('if (this.stack[this.stackframe + 0] == 0) {') ;
          this.stack[this.stackframe + 2] += 2 ;
          this.eol() ;
          this.out('this.stack[this.stackframe + 0] = this.labelcount ;') ;
          this.eol() ;
          this.out('this.labelcount++ ; } ;') ;
          this.stack[this.stackframe + 2] -= 2 ;
          this.eol() ;
          this.out('this.out(this.stack[this.stackframe + 0]) ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.NL');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.eol() ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.LB');
      if (this.pflag) {
        while (!this.eflag) {
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.TB');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.out(') ;
          this.out(String.fromCharCode(39)) ;
          this.out(String.fromCharCode(92)) ;
          this.out('t') ;
          this.out(String.fromCharCode(39)) ;
          this.out(') ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.LM+');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.stack[this.stackframe + 2] += 2 ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.LM-');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.stack[this.stackframe + 2] -= 2 ;') ;
          this.eol() ;
          break }
      } ;
    } ;
  } ,

  // token expressions 
  ruleTX1: function(){
    this.ctxpush('TX2') ;
    this.ruleTX2();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        this.pflag = true ;
        while (this.pflag & !this.eflag) {
          this.test('/');
          if (this.pflag) {
            while (!this.eflag) {
              this.out('if (!this.pflag) {') ;
              this.stack[this.stackframe + 2] += 2 ;
              this.eol() ;
              this.ctxpush('TX2') ;
              this.ruleTX2();
              this.ctxpop() ;
              if (!this.pflag) this.bkerr();
              if (this.eflag) break ;
              this.stack[this.stackframe + 2] -= 2 ;
              this.out('} ;') ;
              this.eol() ;
              break }
          } ;
        } ;
        this.pflag = !this.eflag ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        break }
    } ;
  } ,

  ruleTX2: function(){
    this.ctxpush('TX3') ;
    this.ruleTX3();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        this.out('if (this.pflag) {') ;
        this.stack[this.stackframe + 2] += 2 ;
        this.eol() ;
        this.pflag = true ;
        while (this.pflag & !this.eflag) {
          this.ctxpush('TX3') ;
          this.ruleTX3();
          this.ctxpop() ;
          if (this.pflag) {
            while (!this.eflag) {
              this.out('if (!this.pflag) return;') ;
              this.eol() ;
              break }
          } ;
        } ;
        this.pflag = !this.eflag ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out('} ;') ;
        this.eol() ;
        break }
    } ;
  } ,

  ruleTX3: function(){
    this.test('.TOKEN');
    if (this.pflag) {
      while (!this.eflag) {
        this.out('this.tflag = true ; ') ;
        this.eol() ;
        this.out('this.token = ') ;
        this.out(String.fromCharCode(39)) ;
        this.out(String.fromCharCode(39)) ;
        this.out(' ;') ;
        this.eol() ;
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.DELTOK');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.tflag = false ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('$');
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.pflag = true ;') ;
          this.eol() ;
          this.out('while (this.pflag) {') ;
          this.stack[this.stackframe + 2] += 2 ;
          this.eol() ;
          this.ctxpush('TX3') ;
          this.ruleTX3();
          this.ctxpop() ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.stack[this.stackframe + 2] -= 2 ;
          this.out('};') ;
          this.eol() ;
          break }
      } ;
    } ;
    if (this.pflag) {
      while (!this.eflag) {
        this.out('this.pflag = true ;') ;
        this.eol() ;
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.ANYBUT(');
      if (this.pflag) {
        while (!this.eflag) {
          this.ctxpush('CX1') ;
          this.ruleCX1();
          this.ctxpop() ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.test(')');
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.out('this.pflag = !this.pflag ;') ;
          this.eol() ;
          this.out('if (this.pflag) {') ;
          this.stack[this.stackframe + 2] += 2 ;
          this.eol() ;
          this.out('if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;') ;
          this.eol() ;
          this.out('this.inp++ } ;') ;
          this.stack[this.stackframe + 2] -= 2 ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('.ANY(');
      if (this.pflag) {
        while (!this.eflag) {
          this.ctxpush('CX1') ;
          this.ruleCX1();
          this.ctxpop() ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.test(')');
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.out('if (this.pflag) {') ;
          this.stack[this.stackframe + 2] += 2 ;
          this.eol() ;
          this.out('if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;') ;
          this.eol() ;
          this.out('this.inp++ } ;') ;
          this.stack[this.stackframe + 2] -= 2 ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('ID') ;
      this.ruleID();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          this.out('this.ctxpush(') ;
          this.out(String.fromCharCode(39)) ;
          this.out(this.token) ;
          this.out(String.fromCharCode(39)) ;
          this.out(') ;') ;
          this.eol() ;
          this.out('this.rule') ;
          this.out(this.token) ;
          this.out('() ;') ;
          this.eol() ;
          this.out('this.ctxpop() ;') ;
          this.eol() ;
          this.out('if (this.eflag) return ;') ;
          this.eol() ;
          break }
      } ;
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.test('(');
      if (this.pflag) {
        while (!this.eflag) {
          this.ctxpush('TX1') ;
          this.ruleTX1();
          this.ctxpop() ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          this.test(')');
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          break }
      } ;
    } ;
  } ,

  // character expressions             
  ruleCX1: function(){
    this.out('this.pflag = ') ;
    this.stack[this.stackframe + 2] += 2 ;
    this.eol() ;
    if (true) {
      while (!this.eflag) {
        this.ctxpush('CX2') ;
        this.ruleCX2();
        this.ctxpop() ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.pflag = true ;
        while (this.pflag & !this.eflag) {
          this.test('!');
          if (this.pflag) {
            while (!this.eflag) {
              this.out(' ||') ;
              this.eol() ;
              this.ctxpush('CX2') ;
              this.ruleCX2();
              this.ctxpop() ;
              if (!this.pflag) this.bkerr();
              if (this.eflag) break ;
              break }
          } ;
        } ;
        this.pflag = !this.eflag ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        this.stack[this.stackframe + 2] -= 2 ;
        this.out(' ;') ;
        this.eol() ;
        break }
    } ;
  } ,

  ruleCX2: function(){
    this.ctxpush('CX3') ;
    this.ruleCX3();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        this.test(':');
        if (this.pflag) {
          while (!this.eflag) {
            this.out('((this.inbuf.charCodeAt(this.inp) >= ') ;
            this.out(this.token) ;
            this.out(') &&') ;
            this.eol() ;
            this.ctxpush('CX3') ;
            this.ruleCX3();
            this.ctxpop() ;
            if (!this.pflag) this.bkerr();
            if (this.eflag) break ;
            this.out(' (this.inbuf.charCodeAt(this.inp) <= ') ;
            this.out(this.token) ;
            this.out(')  )') ;
            break }
        } ;
        if ((!this.pflag) && (!this.eflag)) {
          this.pflag = true ;
          if (this.pflag) {
            while (!this.eflag) {
              this.out('(this.inbuf.charCodeAt(this.inp) == ') ;
              this.out(this.token) ;
              this.out(') ') ;
              break }
          } ;
        } ;
        if (!this.pflag) this.bkerr();
        if (this.eflag) break ;
        break }
    } ;
  } ,

  ruleCX3: function(){
    this.ctxpush('NUMBER') ;
    this.ruleNUMBER();
    this.ctxpop() ;
    if (this.pflag) {
      while (!this.eflag) {
        break }
    } ;
    if ((!this.pflag) && (!this.eflag)) {
      this.ctxpush('SQUOTE') ;
      this.ruleSQUOTE();
      this.ctxpop() ;
      if (this.pflag) {
        while (!this.eflag) {
          this.token = this.inbuf.charCodeAt(this.inp) ;
          this.inp++ ;
          if (!this.pflag) this.bkerr();
          if (this.eflag) break ;
          break }
      } ;
    } ;
  } ,

  rulePREFIX: function () {
    this.pflag = true ;
    while (this.pflag) {
      this.pflag = 
        (this.inbuf.charCodeAt(this.inp) == 32)  ||
        (this.inbuf.charCodeAt(this.inp) == 9)  ||
        (this.inbuf.charCodeAt(this.inp) == 13)  ||
        (this.inbuf.charCodeAt(this.inp) == 10)  ;
      if (this.pflag) {
        if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
        this.inp++ } ;
    };
    this.pflag = true ;
    if (this.pflag) {
    } ;
  } ,

  ruleID: function () {
    this.ctxpush('PREFIX') ;
    this.rulePREFIX() ;
    this.ctxpop() ;
    if (this.eflag) return ;
    if (this.pflag) {
      this.tflag = true ; 
      this.token = '' ;
      this.pflag = true ;
      if (!this.pflag) return;
      this.ctxpush('ALPHA') ;
      this.ruleALPHA() ;
      this.ctxpop() ;
      if (this.eflag) return ;
      if (!this.pflag) return;
      this.pflag = true ;
      while (this.pflag) {
        this.ctxpush('ALPHA') ;
        this.ruleALPHA() ;
        this.ctxpop() ;
        if (this.eflag) return ;
        if (this.pflag) {
        } ;
        if (!this.pflag) {
          this.ctxpush('DIGIT') ;
          this.ruleDIGIT() ;
          this.ctxpop() ;
          if (this.eflag) return ;
          if (this.pflag) {
          } ;
        } ;
      };
      this.pflag = true ;
      if (!this.pflag) return;
      this.tflag = false ;
      this.pflag = true ;
      if (!this.pflag) return;
    } ;
  } ,

  ruleNUMBER: function () {
    this.ctxpush('PREFIX') ;
    this.rulePREFIX() ;
    this.ctxpop() ;
    if (this.eflag) return ;
    if (this.pflag) {
      this.tflag = true ; 
      this.token = '' ;
      this.pflag = true ;
      if (!this.pflag) return;
      this.ctxpush('DIGIT') ;
      this.ruleDIGIT() ;
      this.ctxpop() ;
      if (this.eflag) return ;
      if (!this.pflag) return;
      this.pflag = true ;
      while (this.pflag) {
        this.ctxpush('DIGIT') ;
        this.ruleDIGIT() ;
        this.ctxpop() ;
        if (this.eflag) return ;
      };
      this.pflag = true ;
      if (!this.pflag) return;
      this.tflag = false ;
      this.pflag = true ;
      if (!this.pflag) return;
    } ;
  } ,

  ruleSTRING: function () {
    this.ctxpush('PREFIX') ;
    this.rulePREFIX() ;
    this.ctxpop() ;
    if (this.eflag) return ;
    if (this.pflag) {
      this.pflag = 
        (this.inbuf.charCodeAt(this.inp) == 34)  ;
      if (this.pflag) {
        if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
        this.inp++ } ;
      if (!this.pflag) return;
      this.tflag = true ; 
      this.token = '' ;
      this.pflag = true ;
      if (!this.pflag) return;
      this.pflag = true ;
      while (this.pflag) {
        this.pflag = 
          (this.inbuf.charCodeAt(this.inp) == 13)  ||
          (this.inbuf.charCodeAt(this.inp) == 10)  ||
          (this.inbuf.charCodeAt(this.inp) == 34)  ;
        this.pflag = !this.pflag ;
        if (this.pflag) {
          if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
          this.inp++ } ;
      };
      this.pflag = true ;
      if (!this.pflag) return;
      this.tflag = false ;
      this.pflag = true ;
      if (!this.pflag) return;
      this.pflag = 
        (this.inbuf.charCodeAt(this.inp) == 34)  ;
      if (this.pflag) {
        if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
        this.inp++ } ;
      if (!this.pflag) return;
    } ;
  } ,

  ruleRAWSTRING: function () {
    this.ctxpush('PREFIX') ;
    this.rulePREFIX() ;
    this.ctxpop() ;
    if (this.eflag) return ;
    if (this.pflag) {
      this.tflag = true ; 
      this.token = '' ;
      this.pflag = true ;
      if (!this.pflag) return;
      this.pflag = 
        (this.inbuf.charCodeAt(this.inp) == 34)  ;
      if (this.pflag) {
        if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
        this.inp++ } ;
      if (!this.pflag) return;
      this.pflag = true ;
      while (this.pflag) {
        this.pflag = 
          (this.inbuf.charCodeAt(this.inp) == 13)  ||
          (this.inbuf.charCodeAt(this.inp) == 10)  ||
          (this.inbuf.charCodeAt(this.inp) == 34)  ;
        this.pflag = !this.pflag ;
        if (this.pflag) {
          if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
          this.inp++ } ;
      };
      this.pflag = true ;
      if (!this.pflag) return;
      this.pflag = 
        (this.inbuf.charCodeAt(this.inp) == 34)  ;
      if (this.pflag) {
        if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
        this.inp++ } ;
      if (!this.pflag) return;
      this.tflag = false ;
      this.pflag = true ;
      if (!this.pflag) return;
    } ;
  } ,

  ruleALPHA: function () {
    this.pflag = 
      ((this.inbuf.charCodeAt(this.inp) >= 65) &&
       (this.inbuf.charCodeAt(this.inp) <= 90)  ) ||
      ((this.inbuf.charCodeAt(this.inp) >= 97) &&
       (this.inbuf.charCodeAt(this.inp) <= 122)  ) ||
      (this.inbuf.charCodeAt(this.inp) == 95)  ;
    if (this.pflag) {
      if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
      this.inp++ } ;
    if (this.pflag) {
    } ;
  } ,

  ruleDIGIT: function () {
    this.pflag = 
      ((this.inbuf.charCodeAt(this.inp) >= 48) &&
       (this.inbuf.charCodeAt(this.inp) <= 57)  ) ;
    if (this.pflag) {
      if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
      this.inp++ } ;
    if (this.pflag) {
    } ;
  } ,

  ruleSQUOTE: function () {
    this.ctxpush('PREFIX') ;
    this.rulePREFIX() ;
    this.ctxpop() ;
    if (this.eflag) return ;
    if (this.pflag) {
      this.pflag = 
        (this.inbuf.charCodeAt(this.inp) == 39)  ;
      if (this.pflag) {
        if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
        this.inp++ } ;
      if (!this.pflag) return;
    } ;
  } ,

  ruleCMLINE: function () {
    this.tflag = true ; 
    this.token = '' ;
    this.pflag = true ;
    if (this.pflag) {
      this.pflag = true ;
      while (this.pflag) {
        this.pflag = 
          (this.inbuf.charCodeAt(this.inp) == 10)  ||
          (this.inbuf.charCodeAt(this.inp) == 13)  ;
        this.pflag = !this.pflag ;
        if (this.pflag) {
          if (this.tflag) this.token += this.inbuf.charAt(this.inp) ;
          this.inp++ } ;
      };
      this.pflag = true ;
      if (!this.pflag) return;
      this.tflag = false ;
      this.pflag = true ;
      if (!this.pflag) return;
    } ;
  } ,

  // runtime variables
  pflag: false ,
  tflag: false ,
  eflag: false ,
  inp: 0 ,
  inbuf:  '' ,
  outbuf:  '' ,
  erule:  '' ,
  einput: 0 ,
  token: '' ,
  labelcount: 0 ,
  stackframesize: 6 ,
  stackframe: 0 ,
  stos: -1 ,
  stack: [] ,

  initialize: function () {
    // initialize for another compile
    this.pflag = false ;
    this.tflag = false ;
    this.eflag = false ;
    this.inp = 0 ;
    this.outbuf = '' ;
    this.erule = '' ;
    this.einput = 0 ;
    this.token = '' ;
    this.labelcount = 1 ;
    this.stackframe = -1 ;
    this.stos = -1 ;
    this.stack = [] ;
  },

  ctxpush: function (rulename){
    // push and initialize a new stackframe
    var LM ;
    // new context inherits current context left margin
    LM = 0; if (this.stackframe >= 0) LM = this.stack[this.stackframe + 2] ;
    this.stos++ ;
    this.stackframe = this.stos * this.stackframesize ;
    // stackframe definition
    this.stack[this.stackframe + 0] = 0 ;        // generated label
    this.stack[this.stackframe + 1] = rulename ; // called rule name
    this.stack[this.stackframe + 2] = LM ;       // left margin
    // clear additional stackframe backtracking entries
    this.bkclear() ;
  },

  ctxpop: function (){
    // pop and possibly deallocate old stackframe
    this.stos-- ; // pop stackframe
    this.stackframe = this.stos * this.stackframesize ;
  },

  out: function (s){
    // output string
    var i ;
    // if newline last output, add left margin before string
    if (this.outbuf.charAt(this.outbuf.length - 1) == '\n') {
      i = this.stack[this.stackframe + 2] ;
      while (i>0) { this.outbuf += ' ' ; i-- } ; } ;
    this.outbuf += s ;
  },

  eol: function (){
    // output end of line
    this.outbuf += '\n' ;
  },

  test: function (s) {
    // test for a string in the input
    var i ;
    // delete whitespace
    while ((this.inbuf.charAt(this.inp) == ' ')  ||
           (this.inbuf.charAt(this.inp) == '\n') ||
           (this.inbuf.charAt(this.inp) == '\r') ||
           (this.inbuf.charAt(this.inp) == '\t') ) this.inp++ ;
    // test string case insensitive
    this.pflag = true ; i = 0 ;
    while (this.pflag && (i < s.length) && ((this.inp+i) < this.inbuf.length) )
    { this.pflag = (s.charAt(i).toUpperCase() ==
                    this.inbuf.charAt(this.inp+i).toUpperCase()) ;
      i++ ; } ;
    this.pflag = this.pflag && (i == s.length) ;
    // advance input if found
    if (this.pflag) this.inp = this.inp + s.length ;
  },

  bkerr: function () {
    // compilation error, provide error indication and context
    this.eflag = true ;
    this.erule = this.stack[this.stackframe + 1] ;
    this.einput = this.inp ;
  },

  bkset: function () {
    // set backtrack context on stack
    this.stack[this.stackframe + 3] = this.inp ;           // input position
    this.stack[this.stackframe + 4] = this.outbuf.length ; // output position
    this.stack[this.stackframe + 5] = this.token ;         // current token
  },

  bkclear: function () {
    // clear backtrack context on stack
    this.stack[this.stackframe + 3] = -1 ; // input position
    this.stack[this.stackframe + 4] = -1 ; // output position
    this.stack[this.stackframe + 5] = '' ; // current token
  },

  bkrestore: function () {
    // restore context for backtracking
    this.eflag = false ;
    this.inp = this.stack[this.stackframe + 3] ;           // input position
    this.outbuf = this.outbuf.substring(0,this.stack[this.stackframe + 4]) ; // output position
    this.token = this.stack[this.stackframe + 5] ;         // current token
  }

}
