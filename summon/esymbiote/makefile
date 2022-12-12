makepwd := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

$(makepwd)cloud-services/gcloud/terraform.tfstate:
	@cd $(makepwd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& exit 0; \
	terraform init

cloud-gcloud-apply: $(makepwd)cloud-services/gcloud/terraform.tfstate
	@cd $(makepwd)cloud-services/gcloud; \
	terraform apply -auto-approve

cloud-gcloud-destroy:
	@cd $(makepwd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& terraform apply -destroy -auto-approve \
		|| echo "nothing to destroy."

cloud-gcloud-output: $(makepwd)cloud-services/gcloud/terraform.tfstate
	@cd $(makepwd)cloud-services/gcloud; \
	terraform output

$(makepwd)cloud-services/aws/terraform.tfstate:
	@cd $(makepwd)cloud-services/aws \
	test -e terraform.tfstate \
		&& exit 0; \
	terraform init

cloud-aws-apply: $(makepwd)cloud-services/aws/terraform.tfstate
	@cd $(makepwd)cloud-services/aws; \
	terraform apply -auto-approve -if-not-exists

cloud-aws-destroy:
	@cd $(makepwd)cloud-services/aws; \
	test -e terraform.tfstate \
		&& terraform apply -destroy -auto-approve \
		|| echo "nothing to destroy."

cloud-aws-output: $(makepwd)cloud-services/aws/terraform.tfstate
	@cd $(makepwd)cloud-services/gcloud; \
	terraform output

.PHONY: $(makepwd)cloud-services/gcloud/terraform.tfstate cloud-gcloud-apply cloud-gcloud-destroy cloud-gcloud-output \
		$(makepwd)cloud-services/aws/terraform.tfstate cloud-aws-apply cloud-aws-destroy cloud-aws-output
