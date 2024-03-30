bundle:
	cd bin && rm -f ../release/meta-linux-x64.zip && zip -r ../release/meta-linux-x64.zip ./meta-linux-x64/meta

# Runs all github actions locally
act:
	act -P ubuntu-latest=catthehacker/ubuntu:act-latest --env ACTIONS_RUNTIME_URL=http://host.docker.internal:8080/ --env ACTIONS_RUNTIME_TOKEN=foo --env ACTIONS_CACHE_URL=http://host.docker.internal:8080/ --artifact-server-path artifacts

test:
	lib/bashunit -v ./tests/test.bash

test-lisp:
	lib/bashunit -v ./lisp/tests/test.bash

test-all: test test-lisp