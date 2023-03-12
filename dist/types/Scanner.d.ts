declare class Scanner {
    text: string;
    lastMatch: string;
    matches: string[];
    cursor: number;
    originalText: string;
    constructor(text: string);
    getLine(): number;
    getLines(): string[];
    getColumn(): number;
    blanks(): void;
    match(pattern: RegExp | string): boolean;
    matchRegularExpression(re: RegExp): boolean;
    matchString(str: string): boolean;
}
export { Scanner };
//# sourceMappingURL=Scanner.d.ts.map