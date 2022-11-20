overview: self-checks

self-checks:
	@echo "Running self checks..."
	pre-commit run -a

cloud-relay/gcloud/.terraform:
	(cd cloud-relay/gcloud && terraform init)

cloud-gcloud-apply: cloud-relay/gcloud/.terraform
	(cd cloud-relay/gcloud && terraform apply -auto-approve)

cloud-gcloud-destroy: cloud-relay/gcloud/.terraform
	(cd cloud-relay/gcloud && terraform apply -destroy -auto-approve)

cloud-gcloud-output: cloud-relay/gcloud/.terraform
	(cd cloud-relay/gcloud && terraform output)

cloud-gcloud-tunnel: cloud-relay/gcloud/.terraform
	@echo "Starting tunnel... localhost:1080"
	(cd cloud-relay/gcloud && nohup ./run_tunnel.sh 34.94.126.216 10.168.0.10 >/dev/null 2>&1 & )

cloud-relay/aws/.terraform:
	(cd cloud-relay/aws && terraform init)

cloud-aws-apply: cloud-relay/aws/.terraform
	(cd cloud-relay/aws && terraform apply -auto-approve)

cloud-aws-destroy: cloud-relay/aws/.terraform
	(cd cloud-relay/aws && terraform apply -destroy -auto-approve)

cloud-aws-output: cloud-relay/aws/.terraform
	(cd cloud-relay/aws && terraform output)

build-dockerfile: .devcontainer/Dockerfile
    docker build --build-arg USER=user -t seed:latest .devcontainer

docker:
    docker run -it -v $(shell pwd):/home/user/seed seed

backup:
	@echo "Archiving..."
	@tar --exclude='./.devcontainer/vscode-server-extensions-persist/*' \
		--exclude='**/.terraform' \
		--exclude='./summon/amazon/*' \
		--transform s/^\./seed/ \
		-cvjf /tmp/seed.tar.bz2 . \
		| pv -s `find . -not -path "./.devcontainer/vscode-server-extensions-persist/*" | wc -l` \
		-l > /dev/null
	@echo "done. Archive information:"
	@ls -al /tmp/seed.tar.bz2

.PHONY: overview self-checks backup build-dockerfile cloud-gcloud-apply cloud-gcloud-destroy cloud-gcloud-output cloud-gcloud-tunnel docker
