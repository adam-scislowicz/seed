overview: self-checks

include active/esymbiote/makefile
include active/extropic.net/makefile

now := $(shell date +"%F_%T_%Z")
self-checks:
	@echo "Running self checks..."
	pre-commit run -a

build-dockerfile: .devcontainer/Dockerfile
    docker build --build-arg USER=user -t seed:latest .devcontainer

docker:
    docker run -it -v $(shell pwd):/home/user/seed seed

backup:
	@echo "Archiving..."
	@tar --exclude='./.devcontainer/vscode-server-extensions-persist/*' \
		--exclude='**/.terraform' \
		--exclude='**/.build' \
		--exclude='./active/amazon/*' \
		--transform s/^\./seed/ \
		-cvjf /tmp/seed_$(now).tar.bz2 . \
		| pv -s `find . -not -path "./.devcontainer/vscode-server-extensions-persist/*" | wc -l` \
		-l > /dev/null
	@echo "Encrypting..."
	@gpg -r anonymous -e /tmp/seed_$(now).tar.bz2
	@echo "done. Archive information:"
	@ls -al /tmp/seed_$(now).tar.bz2 /tmp/seed_$(now).tar.bz2.gpg

.PHONY: overview self-checks backup build-dockerfile docker esymbiote
