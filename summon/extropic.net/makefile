makepwd := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

$(makepwd)cloud-services/gcloud/terraform.tfstate:
	@cd $(makepwd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& exit 0; \
	terraform init

extropic-net-apply: $(makepwd)cloud-services/gcloud/terraform.tfstate
	@cd $(makepwd)cloud-services/gcloud; \
	terraform apply -auto-approve

extropic-net-destroy:
	@cd $(makepwd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& terraform apply -destroy -auto-approve \
		|| echo "nothing to destroy."

extropic-net-output: $(makepwd)cloud-services/gcloud/terraform.tfstate
	@cd $(makepwd)cloud-services/gcloud; \
	terraform output

.PHONY: $(makepwd)cloud-services/gcloud/terraform.tfstate extropic-net-apply extropic-net-destroy extropic-net-output
