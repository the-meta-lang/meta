var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
var parse = function (text) {
    var program = [];
    var lines = text.split("\n");
    for (var _i = 0, lines_1 = lines; _i < lines_1.length; _i++) {
        var line = lines_1[_i];
        if (line.trim().length == 0) {
            continue;
        }
        if (line[0] == " ") {
            program.push(parseInstruction(line));
        }
        else {
            program[parseLabel(line)] = program.length;
        }
    }
    return program;
};
function parseInstruction(line) {
    var instruction = line.trim();
    var idx = instruction.indexOf(" ");
    if (idx === -1) {
        return [instruction];
    }
    else {
        var instr = instruction.substring(idx).trim();
        var args = [];
        var inString = false;
        var lastWasEscapeChar = false;
        var str = "";
        for (var i = 0; i < instr.length; i++) {
            var char = instr[i];
            if (char == "\\" && !lastWasEscapeChar) {
                lastWasEscapeChar = true;
                continue;
            }
            if (char == "\"" && inString && !lastWasEscapeChar) {
                inString = false;
                continue;
            }
            else if (char == "\"" && !inString) {
                inString = true;
                continue;
            }
            if (char == "," && !inString) {
                args.push(str.trim());
                str = "";
                continue;
            }
            lastWasEscapeChar = false;
            str += char;
        }
        args.push(str.trim());
        return __spreadArray([instruction.slice(0, idx)], args, true);
    }
}
function parseLabel(line) {
    return line.trim();
}
export { parse };
