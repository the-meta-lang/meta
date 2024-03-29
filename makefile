bundle:
	cd bin && rm -f ../release/meta-linux-x64.zip && zip -r ../release/meta-linux-x64.zip ./meta-linux-x64/meta

# Runs all github actions locally
act:
	act -P ubuntu-latest=catthehacker/ubuntu:act-latest --env ACTIONS_RUNTIME_URL=http://host.docker.internal:8080/ --env ACTIONS_RUNTIME_TOKEN=foo --env ACTIONS_CACHE_URL=http://host.docker.internal:8080/ --artifact-server-path artifacts

test:
	bash ./tests/test.bash ./bootstrap/meta.bin