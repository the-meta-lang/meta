# Symbol Table binary encoding format

The symbol table stores information about a program's variables and functions. It can be used as a reference for the corresponding memory locations of variables and their **stack pointer offsets**.

The following is the format used to encode information about a variable. The symbol table relays information about the variable's name, type, and memory location. This information is stored as a 4 byte integer.

```
[ 8 bits ][ 24 bits ]
```

The first 8 bits are used to store the variable's type and properties. The next 24 bits are used to store the variable's memory location.

Let's look at the first 8 bits in more detail:


Bit Index | Usage
----------|-----------------------------
0         | Is this variable global?
1         | Are we dealing with a const?