import * as fs from "fs";
import * as path from "path";
export function preprocess(source, file) {
    var lines = source.replace("\r\n", "\n").split("\n");
    var result = [];
    for (var i = 0; i < lines.length; i++) {
        var line = lines[i];
        if (line.startsWith("#")) {
            var _a = line.split(" ", 1), instruction = _a[0], parameters = _a[1];
            if (instruction == "include") {
                var filePath = parameters.trim().replace("\"", "").replace("'", "");
                filePath = path.join(path.dirname(file), filePath);
                if (!fs.existsSync(filePath)) {
                    throw new Error("Can't read source, file does not exist: " + filePath);
                }
                var content = fs.readFileSync(filePath, "utf-8");
                result.push.apply(result, preprocess(content, filePath));
            }
        }
        else {
            result.push(line.trim());
        }
    }
    return result;
}
