import { CompilerFlags, CompilerOptions, CompilerOutput, Issue, Step } from "./types.js";
declare class MetaCompiler {
    private assembly;
    private input;
    private output;
    private pc;
    private stack;
    private nextGN1;
    private nextGN2;
    private done;
    private branch;
    private program;
    private source;
    private instructionCount;
    private outputStack;
    private environment;
    options: CompilerOptions;
    flags: CompilerFlags;
    issues: Issue[];
    constructor(assembly: string);
    step(): Step;
    init(content: string, options: CompilerOptions): void;
    compile(source?: string): CompilerOutput;
    private error;
    TST(string: string): void;
    HEX(): void;
    private usedVariable;
    USE(name: string): void;
    INIT(type: string): void;
    PUSHI(): void;
    PUSHO(): void;
    PUSHS(str: string): void;
    CVTHEXO(): void;
    CV(name: string): void;
    LDV(name: string): void;
    OUTMOV(str: string): void;
    CIOUT(): void;
    CO(): void;
    ID(): void;
    NUM(): void;
    ROL(): void;
    NOT(exclude: string): void;
    SR(): void;
    JMP(aaa: string): void;
    R(): void;
    SET(): void;
    B(aaa: string): void;
    BT(aaa: string): void;
    BF(aaa: string): void;
    BE(): void;
    ERR(message: string): void;
    WARN(message: string): void;
    CL(string: string): void;
    CI(): void;
    GN1(): void;
    GN2(): void;
    LB(): void;
    OUT(): void;
    ADR(ident: string): void;
    END(): void;
}
export { MetaCompiler };
//# sourceMappingURL=MetaCompiler.d.ts.map