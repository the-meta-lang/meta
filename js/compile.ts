import { readFileSync, writeFileSync } from "fs";
import { formatError, getLineAndColumnFromLoc } from "./error-formatter";

const args = process.argv.slice(2);

const runAmountTimes = args.length > 0 ? parseInt(args[0]) : 1;

const __dirname = import.meta.dirname;

// Read the meta file from storage

const meta = readFileSync(__dirname + "/meta.meta", "utf-8");

// If compilation was successful, copy the output program to a file, import it and try running it and see if it works
async function testCompiler(file: string, i = 0) {
	if (i >= runAmountTimes) {
		return;
	}

	return new Promise((resolve, reject) => {
		import(file).then(async (module) => {
			console.log(`Running compiled program (${i + 1})...`);
			const { outbuf: result, eflag: error, inbuf: input, inp: loc} = module.compile(meta)

			if (error) {
					console.error("Compilation failed: " + file);
					// Highlight the line where it failed

					formatError(input.split("\n"), getLineAndColumnFromLoc(loc, input), process.stdout.getWindowSize()[0])
					
					process.exit(1)
			}

			console.log("Compiled successfully");
			console.log("Generated Parse Tree:");
			console.log(JSON.stringify(module.parsetree, null, 2));
			
			
			writeFileSync(__dirname + "/out.js", result, "utf-8");
			await testCompiler(__dirname + "/out.js", i + 1);
			resolve(true)
		}).catch((err) => {
			console.error("Error running compiled program: " + err);
			reject()
		});
	})
}

await testCompiler(__dirname + "/meta.js");