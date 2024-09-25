import { readFileSync, writeFileSync } from "fs";
import { formatError, getLineAndColumnFromLoc, unravelCallstack } from "./error-formatter";
import { Command } from "commander";

const program = new Command("metax");


program.command("compile")
.argument("<compiler>", "Compiler file")
.argument("<file>", "File to compile")
.option("-c, --count <count>", "The amount of times to run the compiled program")
.option("-o, --output <output>", "Output file", undefined)
.action(async (compiler, file, options) => {
	const cwd = process.cwd();
	// Read the meta file from storage
	
	const meta = readFileSync(`${cwd}/${file}`, "utf-8");
	
	// If compilation was successful, copy the output program to a file, import it and try running it and see if it works
	async function testCompiler(file: string, i = 0) {
		if (i >= options.count) {
			return;
		}
	
		return new Promise((resolve, reject) => {
			import(file).then(async (module) => {
				console.log(`Running compiled program (${i + 1})...`);
				const { outbuf: result, eflag: error, inbuf: input, erule, inp: loc, parsetree, __SCOPE__, stack} = module.compile(meta)
	
				if (error) {
						console.error("Compilation failed: " + file);
						// Highlight the line where it failed
	
						formatError(input.toString().split("\n"), getLineAndColumnFromLoc(loc, input.toString()), process.stdout.getWindowSize()[0])
						unravelCallstack(stack)

						process.exit(1)
				}
	
				console.log("Compiled successfully");
				console.log("Generated Parse Tree:");
				console.log(JSON.stringify(parsetree, null, 2));
				
				if (options.output !== undefined) {
					writeFileSync(`${cwd}/${options.output}`, result.toString(), "utf-8");
					await testCompiler(`${cwd}/${options.output}`, i + 1);
				}
				resolve(true)
			}).catch((err) => {
				console.error("Error running compiled program: " + err);
				reject()
			});
		})
	}
	
	await testCompiler(`${cwd}/${compiler}`);
})

program.parse();