# Basic Concepts

## Variables
To make variables easier to find in your code, every variable is prefixed with a `*` if it appears as part of a match procedure.
This is similar to the `last match operator` which is `*` or the `capture array operator` which is `**`.

### Example

```meta
LOOP<MaxIterations: i8> = $(*MaxIterations) $<0, MaxIterations>();
```