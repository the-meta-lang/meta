# Backtracking

Backtracking works by storing all current pointers:

	- `inbuff_offset` - The offset of the current character in the input buffer
	- `outbuff_offset` - The offset of the current character in the output buffer
	- `last_match` - The last_match as a string.

Once we encounter an error we can revert everyhting to the start of the backtracking point and try again.

The syntax for that looks like this:

```
PRORGAM = {
	"option" "1" ->("option1")
	/ "option" "2" ->("option2")
}
```

This would, if executed in a normal environment, cause the program to match the first rule (`"option" "1"`) first, if given an input like this one:

```
option 2
```

However, this will lead to an error once we hit the `"1"` string match.
Normally, we couldn't recover from this since we hit a dead end.
However, using the backtracker, we can backtrack by reverting the `inbuff_offset` and `outbuff_offset` to the start of the match and try the next rule.

```tefcha
store buffer offsets

match rule1
if error
	restore buffer offsets
	match rule2
	if error
		restore buffer offsets
		// ... and so on

clear buffer offsets
```