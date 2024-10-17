package main

func _id(ctx *Context) (bool, Match) {
	value := ""
	if ctx.stdin[ctx.cursor] >= 65 && ctx.stdin[ctx.cursor] <= 90 || ctx.stdin[ctx.cursor] >= 97 && ctx.stdin[ctx.cursor] <= 122 {
		value += string(ctx.stdin[ctx.cursor])
		ctx.cursor++
	}

	for ctx.stdin[ctx.cursor] >= 65 && ctx.stdin[ctx.cursor] <= 90 || ctx.stdin[ctx.cursor] >= 97 && ctx.stdin[ctx.cursor] <= 122 || ctx.stdin[ctx.cursor] >= 48 && ctx.stdin[ctx.cursor] <= 57 {
		value += string(ctx.stdin[ctx.cursor])
		ctx.cursor++
	}

	token := Match{
		Start: ctx.cursor - len(value),
		End:   ctx.cursor - 1,
		Value: value,
	}

	ctx.tokens = append(ctx.tokens, token)

	return true, token
}
