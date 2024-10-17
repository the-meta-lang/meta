package main

import (
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
