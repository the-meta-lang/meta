package main

func __(ctx *Context) (bool, Match) {
	value := ""
	for ctx.stdin[ctx.cursor] == 32 || ctx.stdin[ctx.cursor] == 9 || ctx.stdin[ctx.cursor] == 10 || ctx.stdin[ctx.cursor] == 13 {
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
