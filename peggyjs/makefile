.PHONY: all pegjs

all:
	bunx peggy -o ./parser.js --format es ./main.peggy --test-file "./test.meta" --watch

pegjs:
	mkdir -p ./logs
	bunx peggy -o pegjs-parser.js --format es ./pegjs.peggy --test-file "./test.meta" --trace > ./logs/$(shell date --iso=minutes).log

pegjs-watch:
	bunx peggy -o pegjs-parser.js --format es ./pegjs.peggy --test-file "./test.meta" --watch --trace
