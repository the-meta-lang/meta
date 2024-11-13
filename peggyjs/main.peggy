Program = body:(_ (ParseRule / TokenRule) _)* {
	return {
			type: "Program",
			body: body.map(x => x[1])
		}
}

/* --------------------------------- Tokens --------------------------------- */

TokenRule
	= "token" _ id:Id _ "=" _ body:TokenBody _ ";" {
		return {
			type: "TokenRule",
			id,
			body
		}
	}

TokenBody
	= "[" body:(CharacterRange) "]" { return body }

CharacterRange
	= from:Char ("-" to:Char)? { return typeof to !== "undefined" ? { type: "CharRange", from, to } : { type: "Char", char: from }}
		
Char "char"
	= .

/* ------------------------------ Parsing Rules ----------------------------- */

ParseRule
	= "rule" _ id:Id _ "=" _ body:Expression1 _ ";" {
	return {
		type: "ParseRule",
		id,
		body
	}
}

Expression1 = left:Expression2 right:(_ "|" _ Expression1)? {
	return right ? {
		type: "Or",
		left,
		right: right[3]
	} : left
}

Expression2 = body:Expression3|.., _| "*"? {
	return {
			type: "Series",
				body: body
		}
}

Expression3 
	= id:Id body:(":" Expression1)? {
			return body ? { type: "NamedCapture", id, body: body[1] } : {
				type: "Reference",
				id
			 }
		} / value:String {
			return {
					type: "LiteralMatch",
						value
				}
		} / "(" body:Expression1 ")" {
			return body
		} / Output
		
Output 
	= "=>" _ id:Id "{" _ properties:Property|.., _ ","| _ "}" {
			return {
					type: "Output",
						properties
				}
		}
		
Property
	= _ name:Id value:(_ ":" _ PropertyValue)? { return {
			type: "Property",
				shorthand: !value,
				value: !value ? null : value[3],
				name
		}}
		
PropertyValue
	= id:Id { return { type: "Identifier", id }} / value:String { return { type:"String", value}} 

Id "identifier"
	= [A-Za-z_][A-Za-z0-9_]* { return text() }
		
String "string"
	= [\"]str:[^"]*[\"] { return str.join("") }

_ "whitespace"
	= [ \t\n\r]*