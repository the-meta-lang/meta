# General call structure.

Since META has to support multiple different operations it makes sense to groupm these together so that code can be reused as much as possible.

Consider the following 2 operations:

```meta
RULE = ID %("Hello" *)
```

```meta
RULE = ID ->("Hello" *)
```

In the first scenario, the string `"Hello"` gets concatenated with the last match operator `*` and pushed into the string buffer while in the second case, the values get independently copied into the buffer.
However, this is essentially the same operation with the only difference being the concatenation.

We can visualize that like this:

```tefcha
if match "%"
	capture all arguments
	reverse through all arguments
	concatenate each with the last one
elif match "->"
	capture all arguments
	copy each to the buffer immediately
else
	something other
```