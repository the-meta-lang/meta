import chalk from "chalk";

const error = function (message: string, text: string, source: string, lineno: number, colno: number) {
	const lineIndex = lineno - 1;
	//console.clear();
	console.group("An Error Occured in your Application!");
	console.error("[ERROR]  ", message);
	console.error("[SOURCE] ", source);
	console.error("[LINE]   ", lineno);
	console.error("[COLUMN] ", colno);

	console.groupCollapsed("Context");
	const lines = text.split("\n");
	let startLine = Math.max(lineIndex - 5, 0);
	let endLine = Math.min(lineIndex + 5, lines.length - 1);
	for (let i = startLine; i <= endLine; i++) {
		let text = `${i + 1}: ${lines[i]}`;
		if (i == lineIndex) {
			console.log(chalk.red(text));
			console.log(" ".repeat(colno + i.toString().length + 1) + "^")
		} else {
			console.log(text);
		}
	}
	console.groupEnd();

	console.groupCollapsed("Advice");
	console.warn("Here is some advice to help you resolve this error: ");

	const instruction = lines[lineIndex].trim().split(" ")[0];
	const instructionInfo = INSTRUCTIONS[instruction];

	if (instructionInfo) {
		console.warn(chalk.bgWhite.black(instructionInfo));
	}

	console.groupEnd();

	process.exit(1);
}

const INSTRUCTIONS = {
	"BF": "BRANCH IF FALSE - Branch to given location if `branch` flag is `false`, otherwise continue in sequence.",
	"BT": "BRANCH IF TRUE - Branch to given location if `branch` flag is `true`, otherwise continue in sequence.",
	"BE": "BRANCH TO ERROR IF FALSE - Branch to error message if `branch` flag is `false`, otherwise continue in sequence.",
}

export { error }