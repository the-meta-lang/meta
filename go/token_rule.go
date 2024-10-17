package main

func _token_rule(ctx *Context) (bool, Match) {
	var ok bool
	var match Match

	var token []Match
	var id []Match
	var char_range []Match

	ok, match = test(ctx, "token")
	token = append(token, match)

	if !ok {
		return false, Match{}
	}

	ok, match = __(ctx)

	if !ok {
		error(ctx, "Expected whitespace")
	}

	ok, match = _id(ctx)
	id = append(id, match)

	if !ok {
		error(ctx, "Expected id")
	}

	ok, match = __(ctx)

	if !ok {
		error(ctx, "Expected whitespace")
	}

	ok, match = test(ctx, "=")

	if !ok {
		error(ctx, "Expected =")
	}

	ok, match = __(ctx)

	// [...] | (...)

	ok, match = test(ctx, "[")

	if ok {
		ok, match = _char_range(ctx)
		char_range = append(char_range, match)

		if !ok {
			error(ctx, "Expected char range")
		}

		ok, match = test(ctx, "]")

		if !ok {
			error(ctx, "Expected ]")
		}
	} else {
		ok, _ = test(ctx, "(")

		if ok {
			ok, match = _char_group(ctx)

			if !ok {
				error(ctx, "Expected char group")
			}

			ok, match = test(ctx, ")")

			if !ok {
				error(ctx, "Expected )")
			}
		} else {
			error(ctx, "Expected [ or (")
		}
	}

	ok, match = test(ctx, ";")

	if !ok {
		error(ctx, "Expected ;")
	}

	return ok, Match{Tree: Node{
		"type": "TokenRule",
		"id":   id[0].Value,
		"char": char_range[0].Tree,
	}}
}
