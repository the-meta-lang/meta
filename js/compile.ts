import { readFileSync, writeFileSync } from "fs";

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
			const Compiler = module.Compiler;
			console.log(`Running compiled program (${i + 1})...`);
			const error = Compiler.compile(meta)
			const result = Compiler.outbuf;

			if (error) {
					console.error("Compilation failed: " + file);
					// Highlight the line where it failed
					const input = Compiler.inbuf as string;
					const loc = Compiler.inp as number;

					const start = Math.max(0, loc - 25);
					const end = Math.min(input.length, loc + 25);

					console.error(input.slice(start, end));
					console.error(" ".repeat(loc - start) + "^");
					
					process.exit(1)
			}

			console.log("Compiled successfully");
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