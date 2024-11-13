import type { EnumMember, EnumType, MetaProperty } from "typescript";
import { parse } from "./parser";
import crypto from "crypto";
import { MetalsProgram, MetalsFunctionDeclaration, MetalsArgument, MetalsType, MetalsBlock, MetalsVariableDeclaration, MetalsOr, MetalsCall, MetalsIdentifier, MetalsStringLiteral, MetalsBinaryOperation } from "./metals-code-gen";

type VisitorCallback<T> = (
	walker: ParseTreeWalker<T>,
	node: { type: T } & { [key: string]: any } & any,
	scope: Scope
) => any;
class ParseTreeWalker<NodeTypes> {
	private callbacks: Map<NodeTypes, VisitorCallback<any>> = new Map();

	public on<T extends NodeTypes>(
		type: NodeTypes,
		callback: VisitorCallback<T>
	) {
		if (this.callbacks.has(type)) {
			throw new Error("A node may only have a single visitor callback.");
		}

		this.callbacks.set(type, callback);
	}

	public visit<T extends NodeTypes>(
		node: { type: T } & { [key: string]: any },
		scope: Scope
	): ReturnType<VisitorCallback<any>> {
		if (!node || !node.type || !this.callbacks.has(node.type)) {
			throw new Error(
				`No visitor implemented for node of type '${node.type}'`
			);
		}

		return this.callbacks
			.get(node.type)
			?.call(undefined, this, node, scope);
	}
}

enum ScopeType {
	Function,
	Variable,
	Constant,
}

class Scope {
	private map: Map<string, { [key: string]: any }> = new Map();

	constructor() {}

	set(name: string, type: ScopeType, properties: { [key: string]: any }) {
		this.map.set(name, {
			type,
			...properties,
		});

		return this;
	}

	get(name: string) {
		return this.map.get(name);
	}

	has(name: string) {
		return this.map.has(name);
	}

	private count: number = 0;
	counter() {
		return this.count++;
	}
}



enum NodeTypes {
	Program = "Program",
	ParseRule = "ParseRule",
	Series = "Series",
	Or = "Or",
	LiteralMatch = "LiteralMatch",
	NamedCapture = "NamedCapture",
	Reference = "Reference",
}

const walker = new ParseTreeWalker<NodeTypes>();

walker.on(NodeTypes.Program, (walker, node, scope) => {
	const body = node.body.map((n: any) => walker.visit(n, scope));

	const program = new MetalsProgram(body);

	return program;
});

type AstNode = {
	type: NodeTypes;
} & { [key: string]: any };

type ParseRule = {
	type: "ParseRule";
	id: string;
	body: AstNode;
};

walker.on(NodeTypes.ParseRule, (walker, node: ParseRule, scope) => {
	const body = walker.visit(node.body, scope);

	scope.set(node.id, ScopeType.Function, {});

	return new MetalsFunctionDeclaration(
		node.id,
		[new MetalsArgument("ctx", new MetalsType("*Context"))],
		new MetalsType("(bool, Match)"),
		new MetalsBlock([body])
	);
});

walker.on(
	NodeTypes.Or,
	(
		walker,
		node: { type: NodeTypes.Or; left: AstNode; right: AstNode },
		scope
	) => {
		const left = walker.visit(node.left, scope);
		const right = walker.visit(node.right, scope);

		return new MetalsBlock([
			new MetalsVariableDeclaration(
				(Math.random() * 16).toString(16),
				"string",
				""
			),
			new MetalsOr(left, right),
		]);
	}
);

walker.on(
	NodeTypes.Series,
	(walker, node: { type: NodeTypes.Series; body: AstNode[] }, scope) => {
		const body = node.body.map((n) => walker.visit(n, scope));

		return new MetalsBlock(body);
	}
);

walker.on(
	NodeTypes.LiteralMatch,
	(walker, node: { type: NodeTypes.LiteralMatch; value: string }) => {
		return new MetalsCall(new MetalsIdentifier("test"), [
			new MetalsStringLiteral(node.value),
		]);
	}
);

walker.on(
	NodeTypes.NamedCapture,
	(
		walker,
		node: { type: NodeTypes.NamedCapture; id: string; body: AstNode },
		scope
	) => {
		scope.set(node.id, ScopeType.Variable, {
			shortname: `s${scope.counter()}`,
		});

		const body = walker.visit(node.body, scope);

		return new MetalsBinaryOperation(
			new MetalsIdentifier(scope.get(node.id).shortname),
			"=",
			new MetalsBlock([body])
		);
	}
);

walker.on(
	NodeTypes.Reference,
	(walker, node: { type: NodeTypes.Reference; id: string }, scope) => {
		if (!scope.has(node.id)) {
			throw new Error(
				`Missing rule declaration for reference '${node.id}'`
			);
		}

		return new MetalsCall(new MetalsIdentifier(node.id), [
			new MetalsIdentifier("ctx"),
		]);
	}
);

const parsed = parse(
	'rule parse_rule = "rule"; rule token_rule = parse_rule; rule program = body:(parse_rule | token_rule);'
);

const program = walker.visit(parsed, new Scope());

console.log(program.generate());
