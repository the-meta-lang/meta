/**
 * @author Letsmoe
 * @email moritz.utcke@gmx.de
 * @create date 2023-02-21 17:07:52
 * @modify date 2023-02-21 17:07:52
 * @desc Every preprocessor command starts with a "#" symbol at the start of the line.
 * This Preprocessor goes through all the lines and executes the preprocessor commands that it finds.
 * After that, it will remove them from the original content and return the preprocessed piece of text.
 */
import * as fs from "fs";
import * as path from "path";

export function preprocess(source: string, file: string): string[] {
	const lines = source.replace("\r\n", "\n").split("\n");
	const result = [];

	for (let i = 0; i < lines.length; i++) {
		const line = lines[i];
		
		if (line.startsWith("#")) {
			// Preprocessor instruction, remove it from the output and parse it accordingly.
			let [instruction, parameters] = line.split(" ", 1);
			if (instruction == "include") {
				// Interpret the parameters as a single string.
				let filePath = parameters.trim().replace("\"", "").replace("'", "");
				// Adjust the included file path to the current file.
				filePath = path.join(path.dirname(file), filePath);
				if (!fs.existsSync(filePath)) {
					throw new Error("Can't read source, file does not exist: " + filePath)
				}
				let content = fs.readFileSync(filePath, "utf-8")
				result.push(...preprocess(content, filePath))
			}
		} else {
			result.push(line.trim());
		}
	}

	return result;
}