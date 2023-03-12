import { Scanner } from "./Scanner.js";
import { Builder } from "./Builder.js";
import { parse } from "./parse.js";
import { error } from "./error-handler.js";
import { InstructionSet, } from "./types.js";
var MetaCompiler = (function () {
    function MetaCompiler(assembly) {
        this.assembly = assembly;
        this.instructionCount = 0;
        this.outputStack = [];
        this.environment = {};
        this.flags = [];
        this.program = parse(this.assembly);
    }
    MetaCompiler.prototype.step = function () {
        if (this.done) {
            return;
        }
        var instr = this.program[this.pc];
        if (this.options.debugMode) {
            console.log(instr);
        }
        if (!instr || instr.length == 0) {
            this.error("malformed instruction: ".concat(instr));
        }
        if (!this[instr[0]]) {
            this.error("call to undefined instruction: ".concat(instr[0]));
        }
        this[instr[0]](instr[1]);
        this.instructionCount++;
        var lineno = this.input.getLine();
        var colno = this.input.getColumn();
        var isJumpInstruction = instr[0] == InstructionSet.JMP ||
            instr[0] == InstructionSet.B ||
            (instr[0] == InstructionSet.BF && !this.branch) ||
            (instr[0] == InstructionSet.BT && this.branch);
        var isReturnInstruction = instr[0] == InstructionSet.RET;
        return {
            lineno: lineno,
            colno: colno,
            pc: this.pc,
            instruction: instr,
            metadata: {
                isJumpInstruction: isJumpInstruction,
                jumpAddressLabel: isJumpInstruction ? instr[1] : "",
                jumpAddress: isJumpInstruction ? this.program[instr[1]] : 0,
                isReturnInstruction: isReturnInstruction,
            },
        };
    };
    MetaCompiler.prototype.init = function (content, options) {
        this.output = new Builder();
        this.pc = 0;
        this.stack = [];
        this.nextGN1 = 0;
        this.nextGN2 = 0;
        this.done = false;
        this.branch = false;
        this.input = new Scanner(content);
        this.instructionCount = 0;
        this.options = Object.assign({
            debugMode: false,
            performanceMetrics: false,
            emitWhitespace: true,
        }, options);
    };
    MetaCompiler.prototype.compile = function (source) {
        if (source === void 0) { source = ""; }
        var timeStarted = Number(process.hrtime.bigint()) / 1000000;
        this.source = source;
        while (this.step()) { }
        var performance = null;
        var totalInstructions = this.assembly.split("\n").length;
        if (this.options.performanceMetrics) {
            var timeEnded = Number(process.hrtime.bigint()) / 1000000;
            performance = {
                time: timeEnded - timeStarted,
                timeStarted: timeStarted,
                timeEnded: timeEnded,
                instructionCount: this.instructionCount,
                instructionPercentage: (this.instructionCount / totalInstructions) * 100,
            };
        }
        return {
            output: this.output.text,
            metrics: {
                performance: performance,
            },
            environment: this.environment,
        };
    };
    MetaCompiler.prototype.error = function (message) {
        error(message, this.input.originalText, this.source, this.input.getLine(), this.input.getColumn());
    };
    MetaCompiler.prototype.TST = function (string) {
        this.input.blanks();
        this.branch = this.input.match(string);
        this.pc++;
    };
    MetaCompiler.prototype.HEX = function () {
        this.input.blanks();
        this.branch = this.input.match(/^[0x]?[0-9A-Fa-f]+/);
        this.pc++;
    };
    MetaCompiler.prototype.USE = function (name) {
        this.usedVariable = name;
        this.pc++;
    };
    MetaCompiler.prototype.INIT = function (type) {
        if (type == "ARRAY") {
            this.environment[this.usedVariable] = [];
        }
        this.pc++;
    };
    MetaCompiler.prototype.PUSHI = function () {
        this.environment[this.usedVariable].push(this.input.lastMatch);
        this.pc++;
    };
    MetaCompiler.prototype.PUSHO = function () {
        var _a;
        (_a = this.environment[this.usedVariable]).push.apply(_a, this.outputStack);
        this.outputStack = [];
        this.pc++;
    };
    MetaCompiler.prototype.PUSHS = function (str) {
        this.environment[this.usedVariable].push(str);
        this.pc++;
    };
    MetaCompiler.prototype.CVTHEXO = function () {
        var value = this.outputStack.pop();
        var hex = parseInt(value).toString(16).padStart(4, "0");
        this.outputStack.push(hex.substring(0, 2), hex.substring(2, 4));
        this.pc++;
    };
    MetaCompiler.prototype.CV = function (name) {
        if (!this.environment.hasOwnProperty(name)) {
            this.error("Variable can not be referenced before its assignment: " + name);
        }
        this.output.copy(this.environment[name]);
        this.pc++;
    };
    MetaCompiler.prototype.LDV = function (name) {
        if (!this.environment.hasOwnProperty(name)) {
            this.error("Variable can not be referenced before its assignment: " + name);
        }
        this.stack.push(name);
        this.pc++;
    };
    MetaCompiler.prototype.OUTMOV = function (str) {
        this.outputStack.push(str);
        this.pc++;
    };
    MetaCompiler.prototype.CIOUT = function () {
        this.outputStack.push(this.input.lastMatch);
        this.pc++;
    };
    MetaCompiler.prototype.CO = function () {
        this.output.copy(this.outputStack.join(""));
        this.outputStack = [];
        this.pc++;
    };
    MetaCompiler.prototype.ID = function () {
        this.input.blanks();
        this.branch = this.input.match(/^[_a-zA-Z][$_a-zA-Z0-9]*/);
        this.pc++;
    };
    MetaCompiler.prototype.NUM = function () {
        this.input.blanks();
        this.branch = this.input.match(/^-?[0-9]+([,.][0-9]+)*/);
        this.pc++;
    };
    MetaCompiler.prototype.ROL = function () {
        this.branch = this.input.match(/^.*?(?:\n|\r\n)/);
        this.pc++;
    };
    MetaCompiler.prototype.NOT = function (exclude) {
        exclude = exclude.replace(/[.*+?^${}()|[\]\\\/]/g, "\\$&");
        this.branch = this.input.match(new RegExp("[^".concat(exclude, "]*")));
        this.pc++;
    };
    MetaCompiler.prototype.SR = function () {
        this.input.blanks();
        this.branch = this.input.match(/^["][^"]*["]/);
        this.pc++;
    };
    MetaCompiler.prototype.JMP = function (aaa) {
        this.stack.push(this.pc + 1);
        this.stack.push(null);
        this.stack.push(null);
        this.pc = this.program[aaa];
    };
    MetaCompiler.prototype.R = function () {
        if (this.stack.length === 0) {
            this.END();
        }
        this.stack.pop();
        this.stack.pop();
        this.pc = this.stack.pop();
    };
    MetaCompiler.prototype.SET = function () {
        this.branch = true;
        this.pc++;
    };
    MetaCompiler.prototype.B = function (aaa) {
        this.pc = this.program[aaa];
    };
    MetaCompiler.prototype.BT = function (aaa) {
        if (this.branch) {
            this.pc = this.program[aaa];
        }
        else {
            this.pc++;
        }
    };
    MetaCompiler.prototype.BF = function (aaa) {
        if (!this.branch) {
            this.pc = this.program[aaa];
        }
        else {
            this.pc++;
        }
    };
    MetaCompiler.prototype.BE = function () {
        if (!this.branch) {
            this.error("BRANCH ERROR Executed - Something is Wrong!");
        }
        this.pc++;
    };
    MetaCompiler.prototype.ERR = function (message) {
        this.error(message);
    };
    MetaCompiler.prototype.WARN = function (message) {
        this.issues.push({
            message: message,
            pc: this.pc,
            lineno: this.input.getLine(),
            colno: this.input.getColumn(),
        });
    };
    MetaCompiler.prototype.CL = function (string) {
        this.output.copy(string + " ");
        this.pc++;
    };
    MetaCompiler.prototype.CI = function () {
        this.output.copy(this.input.lastMatch);
        this.pc++;
    };
    MetaCompiler.prototype.GN1 = function () {
        var gn2 = this.stack.pop();
        var gn1 = this.stack.pop();
        if (gn1 === null) {
            gn1 = this.nextGN1++;
        }
        this.stack.push(gn1);
        this.stack.push(gn2);
        this.output.copy("A" + gn1 + " ");
        this.pc++;
    };
    MetaCompiler.prototype.GN2 = function () {
        var gn2 = this.stack.pop();
        if (gn2 === null) {
            gn2 = this.nextGN2++;
        }
        this.stack.push(gn2);
        this.output.copy("B" + gn2 + " ");
        this.pc++;
    };
    MetaCompiler.prototype.LB = function () {
        this.output.label();
        this.pc++;
    };
    MetaCompiler.prototype.OUT = function () {
        if (this.options.emitWhitespace) {
            this.output.newLine();
        }
        this.pc++;
    };
    MetaCompiler.prototype.ADR = function (ident) {
        this.pc = this.program[ident];
    };
    MetaCompiler.prototype.END = function () {
        this.done = true;
    };
    return MetaCompiler;
}());
export { MetaCompiler };
