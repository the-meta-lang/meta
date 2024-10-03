import { readFileSync, writeFileSync } from "fs";
import { formatError, getLineAndColumnFromLoc, unravelCallstack } from "./error-formatter";
import { Command } from "commander";
import {join} from "path";
import { tmpdir } from "os"
import crypto from "crypto";

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
						error("Compilation failed: " + file);
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

program.command("test")
.argument("<compiler>", "Compiler file")
.argument("<grammar>", "The grammar to build the compiler from that is to be tested.")
.argument("<input>", "The file to test the compiler against.")
.option("-o, --output <output>", "Output file", undefined)
.action(async (compiler, grammar, input, options) => {
	const cwd = process.cwd();

	const { compile } = await import(join(cwd, compiler));
	const grammarFile = readFileSync(join(cwd, grammar), "utf-8");

	const { outbuf: result, eflag: error, inbuf: inputBuffer, erule, inp: loc, parsetree, __SCOPE__, stack} = compile(grammarFile);

	if (error) {
		console.error("Compilation failed: " + compiler);
		// Highlight the line where it failed

		formatError(inputBuffer.toString().split("\n"), getLineAndColumnFromLoc(loc, inputBuffer.toString()), process.stdout.getWindowSize()[0])
		unravelCallstack(stack)

		process.exit(1)
	}

	notice("Initial compilation successful");
	// Write the compiled program to a file
	const outputFile = options.output ?? join(tmpdir(), crypto.randomBytes(16).toString("hex") + ".ts");
	writeFileSync(outputFile, result.toString(), "utf-8");

	notice("Compiled program written to " + outputFile);

	// Run the compiled program
	const { compile: compiledProgram } = await import(outputFile);

	const inputBufferFile = readFileSync(join(cwd, input), "utf-8");

	const { outbuf: result2, eflag: error2, inbuf: inputBuffer2, erule: erule2, inp: loc2, parsetree: parsetree2, __SCOPE__: __SCOPE2, stack: stack2} = compiledProgram(inputBufferFile);

	if (error2) {
		error("Compilation failed: " + compiler);
		// Highlight the line where it failed

		formatError(inputBuffer2.toString().split("\n"), getLineAndColumnFromLoc(loc2, inputBuffer2.toString()), process.stdout.getWindowSize()[0])
		unravelCallstack(stack2)

		process.exit(1)
	}

	success("Compiled successfully");
	notice("Output: ")

	console.log(result2.toString());
})

function notice(str: string) {
	console.log(`\x1b[1mmetax\x1b[0m \x1b[36mnotice\x1b[0m ${str}`);
}

function error(str: string) {
	error(`\x1b[1mmetax\x1b[0m \x1b[31merror\x1b[0m ${str}`);
}

function success(str: string) {
	console.log(`\x1b[1mmetax\x1b[0m \x1b[32msuccess\x1b[0m ${str}`);
}

program.parse();