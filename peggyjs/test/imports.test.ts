import { parse } from "../pegjs-parser"
import {describe, expect, test} from "bun:test";

describe("imports", () => {
	test(`import * as text from "../text.meta"`, () => {
		const result = parse(`import * as text from "../text.meta"`, {
			trace: false
		})

		expect(result.imports.length).toEqual(1)
		expect(result.imports[0].type).toEqual("grammar_import")
		expect(result.imports[0].from.module).toEqual("../text.meta")
		expect(result.imports[0].what.length).toEqual(1)
		expect(result.imports[0].what[0].binding).toEqual("text")
	})
})