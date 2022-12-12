overview: self-checks

self-checks:
	@echo "Running self checks..."
	pre-commit run -a

summon/esymbiote/cloud-services/gcloud/.terraform:
	(cd summon/esymbiote/cloud-services/gcloud && terraform init)

cloud-gcloud-apply: summon/esymbiote/cloud-services/gcloud/.terraform
	(cd summon/esymbiote/cloud-services/gcloud && terraform apply -auto-approve)

cloud-gcloud-destroy: summon/esymbiote/cloud-services/gcloud/.terraform
	(cd summon/esymbiote/cloud-services/gcloud && terraform apply -destroy -auto-approve)

cloud-gcloud-output: summon/esymbiote/cloud-services/gcloud/.terraform
	(cd summon/esymbiote/cloud-services/gcloud && terraform output)

cloud-gcloud-tunnel: summon/esymbiote/cloud-services/gcloud/.terraform
	@echo "Starting tunnel... localhost:1080"
	(cd summon/esymbiote/cloud-services/gcloud && nohup ./run_tunnel.sh 34.94.126.216 10.168.0.10 >/dev/null 2>&1 & )

summon/esymbiote/cloud-services/aws/.terraform:
	(cd summon/esymbiote/cloud-services/aws && terraform init)

cloud-aws-apply: summon/esymbiote/cloud-services/aws/.terraform
	(cd summon/esymbiote/cloud-services/aws && terraform apply -auto-approve)

cloud-aws-destroy: summon/esymbiote/cloud-services/aws/.terraform
	(cd summon/esymbiote/cloud-services/aws && terraform apply -destroy -auto-approve)

cloud-aws-output: summon/esymbiote/cloud-services/aws/.terraform
	(cd summon/esymbiote/cloud-services/aws && terraform output)

build-dockerfile: .devcontainer/Dockerfile
    docker build --build-arg USER=user -t seed:latest .devcontainer

docker:
    docker run -it -v $(shell pwd):/home/user/seed seed

backup:
	@echo "Archiving..."
	@tar --exclude='./.devcontainer/vscode-server-extensions-persist/*' \
		--exclude='**/.terraform' \
		--exclude='**/.build' \
		--exclude='./summon/amazon/*' \
		--transform s/^\./seed/ \
		-cvjf /tmp/seed.tar.bz2 . \
		| pv -s `find . -not -path "./.devcontainer/vscode-server-extensions-persist/*" | wc -l` \
		-l > /dev/null
	@echo "Encrypting..."
	#@gpg --encrypt --sign -r anonymous@pm.me /tmp/seed.tar.bz2
	@echo "done. Archive information:"
	@ls -al /tmp/seed.tar.bz2

.PHONY: overview self-checks backup build-dockerfile cloud-gcloud-apply cloud-gcloud-destroy cloud-gcloud-output cloud-gcloud-tunnel docker
