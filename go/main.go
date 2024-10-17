package main

import (
	"encoding/json"
	"fmt"
	"os"
)

type Match struct {
	Tree  Node   `json:"tree"`
	Start int    `json:"start"`
	End   int    `json:"end"`
	Value string `json:"value"`
}

type Node = map[string]interface{}

type Context struct {
	stdin  string
	stdout *os.File
	stderr *os.File
	// Error flag - if true an error was encountered that may not be recoverable
	cursor int
	tokens []Match
}

type Scope = map[string][]Match

func Map[T, U any](ts []T, f func(T) U) []U {
	us := make([]U, len(ts))
	for i := range ts {
		us[i] = f(ts[i])
	}
	return us
}

func error(ctx *Context, message string) {
	line, column := position(ctx)
	fmt.Println("\033[31;1merror\033[0m", message, "at line", line, "column", column)
	os.Exit(1)
}

func position(ctx *Context) (int, int) {
	line := 1
	column := 1

	for i := 0; i < ctx.cursor; i++ {
		if ctx.stdin[i] == '\n' {
			line++
			column = 1
		} else {
			column++
		}
	}

	return line, column
}

func test(ctx *Context, str string) (bool, Match) {
	i := 0
	for i < len(str) {
		if ctx.stdin[ctx.cursor+i] != str[i] {
			return false, Match{}
		}
		i++
	}

	ctx.cursor += i

	return true, Match{
		Start: ctx.cursor - i,
		End:   ctx.cursor,
		Value: str,
	}
}

func compile(input string) Match {
	var ok bool
	var match Match
	var program []Match

	ctx := Context{
		stdin:  input,
		stdout: os.Stdout,
		stderr: os.Stderr,
		cursor: 0,
	}

	ok, match = _program(&ctx)
	program = append(program, match)

	if !ok {
		error(&ctx, "Failed to parse program")
	}

	return match
}

/* -------------------------------- Compiled -------------------------------- */

/* ---------------------- Implementing an or statement ---------------------- */
// @example X | Y | Z
// func _orexample(ctx *Context) (bool, Match) {
// 	var match Match
// 	var ok bool

// 	ok, match = _x(ctx)

// 	if ok {
// 		return true, match
// 	}

// 	ok, match = _y(ctx)

// 	if ok {
// 		return true, match
// 	}

// 	ok, match = _z(ctx)

// 	if ok {
// 		return true, match
// 	}

// 	return false, Match{}
// }

func _char_group(ctx *Context) (bool, Match) {
	var ok bool
	var match Match

	ok, match = _char(ctx)

	if !ok {
		return false, Match{}
	}

	for {
		ok, match = _char(ctx)

		if !ok {
			break
		}
	}

	return true, match
}

func _char_range(ctx *Context) (bool, Match) {
	var ok bool = false
	var match Match
	var char []Match

	ok, match = _char(ctx)
	char = append(char, match)

	if !ok {
		return false, Match{}
	}

	ok, match = test(ctx, "-")

	if !ok {
		error(ctx, "Expected -")
	}

	ok, match = _char(ctx)
	char = append(char, match)

	if !ok {
		error(ctx, "Expected char")
	}

	match.Tree = Node{
		"type":  "CharRange",
		"start": char[0].Value,
		"end":   char[1].Value,
	}

	return ok, match
}

func _program(ctx *Context) (bool, Match) {
	var s0 []Match
	var s1 []Match
	var ok bool
	var match Match

	for {
		__(ctx)

		ok, match = _token_rule(ctx)

		if ok {
			s0 = append(s0, match)
			continue
		}

		ok, match = _parse_rule(ctx)

		if ok {
			s1 = append(s1, match)
			continue
		}

		ok = true
		break
	}

	if !ok {
		return false, Match{}
	}

	return true, Match{Tree: Node{
		"type":  "Program",
		"body":  Map(s0, func(m Match) Node { return m.Tree }),
		"rules": Map(s1, func(m Match) Node { return m.Tree }),
	}}
}

func _addition(ctx *Context) (bool, Match) {
	var operand []Match

	ok, match := _operand(ctx)

	if !ok {
		return false, Match{}
	}

	operand = append(operand, match)

	ok, _ = test(ctx, "+")

	if !ok {
		error(ctx, "Unexpected token")
	}

	ok, match = _operand(ctx)

	if !ok {
		error(ctx, "Expected operand")
	}

	operand = append(operand, match)

	return true, Match{Tree: Node{
		"type":  "Addition",
		"left":  operand[0].Tree,
		"right": operand[1].Tree,
	}}
}

func _operand(ctx *Context) (bool, Match) {
	var number []Match

	number = append(number, _number(ctx))

	return true, Match{Tree: Node{
		"type":  "Literal",
		"value": number[0].Value,
		"start": number[0].Start,
		"end":   number[0].End,
	}}
}

func _number(ctx *Context) Match {
	value := ""
	for ctx.stdin[ctx.cursor] >= 48 && ctx.stdin[ctx.cursor] <= 57 {
		value += string(ctx.stdin[ctx.cursor])
		ctx.cursor++
	}

	token := Match{
		Start: ctx.cursor - len(value),
		End:   ctx.cursor - 1,
		Value: value,
	}

	ctx.tokens = append(ctx.tokens, token)

	return token
}

func main() {
	sysargs := os.Args[1:]

	if len(sysargs) == 0 {
		fmt.Println("\033[31;1merror\033[0m No file provided")
		return
	}

	file, err := os.Open(sysargs[0])

	if err != nil {
		fmt.Println(err)
		return
	}

	defer file.Close()

	content := make([]byte, 1024)

	_, err = file.Read(content)

	if err != nil {
		fmt.Println(err)
		return
	}

	result := compile(string(content))

	json, err := json.MarshalIndent(result.Tree, "", "  ")

	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(string(json))
}
