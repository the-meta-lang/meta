function interpreter(input) {
    var stack = [];
    var names = {};
    var currentVariableName = "";
    var lines = input.split("\n").map(function (x) { return x.trim(); });
    for (var _i = 0, lines_1 = lines; _i < lines_1.length; _i++) {
        var line = lines_1[_i];
        var parts = line.split(" ", 2);
        var instruction = parts[0];
        var parameters = [];
        if (parts.length > 1) {
            parameters = parts[1].split(",");
        }
        if (instruction == "ADR") {
            currentVariableName = parameters[0];
        }
        else if (instruction == "LDC") {
            stack.push(parseFloat(parameters[0]));
        }
        else if (instruction == "ADD") {
            var x = stack.pop(), y = stack.pop();
            stack.push(y + x);
        }
        else if (instruction == "STO") {
            names[currentVariableName] = stack.pop();
        }
        else if (instruction == "LDN") {
            stack.push(names[parameters[0]]);
        }
        else if (instruction == "MUL") {
            var x = stack.pop(), y = stack.pop();
            stack.push(y * x);
        }
        else if (instruction == "POW") {
            var x = stack.pop(), y = stack.pop();
            stack.push(Math.pow(y, x));
        }
        else if (instruction == "DIV") {
            var x = stack.pop(), y = stack.pop();
            stack.push(y / x);
        }
        else if (instruction == "NEG") {
            stack.push(-stack.pop());
        }
    }
    return names;
}
var fs = require("fs");
var result = interpreter(fs.readFileSync("./test/results/calculator.o").toString());
console.log(result);
