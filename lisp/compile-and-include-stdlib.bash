#!/bin/bash

cd "$(dirname "$0")"

echo "$(cat ../lib/malloc.asm)" > ./test.asm
echo "$(./lisp.meta.bin ./test.mlisp)" >> ./test.asm

cd .. \
&& bash ./compile.bash ./lisp/test.asm ./lisp/test.bin \
&& ./lisp/test.bin