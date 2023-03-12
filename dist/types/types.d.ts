declare type Instruction = [string, string?];
interface Step {
    lineno: number;
    colno: number;
    pc: number;
    instruction: Instruction;
    metadata: Metadata;
}
interface Metadata {
    isJumpInstruction: boolean;
    jumpAddress: number;
    jumpAddressLabel: string;
    isReturnInstruction: boolean;
}
declare enum InstructionSet {
    JMP = "JMP",
    RET = "R",
    BF = "BF",
    BT = "BT",
    B = "B"
}
interface Issue {
    message: string;
    pc: number;
    lineno: number;
    colno: number;
}
interface CompilerOptions {
    debugMode?: boolean;
    performanceMetrics?: boolean;
    emitWhitespace?: boolean;
}
declare type CompilerFlags = ("p" | "d")[];
interface CompilerOutput {
    output: string;
    metrics: {
        performance?: {
            instructionCount: number;
            instructionPercentage: number;
            time: number;
            timeStarted: number;
            timeEnded: number;
        };
    };
    environment: {
        [key: string]: any;
    };
}
export { CompilerOptions, Instruction, InstructionSet, Step, Metadata, Issue, CompilerFlags, CompilerOutput };
//# sourceMappingURL=types.d.ts.map