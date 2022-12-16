esymbiotewd := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

$(esymbiotewd)cloud-services/gcloud/terraform.tfstate:
	@cd $(esymbiotewd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& exit 0; \
	terraform init

cloud-gcloud-apply: $(esymbiotewd)cloud-services/gcloud/terraform.tfstate
	@cd $(esymbiotewd)cloud-services/gcloud; \
	terraform apply -auto-approve

cloud-gcloud-destroy:
	@cd $(esymbiotewd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& terraform apply -destroy -auto-approve \
		|| echo "nothing to destroy."

cloud-gcloud-output: $(esymbiotewd)cloud-services/gcloud/terraform.tfstate
	@cd $(esymbiotewd)cloud-services/gcloud; \
	terraform output

$(esymbiotewd)cloud-services/aws/terraform.tfstate:
	@cd $(esymbiotewd)cloud-services/aws \
	test -e terraform.tfstate \
		&& exit 0; \
	terraform init

cloud-aws-apply: $(esymbiotewd)cloud-services/aws/terraform.tfstate
	@cd $(esymbiotewd)cloud-services/aws; \
	terraform apply -auto-approve -if-not-exists

cloud-aws-destroy:
	@cd $(esymbiotewd)cloud-services/aws; \
	test -e terraform.tfstate \
		&& terraform apply -destroy -auto-approve \
		|| echo "nothing to destroy."

cloud-aws-output: $(esymbiotewd)cloud-services/aws/terraform.tfstate
	@cd $(esymbiotewd)cloud-services/gcloud; \
	terraform output

.PHONY: $(esymbiotewd)cloud-services/gcloud/terraform.tfstate cloud-gcloud-apply cloud-gcloud-destroy cloud-gcloud-output \
		$(esymbiotewd)cloud-services/aws/terraform.tfstate cloud-aws-apply cloud-aws-destroy cloud-aws-output
