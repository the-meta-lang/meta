mkdir -p ./benchmarks/results

hyperfine "./bootstrap/meta.bin ./src/meta.meta" --warmup 3 --export-markdown ./benchmarks/results/benchmark-result.md