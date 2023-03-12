#!/usr/bin/env node

import * as fs from "fs";
import {
	masmcompile
} from "./lib/index.js";

if (process.argv.length < 3) {
	console.log('Usage: meta <compiler assembly code>');
	process.exit(1);
}

var assembly = fs.readFileSync(process.argv[2], 'utf-8');
var compiled = masmcompile(assembly);
console.log(compiled)