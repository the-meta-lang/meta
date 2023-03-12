import * as fs from "fs";
import * as path from "path";
import { MetaCompiler } from "./lib/index.js";

if (process.argv.length < 3) {
	console.log('Usage: node compile.js <compiler assembly code>');
	process.exit(1);
}

const dir = "./tests/";
const grammarFiles = fs.readdirSync(dir);
const assembly = fs.readFileSync(process.argv[2], "utf-8");
const compiler = new MetaCompiler(assembly);

for (const grammarFile of grammarFiles) {
	if (grammarFile == "gyro.test.meta") {
		continue;
	}
	console.clear();
	console.log("Starting Compilation: " + grammarFile)
	let name = path.basename(grammarFile, path.extname(grammarFile));
	const grammar = fs.readFileSync(path.join(dir, grammarFile), "utf-8");
	compiler.init(grammar, {debugMode: false});
	const {output: compiledGrammar, metrics } = compiler.compile(dir + grammarFile);

	// Now compile the code
	// Check if it exists first.
	if (!compiledGrammar) {
		console.log("Failed compiling grammar: " + grammarFile);
		process.exit(1);
	}

	fs.writeFileSync(path.join("./bin/", name + ".o"), compiledGrammar);

	console.log("Compiled Grammar successfully: " + grammarFile)
}