overview: self-checks

include active/esymbiote/makefile
include active/extropic.net/makefile

now := $(shell date +"%F_%T_%Z")
self-checks:
	@echo "Running self checks..."
	pre-commit run -a

# extropic-net DNS via gcloud
# other services are present via AWS
cloud-up: extropic-net-apply

cloud-down: extropic-net-destroy

build-dockerfile: .devcontainer/Dockerfile
    docker build --build-arg USER=user -t seed:latest .devcontainer

docker:
    docker run -it -v $(shell pwd):/home/user/seed seed

backup:
	@echo "Archiving..."
	@tar --exclude='./.devcontainer/vscode-server-extensions-persist/*' \
		--exclude='**/.terraform' \
		--exclude='**/.build' \
		--exclude='**/.secure-staging' \
		--exclude='./active/amazon/*' \
		--transform s/^\./seed/ \
		-cvjf /tmp/seed_$(now).tar.bz2 . \
		| pv -s `find . -not -path "./.devcontainer/vscode-server-extensions-persist/*" | wc -l` \
		-l > /dev/null
	@echo "Encrypting..."
	@gpg -r anonymous -e /tmp/seed_$(now).tar.bz2
	@echo "done. Archive information:"
	@ls -al /tmp/seed_$(now).tar.bz2 /tmp/seed_$(now).tar.bz2.gpg

backup-gpg-metadata:
	@echo "Exporting..."
	@./scripts/backup-gpg-metadata.sh

clean-secure-staging:
	@echo "Recursively removing all .secure-staging directories:"
	@find . -name ".secure-staging" -type d -print0 | xargs -0 -I {} sh -c 'echo "\t{}"; /bin/rm -rf "{}"'
	@echo "done."

.PHONY: backup build-dockerfile clean-secure-staging docker esymbiote \
	online-presence-up online-presence-down \
	overview self-checks
