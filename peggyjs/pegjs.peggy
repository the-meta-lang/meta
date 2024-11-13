{{
  const OPS_TO_PREFIXED_TYPES = {
    "$": "text",
    "&": "simple_and",
    "!": "simple_not"
  };

  const OPS_TO_SUFFIXED_TYPES = {
    "?": "optional",
    "*": "zero_or_more",
    "+": "one_or_more"
  };

  const OPS_TO_SEMANTIC_PREDICATE_TYPES = {
    "&": "semantic_and",
    "!": "semantic_not"
  };
}}
{
  const reservedWords = options.reservedWords || [];
}
// ---- Syntactic Grammar -----

Grammar
  = imports:ImportDeclarations topLevelInitializer:(__ @TopLevelInitializer)? initializer:(__ @Initializer)? __ rules:(@Rule __)+ {
      return {
        type: "grammar",
        imports,
        topLevelInitializer,
        initializer,
        rules,
        location: location()
      };
    }

/* --------------------------------- Imports -------------------------------- */

// Alternate entry point to split JS into imports and not-imports.
ImportsAndSource
  = imports:ImportsAsText body:GrammarBody {
    return [imports, body];
  }

// Everything after the imports.
GrammarBody
  = code:$.* {
    return {
      type: "top_level_initializer",
      code,
      codeLocation: location(),
    }
  }

ImportsAsText
  = code:$ImportDeclarations {
    return {
      type: "top_level_initializer",
      code,
      codeLocation: location()
    }
  }

ImportDeclarations
  = ImportDeclaration*

ImportDeclaration
  = __ "import" __ what:ImportClause __ from:FromClause (__ ";")? { return {
    type: "grammar_import", what, from, location: location()
  }}
  / __ "import" __ from:ModuleSpecifier (__ ";")? { return {
    type: "grammar_import", what: [], from, location: location()
  }} // Intializers only

ImportClause
  = NameSpaceImport
  / NamedImports
  / first:ImportedDefaultBinding others:(__ "," __ @(NameSpaceImport / NamedImports))? {
    if (!others) {
      return [first];
    }
    if (Array.isArray(others)) {
      others.unshift(first);
      return others;
    }
    return [first, others];
  }

ImportedDefaultBinding
  = binding:ImportedBinding {
    return {
      type: 'import_binding_default',
      binding: binding[0],
      location: binding[1],
    }
  }

NameSpaceImport
  = "*" __ "as" __ binding:ImportedBinding {
    return [{
      type: 'import_binding_all',
      binding: binding[0],
      location: binding[1],
    }]
  }

NamedImports
  = "{" __ "}" { return [] } // Can't have bare comma
  / "{" __ @ImportsList __ ("," __)? "}"

FromClause
  = "from" __ @ModuleSpecifier

ImportsList
  = ImportSpecifier|1.., __ "," __|

ImportSpecifier
  = rename:ModuleExportName __ "as" __ binding:ImportedBinding {
    return {
      type: 'import_binding_rename',
      rename: rename[0],
      renameLocation: rename[1],
      binding: binding[0],
      location: binding[1],
    }
  }
  / binding:ImportedBinding {
    return {
      type: 'import_binding',
      binding: binding[0],
      location: binding[1]
    }
  }

ModuleSpecifier
  = module:StringLiteral {
      return { type: 'import_module_specifier', module, location: location() }
    }

ImportedBinding
  = id:BindingIdentifier { return [id, location()] }

ModuleExportName
  = IdentifierName
  / id:StringLiteral { return [id, location() ] }

BindingIdentifier = id:IdentifierName {
  if (reservedWords.indexOf(id[0]) >= 0) {
    error(`Binding identifier can't be a reserved word "${id[0]}"`, id[1]);
  }
  return id[0];
}

/* ------------------------------- Initializer ------------------------------ */

TopLevelInitializer
  = "{" code:CodeBlock "}" EOS {
      return {
        type: "top_level_initializer",
        code: code[0],
        codeLocation: code[1],
        location: location()
      };
    }

Initializer
  = code:CodeBlock EOS {
      return {
        type: "initializer",
        code: code[0],
        codeLocation: code[1],
        location: location()
      };
    }

/* ---------------------------------- Rules --------------------------------- */

Rule
  = "rule" _ name:IdentifierName __
		args:("<" __ @RuleArgumentList __ ">")? __
	// If the grammar rule returns a tree, a name can be specified that will be used as the type
	// of the node
    typeName:(":" __ @StringLiteral __)?
    "=" __
    expression:Expression EOS
    {
      return {
        type: "rule",
        name: name[0],
        nameLocation: name[1],
				arguments: args,
        expression: typeName !== null
          ? {
              type: "named",
              name: typeName,
              expression,
              location: location()
            }
          : expression,
        location: location()
      };
    }

RuleArgumentList
	= args:RuleArgument|.., __ "," __| { return args }

RuleArgument
	= name:IdentifierName value:(":" __ @(IdentifierName / StringLiteral / Integer))? {
		return value ? {
			name: name[0],
			value: value[1],
			shorthand: false
		} : {
			shorthand: true,
			name: name[0]
		}
	}

/* ------------------------------- Expression ------------------------------- */

Expression
  = ChoiceExpression

/* --------------------------------- Choice --------------------------------- */

ChoiceExpression
  = head:ActionExpression tail:(__ "|" __ @ActionExpression)* {
      return tail.length > 0
        ? {
            type: "choice",
            alternatives: [head].concat(tail),
            location: location()
          }
        : head;
    }

/* --------------------------------- Action --------------------------------- */

ActionExpression
  = expression:SequenceExpression code:(__ @CodeBlock)? {
      return code !== null
        ? {
            type: "action",
            expression,
            code: code[0],
            codeLocation: code[1],
            location: location()
          }
        : expression;
    }

/* -------------------------------- Sequence -------------------------------- */

SequenceExpression
  = head:LabeledExpression tail:(__ @LabeledExpression)* {
      return ((tail.length > 0) || (head.type === "labeled" && head.pick))
        ? {
            type: "sequence",
            elements: [head].concat(tail),
            location: location()
          }
        : head;
    }

/* --------------------------------- Labeled -------------------------------- */

LabeledExpression
  = pluck:Pluck label:LabelColon? expression:PrefixedExpression {
      if (expression.type.startsWith("semantic_")) {
        error("\"@\" cannot be used on a semantic predicate", pluck);
      }
      return {
        type: "labeled",
        label: label !== null ? label[0] : null,
        // Use location of "@" if label is unavailable
        labelLocation: label !== null ? label[1] : pluck,
        pick: true,
        expression,
        location: location()
      };
    }
  / label:LabelColon expression:PrefixedExpression {
      return {
        type: "labeled",
        label: label[0],
        labelLocation: label[1],
        expression,
        location: location()
      };
    }
  / PrefixedExpression

Pluck
  = "@" { return location(); }

LabelColon
  = label:IdentifierName __ ":" __ {
      if (reservedWords.indexOf(label[0]) >= 0) {
        error(`Label can't be a reserved word "${label[0]}"`, label[1]);
      }

      return label;
    }

PrefixedExpression
  = operator:PrefixedOperator __ expression:SuffixedExpression {
      return {
        type: OPS_TO_PREFIXED_TYPES[operator],
        expression,
        location: location()
      };
    }
  / SuffixedExpression

PrefixedOperator
  = "$"
  / "&"
  / "!"

SuffixedExpression
  = expression:PrimaryExpression __ operator:SuffixedOperator {
      return {
        type: OPS_TO_SUFFIXED_TYPES[operator],
        expression,
        location: location()
      };
    }
  / RepeatedExpression
  / PrimaryExpression

SuffixedOperator
  = "?"
  / "*"
  / "+"

/* -------------------------------- Repeated -------------------------------- */

RepeatedExpression
  = expression:PrimaryExpression __ "|" __ boundaries:Boundaries __ delimiter:("," __ @Expression __)? "|" {
      let min = boundaries[0];
      let max = boundaries[1];
      if (max.type === "constant" && max.value === 0) {
        error("The maximum count of repetitions of the rule must be > 0", max.location);
      }

      return {
        type: "repeated",
        min,
        max,
        expression,
        delimiter,
        location: location(),
      };
    }

Boundaries
  = min:Boundary? __ ".." __ max:Boundary? {
    return [
      min !== null ? min : { type: "constant", value: 0 },
      max !== null ? max : { type: "constant", value: null },
    ];
  }
  / exact:Boundary { return [null, exact]; }

Boundary
  = value:Integer { return { type: "constant", value, location: location() }; }
  / value:IdentifierName { return { type: "variable", value: value[0], location: location() }; }
  / value:CodeBlock {
    return {
      type: "function",
      value: value[0],
      codeLocation: value[1],
      location: location(),
    };
  }

PrimaryExpression
  = LiteralMatcher
  / CharacterClassMatcher
  / AnyMatcher
  / RuleReferenceExpression
  / SemanticPredicateExpression
  / "(" __ expression:Expression __ ")" {
      // The purpose of the "group" AST node is just to isolate label scope. We
      // don't need to put it around nodes that can't contain any labels or
      // nodes that already isolate label scope themselves. This leaves us with
      // "labeled" and "sequence".
      return expression.type === "labeled" || expression.type === "sequence"
          ? { type: "group", expression, location: location() }
          : expression;
    }

/* ----------------------------- Rule Arguments ----------------------------- */

RuleReferenceArgumentList
	= args:RuleReferenceArgument|.., __ "," __| { return args }

RuleReferenceArgument
	= value:(IdentifierName / StringLiteral / Integer) {
		return {
			type: "argument",
			value
		}
	}

RuleReferenceExpression
  // = library:IdentifierName "." name:IdentifierName {
  //     return {
  //       type: "library_ref",
  //       name: name[0],
  //       library: library[0],
  //       libraryNumber: -1,
  //       location: location()
  //     }
  //   }
  // / 
	= name:IdentifierName !(__ (StringLiteral __)? "=") args:("<" __ @RuleReferenceArgumentList __ ">")? {
      return { type: "rule_ref", name: name[0], location: location(), args };
    }

SemanticPredicateExpression
  = operator:SemanticPredicateOperator __ code:CodeBlock {
      return {
        type: OPS_TO_SEMANTIC_PREDICATE_TYPES[operator],
        code: code[0],
        codeLocation: code[1],
        location: location()
      };
    }

SemanticPredicateOperator
  = "&"
  / "!"

// ---- Lexical Grammar -----

SourceCharacter
  = .

WhiteSpace "whitespace"
  = "\t"
  / "\v"
  / "\f"
  / " "
  / "\u00A0"
  / "\uFEFF"

LineTerminator
  = [\n\r\u2028\u2029]

LineTerminatorSequence "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"

Comment "comment"
  = MultiLineComment
  / SingleLineComment

MultiLineComment
  = "/*" (!"*/" SourceCharacter)* "*/"

MultiLineCommentNoLineTerminator
  = "/*" (!("*/" / LineTerminator) SourceCharacter)* "*/"

SingleLineComment
  = "//" (!LineTerminator SourceCharacter)*

IdentifierName "identifier"
  = head:IdentifierStart tail:IdentifierPart* {
      return [head + tail.join(""), location()];
    }

IdentifierStart
  = "_"
  / "\\" @UnicodeEscapeSequence
	/ [a-zA-Z_]

IdentifierPart
  = IdentifierStart
  / "$"
  / "\u200C"
  / "\u200D"
	/ [a-zA-Z_0-9]

LiteralMatcher "literal"
  = value:StringLiteral ignoreCase:"i"? {
      return {
        type: "literal",
        value,
        ignoreCase: ignoreCase !== null,
        location: location()
      };
    }

StringLiteral "string"
  = '"' chars:DoubleStringCharacter* '"' { return chars.join(""); }
  / "'" chars:SingleStringCharacter* "'" { return chars.join(""); }

DoubleStringCharacter
  = $(!('"' / "\\" / LineTerminator) SourceCharacter)
  / "\\" @EscapeSequence
  / LineContinuation

SingleStringCharacter
  = $(!("'" / "\\" / LineTerminator) SourceCharacter)
  / "\\" @EscapeSequence
  / LineContinuation

CharacterClassMatcher "character class"
  = "["
    inverted:"^"?
    parts:(ClassCharacterRange / ClassCharacter)*
    "]"
    ignoreCase:"i"?
    {
      return {
        type: "class",
        parts: parts.filter(part => part !== ""),
        inverted: inverted !== null,
        ignoreCase: ignoreCase !== null,
        location: location()
      };
    }

ClassCharacterRange
  = begin:ClassCharacter "-" end:ClassCharacter {
      if (begin.charCodeAt(0) > end.charCodeAt(0)) {
        error(
          "Invalid character range: " + text() + "."
        );
      }

      return [begin, end];
    }

ClassCharacter
  = $(!("]" / "\\" / LineTerminator) SourceCharacter)
  / "\\" @EscapeSequence
  / LineContinuation

LineContinuation
  = "\\" LineTerminatorSequence { return ""; }

EscapeSequence
  = CharacterEscapeSequence
  / "0" !DecimalDigit { return "\0"; }
  / HexEscapeSequence
  / UnicodeEscapeSequence

CharacterEscapeSequence
  = SingleEscapeCharacter
  / NonEscapeCharacter

SingleEscapeCharacter
  = "'"
  / '"'
  / "\\"
  / "b"  { return "\b"; }
  / "f"  { return "\f"; }
  / "n"  { return "\n"; }
  / "r"  { return "\r"; }
  / "t"  { return "\t"; }
  / "v"  { return "\v"; }

NonEscapeCharacter
  = $(!(EscapeCharacter / LineTerminator) SourceCharacter)

EscapeCharacter
  = SingleEscapeCharacter
  / DecimalDigit
  / "x"
  / "u"

HexEscapeSequence
  = "x" digits:$(HexDigit HexDigit) {
      return String.fromCharCode(parseInt(digits, 16));
    }

UnicodeEscapeSequence
  = "u" digits:$(HexDigit HexDigit HexDigit HexDigit) {
      return String.fromCharCode(parseInt(digits, 16));
    }

DecimalDigit
  = [0-9]

HexDigit
  = [0-9a-f]i

AnyMatcher
  = "." { return { type: "any", location: location() }; }

CodeBlock "code block"
  = "{" @BareCodeBlock "}"

BareCodeBlock
  = code:Code { return [code, location()]; }

Code
  = $((![{}] SourceCharacter)+ / "{" Code "}")*

Integer
  = digits:$DecimalDigit+ { return parseInt(digits, 10); }

// Skipped

__
  = (WhiteSpace / LineTerminatorSequence / Comment)*

_
  = (WhiteSpace / MultiLineCommentNoLineTerminator)*

// Automatic Semicolon Insertion

EOS
  = (__ ";")+
  / _ SingleLineComment? LineTerminatorSequence
  / __ EOF

EOF
  = !.