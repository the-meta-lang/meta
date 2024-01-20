#!/usr/bin/env node

import * as fs from "fs";
import { MetaCompiler } from "./src";

if (process.argv.length < 4) {
	console.log('Usage: meta <compiler assembly code> <grammar>');
	process.exit(1);
}

var assembly = fs.readFileSync(process.argv[2], 'utf-8');
var compiler = new MetaCompiler(assembly);
var grammar = fs.readFileSync(process.argv[3], 'utf-8');
compiler.init(grammar, {
	debugMode: false,
	emitWhitespace: true
})
console.log(compiler.compile(process.argv[3]).output);