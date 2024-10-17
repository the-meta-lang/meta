import * as fs from "fs";

interface NodeTypes {
	Program: Program;
	RuleDeclaration: RuleDeclaration;
	OrExpression: OrExpression;
	Identifier: Identifier;
	TreeDefinition: TreeDefinition;
	ObjectBlock: ObjectBlock;
	Property: Property;
}

type VisitorCallback<T extends Node> = (this: Visitor, node: T) => string;

class Visitor {
	private map: Map<string, VisitorCallback<any>> = new Map();
	public on<T extends keyof NodeTypes>(
		type: T,
		callback: VisitorCallback<NodeTypes[T]>
	): void {
		if (this.map.has(type)) {
			throw new Error(
				"Only one listener should be registered per node to ensure proper return values."
			);
		}

		this.map.set(type, callback);
	}

	public visit(node: Node) {
		if (!this.map.has(node.type)) {
			throw new Error(
				`No callback registered for node of type '${node.type}'`
			);
		}

		const callback = this.map.get(node.type) as VisitorCallback<any>;
		const result = callback.call(this, node);

		return result;
	}
}

// AST Node Base Class
abstract class Node {
	abstract type: string;

	static fromJSON(json: any): Node {
		switch (json.type) {
			case "Program":
				return new Program(json.body.map(Node.fromJSON));
			case "RuleDeclaration":
				return new RuleDeclaration(
					json.rule,
					json.arguments.map(Node.fromJSON),
					json.body.map(Node.fromJSON)
				);
			case "OrExpression":
				return new OrExpression(
					Node.fromJSON(json.left),
					Node.fromJSON(json.right)
				);
			case "Identifier":
				return new Identifier(json.name);
			case "TreeDefinition":
				return new TreeDefinition(Node.fromJSON(json.body));
			case "ObjectBlock":
				return new ObjectBlock(json.properties.map(Node.fromJSON));
			case "Property":
				return new Property(
					json.shorthand,
					Node.fromJSON(json.key),
					Node.fromJSON(json.value)
				);
			default:
				throw new Error(`Unknown node type: ${json.type}`);
		}
	}
}

// AST Node Classes
class Program extends Node {
	type = "Program";
	body: Node[];

	constructor(body: Node[]) {
		super();
		this.body = body;
	}
}

class RuleDeclaration extends Node {
	type = "RuleDeclaration";
	rule: string;
	arguments: Node[];
	body: Node[];

	constructor(rule: string, args: Node[], body: Node[]) {
		super();
		this.rule = rule;
		this.arguments = args;
		this.body = body;
	}
}

class OrExpression extends Node {
	type = "OrExpression";
	left: Node;
	right: Node;

	constructor(left: Node, right: Node) {
		super();
		this.left = left;
		this.right = right;
	}
}

class Identifier extends Node {
	type = "Identifier";
	name: string;

	constructor(name: string) {
		super();
		this.name = name;
	}
}

class TreeDefinition extends Node {
	type = "TreeDefinition";
	body: Node;

	constructor(body: Node) {
		super();
		this.body = body;
	}
}

class ObjectBlock extends Node {
	type = "ObjectBlock";
	properties: Node[];

	constructor(properties: Node[]) {
		super();
		this.properties = properties;
	}
}

class Property extends Node {
	type = "Property";
	shorthand: boolean;
	key: Node;
	value: Node;

	constructor(shorthand: boolean, key: Node, value: Node) {
		super();
		this.shorthand = shorthand;
		this.key = key;
		this.value = value;
	}
}

const remap: Map<string, string> = new Map();
let i = 0;

function resolveRemappedName(name: string): string {
	if (remap.has(name)) {
		return remap.get(name) as string;
	}

	let remapped = `s${i++}`;

	remap.set(name, remapped);

	return remapped;
}

// Concrete Visitor Implementation
const visitor = new Visitor();

visitor.on("Program", (program) => {
	for (const stmt of program.body) {
		console.log(visitor.visit(stmt));
	}
	return "";
});

visitor.on("RuleDeclaration", (ruleDecl) => {
	const results = ruleDecl.body.map((stmt) => visitor.visit(stmt));

	const keys = Array.from(remap.values());

	return `func _${ruleDecl.rule}(ctx *Context) (bool, Match) {
	var match Match
	var ok bool

	${keys.map((key) => `var ${key} []Match`).join("\n")}

	${results.join("\n")}
	}`;
});

visitor.on("OrExpression", (orExpr) => {
	let output = [];
	if (orExpr.left instanceof Identifier) {
		let remapped = resolveRemappedName(orExpr.left.name);
		output.push(
			`ok, m = _${orExpr.left.name}(ctx)`,
			`if ok { ${remapped} = append(${remapped}, m)\ncontinue }`
		);
	}

	if (orExpr.right instanceof Identifier) {
		let remapped = resolveRemappedName(orExpr.right.name);
		output.push(
			`ok, m = _${orExpr.right.name}(ctx)`,
			`if ok { ${remapped} = append(${remapped}, m)\ncontinue }`
		);
	}

	return output.join("\n");
});

visitor.on("Identifier", (identifier) => {
	return resolveRemappedName(identifier.name);
});

visitor.on("TreeDefinition", (treeDef) => {
	return `match.Tree = Node{${visitor.visit(treeDef.body)}}`;
});

visitor.on("ObjectBlock", (objBlock) => {
	let output: string[] = [];
	for (const prop of objBlock.properties) {
		output.push(visitor.visit(prop));
	}
	return output.join(", ");
});

visitor.on("Property", (property) => {
	if (!(property.key instanceof Identifier)) {
		throw new Error("Expected identifier");
	}

	return `"${property.key.name}": ${visitor.visit(property.value)}`;
});

const jsonData = fs.readFileSync("ast.json", "utf8");
const jsonObject = JSON.parse(jsonData);
const ast = Node.fromJSON(jsonObject);

visitor.visit(ast);
