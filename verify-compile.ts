import * as fs from "fs";
import { MetaCompiler } from "./src";

if (process.argv.length < 4) {
	console.log('Usage: meta <compiler assembly code> <grammar>');
	process.exit(1);
}

fs.watch(import.meta.dir, { recursive: true }, (event, filename) => {
	let assembly = fs.readFileSync(process.argv[2], 'utf-8');
	let compiler = new MetaCompiler(assembly);
	let grammar = fs.readFileSync(process.argv[3], 'utf-8');

	compiler.init(grammar, {
		debugMode: false,
		emitWhitespace: true
	})

	try {
		const { output } = compiler.compile(process.argv[3])

		let newCompiler = new MetaCompiler(output);

		newCompiler.init(grammar, {
			debugMode: false,
			emitWhitespace: true
		})

		const { output: newOutput } = newCompiler.compile(process.argv[3])

		fs.writeFileSync(process.argv[2], newOutput, 'utf-8')
		fs.writeFileSync(process.argv[2] + '.backup', output, 'utf-8')
	} catch(e) {
		console.log(e)
	}
})