# Types

* u8
  * 8-bit unsigned integer
  * 0 to 255
  * 1 byte
  * `u8`
  * `let x: u8 = 0;`

## Struct size calculation

```rust
struct Foo {
		a: u8,
		b: u16,
		c: u8,
}
```

* `Foo` size is 4 bytes

### Offsets

* `a` is at offset 0
* `b` is at offset 1
* `c` is at offset 3

```
let x: Foo = { a: 1, b: 2, c: 3 };
let b: u16 = x.b;
```

`x.b` is a shorthand for `(*x) + 1`.

## Enum

```rust
enum Foo {
		A,
		B,
		C,
}
```

* `Foo` size is 1 byte
* `A` is 0
* `B` is 1
* `C` is 2

```rust
let x: Foo = Foo::B;
```

There are also manually assigned values, the type has to be specified in this case:

```rust
enum Foo<u8> {
		A = 1,
		B = 2,
		C = 4,
}
```

Since we only use structs, enums and basic types, we can easily implement type checking by assigning a unique number to each type. This way we can check if the type is correct by comparing the number.

## Array

```rust
let x: [u8; 3] = [1, 2, 3]; // x is a pointer to the first element

let slice: [u8; 2..] = x[0..2]; // shorthand for 
// [(*x + 0), 2] stacked in a fat pointer (2 * sizeof(ptr))
```

* `x` is an array of 3 `u8` values
* `x[0]` is 1
* `x[1]` is 2
* `x[2]` is 3
* `x.len()` is 3
* `x[3]` is a runtime error
* `x[0..2]` is `[1, 2]`
* `x[0..]` is `[1, 2, 3]`
* `x[..2]` is `[1, 2]`
* `x[..]` is `[1, 2, 3]`
  * `x[..]` is a shorthand for `x[0..x.len()]`

Slicing an array creates a fat pointer (128 bit on 64 bit architecture) with the new length and the pointer to the first element.

## Type Matching

We need a way to encode information about the type of a value in case we encounter something `[u8; 3]` twice in the code. If we use a unique number for each encountered type we could not match the two types. We need a way to match the types by their structure.

If we use explicit structs or enums it's easy as we can just use the type itself. If we use arrays we can use the type of the elements and the length of the array. We can encode this information in a 128 bit number.

* 64 bit for the type
* 64 bit for the length
* 0x00 for unknown type

We can use this number to match the types.

### Generic Structs

```rust
struct Foo<T, A> {
		a: T,
		b: A,
}
```

Encoding this is a bit more complex as there are unlimited possibilities how `T` and `A` can be used. We can't use a unique number for each type as we would need an infinite amount of numbers. Once we encounter a generic struct we need to encode the type of `T` and `A` in the number.



## Type Checking

We can use the type number to check if the type is correct. If the type is not correct we can throw a runtime error.

## Type Inference

We can infer the type of a value by looking at the type of the value it's assigned to. If the type is not known we can use the type of the value itself.

### Numbers

Numbers are always inferred by using the smallest possible type able to hold the value.

### Arrays

Arrays are always inferred by using the type of the elements and the length of the array.

## Type Conversion

Conversion of types needs to be explicit. We can't convert a `u8` to a `u16` without specifying the conversion.

```rust
let x: u8 = 1;
let y: u16 = x as u16;
```

## Type Promotion

Promotion of types is done implicitly. If we add a `u8` to a `u16` the `u8` is promoted to a `u16`.

```rust
let x: u8 = 1;
let y: u16 = 2;
let z: u16 = x + y;
```

## Type Coercion

Coercion of types is done implicitly. If we have a `u8` and we need a `u16` we can use the `u8` as a `u16`.

```rust
let x: u8 = 1;
let y: u16 = x;
```