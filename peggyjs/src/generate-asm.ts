import { parse } from "../pegjs-parser";
import * as fs from "fs"

const grammar = fs.readFileSync("test.meta", "utf-8");
const result = parse(grammar);

type Location = {
	source: string,
	start: {
		offset: number,
		line: number,
		column: number
	},
	end: {
		offset: number,
		line: number,
		column: number
	}
}

type OneOrMore = {
	type: "one_or_more",
	expression: Expression,
	location: Location
}

type Sequence = {
	type: "sequence",
	elements: Expression[]
}

type Class = {
	type: "class",
	parts: ([string, string] | string)[],
	inverted: boolean,
	ignoreCase: boolean,
	location: Location
}

type RuleRef = {
	type: "rule_ref",
	name: string,
	location: Location
}

type Expression = Sequence | RuleRef | ZeroOrMore | Literal | Group | Repeated;

type Choice = {
	type: "choice",
	alternatives: Expression[],
	location: Location
}

type Literal = {
	type: "literal",
	value: string,
	ignoreCase: boolean,
	location: Location
}

type ZeroOrMore = {
	type: "zero_or_more",
	expression: Group,
	location: Location
}

type Group = {
	type: "group",
	expressipn: Expression,
	location: Location
}

type Repeated = {
	type: "repeated",
	min: null | Variable,
	max: null | Variable,
	location: Location,
	expression: RuleRef,
	delimiter: null,
}

type Variable = {
	type: "variable",
	value: string,
	location: Location
}

const visitors = {
	rule(node: {
		name: string,
		nameLocation: Location,
		arguments: any[],
		expression: Expression,
		location: Location
	}) {
		label(`${node.name}`)
		visit(node.expression.type, node.expression)
	},
	one_or_more(node: OneOrMore) {

	},
	sequence(node: Sequence) {
		visitChildren(node.elements)
	},
	choice(node: Choice) {
		visitChildren(node.alternatives)
		out("cmp eax, 0")
		out("jne")
	},
	class(node: Class) {

	},
	rule_ref(node: RuleRef) {
		
	},
	literal(node: Literal) {
		
	},
	zero_or_more(node: ZeroOrMore) {
		
	},
	group(node: Group) {
		
	},
	repeated(node: Repeated) {
		
	},
	variable(node: Variable) {

	}
}


function out(raw: string) {
	process.stdout.write("  " + raw + "\n");
}

function label(label: string) {
	process.stdout.write(label + ":\n")
}

function visit(type: keyof typeof visitors, node: Parameters<typeof visitors[keyof typeof visitors]>[0]) {
	if (!(type in visitors)) {
		throw new Error(`Invalid type '${type}'`)
	}

	visitors[type].call(undefined, node);
}

function visitChildren(nodes: any) {
	nodes.forEach((child: any) => {
		visit(child.type, child)
	});
}

visitChildren(result.rules)
