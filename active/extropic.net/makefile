extropicwd := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

$(extropicwd)cloud-services/gcloud/terraform.tfstate:
	@cd $(extropicwd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& exit 0; \
	terraform init

extropic-net-apply: $(extropicwd)cloud-services/gcloud/terraform.tfstate
	@cd $(extropicwd)cloud-services/gcloud; \
	terraform apply -auto-approve

extropic-net-destroy:
	@cd $(extropicwd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& terraform apply -destroy -auto-approve \
		|| echo "nothing to destroy."

extropic-net-output: $(extropicwd)cloud-services/gcloud/terraform.tfstate
	@cd $(extropicwd)cloud-services/gcloud; \
	terraform output

.PHONY: $(extropicwd)cloud-services/gcloud/terraform.tfstate extropic-net-apply extropic-net-destroy extropic-net-output
