import { spawn, spawnSync } from 'bun';
import { expect, test, describe } from 'bun:test';
import path from 'path';
import { assemble } from './utils/assemble';
import { compile } from './utils/compile';
import * as fs from "fs";

const tests = fs.readdirSync(path.join(import.meta.dir, "./assets"))

/**
 * This file runs all tests automatically.
 * Since all tests follow the same schema
 * 	- grammar.meta (Contains the grammar specification for that specific test)
 * 	- input.txt (Contains the input for the test)
 * 	- output.txt (Contains the expected output for the test)
 * We can just loop through all of them and run the tests.
 * 		- Compile the grammar.meta file
 * 		- Assemble the output
 * 		- Run the executable
 * 		- Compare the output with the expected output
 */

for (const testName of tests) {
	describe(`${testName}`, async () => {
		const root = path.join(import.meta.dir, "./assets", testName);
		const tmp = path.join(import.meta.dir, "./tmp", testName);

		const grammarFilePath = path.join(root, "grammar.meta");
		const inputFilePath = path.join(root, "input.txt");
		const outputFilePath = path.join(root, "output.txt");

		const compiledGrammar = await compile(grammarFilePath);
	
		test("should compile without errors", async () => {
			expect(compiledGrammar.length).toBeGreaterThan(0);
		})
	
		// Write the output to a file
		const grammarAssembly = path.join(tmp, "grammar.asm");
		await Bun.write(grammarAssembly, compiledGrammar);

	
		test("should be buildable by nasm", async () => {
			const executablePath = await assemble(grammarAssembly);

			test("should be executable and produce the defined output", async () => {
				// Copy the test file to the tmp directory
				const inputFileContent = await Bun.file(inputFilePath).text()
				await Bun.write(path.join(tmp, "input.txt"), inputFileContent);
		
				const process = spawnSync([executablePath, inputFilePath], {
					stdout: "pipe"
				});
				
				const exitCode = process.exitCode;
		
				expect(exitCode).toBe(0);
		
				// Check the output
		
				const output = (await new Response(process.stdout).text()).trim();
				const expectedOutput = await Bun.file(outputFilePath).text();
				
		
				expect(output).toBe(expectedOutput);
			})
		})
	});
}