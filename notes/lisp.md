# META Lisp

META Supports a high level language that can be used to achieve some more complex compiler functions. It's called META Lisp and is based off the ever popular Lisp language. It looks like this:

```
[defunc [add a b]
	[+ a b]]
```

It supports a few built-in keywords.


## defunc

Defines a callable function with a name and a list of arguments. The body of the function is a list of expressions.

```
[defunc [add a b]
	[+ a b]]
```

This will expand to the following ASM code:

```asm
add:
	push ebp
	mov ebp, esp
	mov dword [ebp+16], esi
	mov dword [ebp+20], edi

	push dword [ebp+16]
	push dword [ebp+20]
	pop eax
	pop ebx
	add eax, ebx
	push eax
	pop eax

	mov esp, ebp
	pop ebp
	ret
```

## define

Defines a variable with a name and a value.

```
[define x 5]
```

## set

Sets a variable with a name to a new value.

```
[set x 5]
```

## while

Loops while a condition is true.

```
[while [> x 0]
	[set x [- x 1]]]
```

## if

Executes a block of code if a condition is true.

```
[if [> x 0]
	[set x [- x 1]]]
```

## if/else

Executes a block of code if a condition is true, otherwise executes another block of code.

```
[if/else [> x 0]
	[set x [- x 1]]
	[set x 0]]
```

## asmmacro

Defines an assembler macro with a name and a list of arguments. The body consists of a list of assembler expressions

```
[asmmacro [add a b]
	"add esi, edi"
	"mov eax, esi"
]
```

And that's it...


## Calling

```
[main 1 2 3]
```

```
Stack

x - 1  (+16)
y - 2	 (+12)
z - 3  (+8)
ip
fp <- esp
```

arg_count = 3
arg_num = 3

If we now want to get `z` we can do `mov eax, [ebp+8]` but how do we calculate that?

`(arg_count - arg_num) * 4`