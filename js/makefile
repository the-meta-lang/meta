.PHONY: aexp test-aexp meta gyro test-gyro new test-new go test-go build-go copy-go-header
aexp:
	bun ./cli.ts compile -o ./aexp/out/aexp.ts -c 1 ./out/meta.ts ./aexp/grammar.meta;

test-aexp:
	bun ./cli.ts compile -o /dev/null -c 1 ./aexp/out/aexp.ts ./aexp/input.txt;


gyro:
	bun ./cli.ts compile -o ./gyro/out/gyro.ts -c 1 ./out/meta.ts ./gyro/grammar.meta;

test-gyro:
	bun ./cli.ts compile -o /dev/null -c 1 ./gyro/out/gyro.ts ./gyro/input.txt;


new:
	bun ./cli.ts compile -o ./new/out/new.ts -c 1 ./out/meta.ts ./new/grammar.meta;

test-new:
	bun ./cli.ts compile -o ./new/out/input.ts -c 1 ./new/out/new.ts ./new/input.meta;

# ------------------------------------ Go ------------------------------------ #

go: copy-ts-header

build-go:
	bun ./cli.ts compile -o ./go/out/body.ts -c 1 ./out/meta.ts ./go/grammar.meta

copy-ts-header: build-go
	cat ./go/includes/header.ts ./go/out/body.ts > ./go/out/go.ts

copy-go-header: build-go-test
	cat ./go/includes/header.go ./go/out/input.go > ./go/out/program.go

build-go-test:
	bun ./cli.ts compile -o ./go/out/input.go -c 1 ./go/out/go.ts ./go/input.meta;

test-go: copy-go-header


meta:
	bun ./cli.ts compile -o ./out/meta-dev.ts -c 1 ./out/meta.ts ./meta.meta;