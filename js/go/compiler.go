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
	eflag  bool
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
	output, err := json.MarshalIndent(match, "", "  ")
	if err != nil {
		error(&ctx, "Failed to marshal JSON")
	}
	fmt.Println(string(output) + "\n")
	if !ok {
		error(&ctx, "Failed to parse program")
	}
	return match
}

func main() {
	buffer := make([]byte, 1024)
	n, _ := os.Open("input.txt")
	n.Read(buffer)
	compile(string(buffer))
}

func _program(ctx *Context) (bool, Match) {
	var match Match
	var ok bool
	var m Match

	var s0 []Match
	var s1 []Match
	var s2 []Match
	var s3 []Match

	for true {
		ok, m = _entry_rule(ctx)

		// Matching the entry rule was successful, we can continue to the next round.
		if ok {
			s0 = append(s0, m)
			continue
		}

		ok, m = _comment(ctx)

		if ok {
			s1 = append(s1, m)
			continue
		}

		ok, m = __(ctx)

		if ok {
			s2 = append(s2, m)
			continue
		}

		ok, m = _empty(ctx)

		if ok {
			s3 = append(s3, m)
			continue
		}

		break
	}
	ok = true

	match.Tree = Node{
		"program": s0[0].Tree,
		"comment": s1[0].Tree,
	}

	return ok, match
}

/**

rule program = (entry_rule | comment | _ | empty)* => {
	entry: entry_rule
};

rule comment = "//" empty => {
	comment: empty
};

token empty = [^\n]*;

**/

func _comment(ctx *Context) (bool, Match) {
	var match Match
	var ok bool
	var m Match
	var s0 []Match

	ok, _ = test(ctx, "//")

	if !ok {
		ctx.eflag = true
		return ok, match
	}

	ok, m = _empty(ctx)

	if ok {
		s0 = append(s0, m)

		match.Tree = Node{
			"comment": s0[0].Value,
		}
	}

	return ok, match
}

func ignore(ctx *Context) (bool, Match) {
	var match Match
	var ok bool = false

	for ctx.cursor < len(ctx.stdin) {
		if ctx.stdin[ctx.cursor] == ' ' || ctx.stdin[ctx.cursor] == '\n' || ctx.stdin[ctx.cursor] == '\t' {
			match.Value += string(ctx.stdin[ctx.cursor])
			ctx.cursor++
			ok = true
		} else {
			break
		}
	}

	return ok, match
}

func _empty(ctx *Context) (bool, Match) {
	var match Match
	var ok bool = false

	for ctx.stdin[ctx.cursor] != '\n' && ctx.stdin[ctx.cursor] != 0x00 {
		match.Value += string(ctx.stdin[ctx.cursor])
		ctx.cursor++
	}

	if len(match.Value) > 0 {
		ok = true
	}

	return ok, match
}

func _entry_rule(ctx *Context) (bool, Match) {
	var match Match
	var ok bool
	var m Match

	var id []Match

	ok, _ = test(ctx, "entry")

	if !ok {
		ctx.eflag = true
		return ok, match
	}

	ok, _ = __(ctx)

	if !ok {
		ctx.eflag = true
		return ok, match
	}

	ok, m = _id(ctx)
	id = append(id, m)

	match.Tree = Node{
		"entry": id[0].Value,
	}

	if !ok {
		ctx.eflag = true
		return ok, match
	}

	ok, _ = __(ctx)

	ok, _ = test(ctx, ";")

	if !ok {
		ctx.eflag = true
		return ok, match
	}

	return ok, match
}

func _id(ctx *Context) (bool, Match) {
	var match Match
	var ok bool

	ignore(ctx)

	for ctx.stdin[ctx.cursor] >= 'a' && ctx.stdin[ctx.cursor] <= 'z' {
		match.Value += string(ctx.stdin[ctx.cursor])
		ctx.cursor++
		ok = true
	}

	return ok, match
}

// Match whitespace
func __(ctx *Context) (bool, Match) {
	var match Match
	var ok bool

	ignore(ctx)

	for ctx.cursor < len(ctx.stdin) {
		if ctx.stdin[ctx.cursor] == ' ' || ctx.stdin[ctx.cursor] == '\n' || ctx.stdin[ctx.cursor] == '\t' {
			match.Value += string(ctx.stdin[ctx.cursor])
			ctx.cursor++
			ok = true
		} else {
			break
		}
	}

	return ok, match
}
