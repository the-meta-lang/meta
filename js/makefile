.PHONY: aexp test-aexp meta gyro test-gyro
aexp:
	bun ./cli.ts compile -o ./aexp/out/aexp.ts -c 1 ./out/meta.ts ./aexp/grammar.meta;

test-aexp:
	bun ./cli.ts compile -o /dev/null -c 1 ./aexp/out/aexp.ts ./aexp/input.txt;


gyro:
	bun ./cli.ts compile -o ./gyro/out/gyro.ts -c 1 ./out/meta.ts ./gyro/grammar.meta;

test-gyro:
	bun ./cli.ts compile -o /dev/null -c 1 ./gyro/out/gyro.ts ./gyro/input.txt;


meta:
	bun ./cli.ts compile -o ./out/meta-dev.ts -c 1 ./out/meta.ts ./meta.meta;