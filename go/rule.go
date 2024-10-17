package main

func _parse_rule(ctx *Context) (bool, Match) {
	var match Match
	var ok bool
	var s0 []Match

	ok, match = test(ctx, "rule")

	if !ok {
		return false, match
	}

	ok, match = __(ctx)

	if !ok {
		error(ctx, "Expected whitespace")
	}

	ok, match = _id(ctx)
	s0 = append(s0, match)

	if !ok {
		error(ctx, "Expected id")
	}

	ok, match = __(ctx)

	if !ok {
		error(ctx, "Expected whitespace")
	}

	ok, match = test(ctx, "=")

	if !ok {
		error(ctx, "Expected '='")
	}

	ok, match = __(ctx)

	if !ok {
		error(ctx, "Expected whitespace")
	}

	match.Tree = Node{
		"id": s0[0].Value,
	}

	return ok, match
}

// rule parse_rule =
