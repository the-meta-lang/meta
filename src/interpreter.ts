function interpreter(input) {
	const stack = [];
	const names = {};
	var currentVariableName = "";
	const lines = input.split("\n").map(x => x.trim());

	for (const line of lines) {
		// Instructions always reach until the first space.
		const parts = line.split(" ", 2);
		const instruction = parts[0];
		let parameters = [];
		if (parts.length > 1) {
			parameters = parts[1].split(",");
		}
		if (instruction == "ADR") {
			// Initialize a variable declaration.
			currentVariableName = parameters[0];
		} else if (instruction == "LDC") {
			// Load constant
			stack.push(parseFloat(parameters[0]));
		} else if (instruction == "ADD") {
			let x = stack.pop(),
				y = stack.pop();
			stack.push(y + x);
		} else if (instruction == "STO") {
			// Store Variable
			names[currentVariableName] = stack.pop();
		} else if (instruction == "LDN") {
			// Load name
			stack.push(names[parameters[0]]);
		} else if(instruction == "MUL") {
			let x = stack.pop(),
				y = stack.pop();
			stack.push(y * x);
		} else if (instruction == "POW") {
			let x = stack.pop(),
				y = stack.pop();
			stack.push(y ** x);
		} else if (instruction == "DIV") {
			let x = stack.pop(),
				y = stack.pop();
			stack.push(y / x);
		} else if (instruction == "NEG") {
			// Negate
			stack.push(-stack.pop())
		}
	}
	return names
}


const fs = require("fs");
let result = interpreter(fs.readFileSync("./test/results/calculator.o").toString())

console.log(result)