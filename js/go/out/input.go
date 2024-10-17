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
