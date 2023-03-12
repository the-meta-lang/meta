declare class Builder {
    text: string;
    copy(string: string): void;
    label(): void;
    newLine(): void;
    getProgram(): import("./types.js").Instruction[];
}
export { Builder };
//# sourceMappingURL=Builder.d.ts.map