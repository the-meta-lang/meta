./meta/meta.meta.bin ./meta/meta.input.meta > ./meta/meta.input.meta.asm \
&& bash ./compile.bash ./meta/meta.input.meta.asm \
&& ./meta/meta.input.meta.asm.bin ./meta/meta.input.meta;