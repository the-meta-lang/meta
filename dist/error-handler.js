import chalk from "chalk";
var error = function (message, text, source, lineno, colno) {
    var lineIndex = lineno - 1;
    console.group("An Error Occured in your Application!");
    console.error("[ERROR]  ", message);
    console.error("[SOURCE] ", source);
    console.error("[LINE]   ", lineno);
    console.error("[COLUMN] ", colno);
    console.groupCollapsed("Context");
    var lines = text.split("\n");
    var startLine = Math.max(lineIndex - 5, 0);
    var endLine = Math.min(lineIndex + 5, lines.length - 1);
    for (var i = startLine; i <= endLine; i++) {
        var text_1 = "".concat(i + 1, ": ").concat(lines[i]);
        if (i == lineIndex) {
            console.log(chalk.red(text_1));
            console.log(" ".repeat(colno + i.toString().length + 1) + "^");
        }
        else {
            console.log(text_1);
        }
    }
    console.groupEnd();
    console.groupCollapsed("Advice");
    console.warn("Here is some advice to help you resolve this error: ");
    var instruction = lines[lineIndex].trim().split(" ")[0];
    var instructionInfo = INSTRUCTIONS[instruction];
    if (instructionInfo) {
        console.warn(chalk.bgWhite.black(instructionInfo));
    }
    console.groupEnd();
    process.exit(1);
};
var INSTRUCTIONS = {
    "BF": "BRANCH IF FALSE - Branch to given location if `branch` flag is `false`, otherwise continue in sequence.",
    "BT": "BRANCH IF TRUE - Branch to given location if `branch` flag is `true`, otherwise continue in sequence.",
    "BE": "BRANCH TO ERROR IF FALSE - Branch to error message if `branch` flag is `false`, otherwise continue in sequence.",
};
export { error };
