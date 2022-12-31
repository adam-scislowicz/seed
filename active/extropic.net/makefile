extropicwd := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

$(extropicwd)cloud-services/gcloud/terraform.tfstate:
	@cd $(extropicwd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& exit 0; \
	terraform init

extropic-net-apply: $(extropicwd)cloud-services/gcloud/terraform.tfstate
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation create-stack \
			--stack-name extropic-net-core \
			--template-body file://core.cf.yaml \
			--capabilities CAPABILITY_IAM ||:;
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation create-stack \
			--stack-name extropic-net-lander \
			--template-body file://lander.cf.yaml \
			--parameters file://parameters.json ||:
# Temporarily disable terraform
#@cd $(extropicwd)cloud-services/gcloud;
#terraform apply -auto-approve;

extropic-net-destroy:
	@cd $(extropicwd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& terraform apply -destroy -auto-approve \
		|| echo "nothing to destroy.";
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation delete-stack \
			--stack-name extropic-net-core ||:;\
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation delete-stack \
			--stack-name extropic-net-lander ||:;
	

#aws cloudformation validate-template --template-body file://lander.cf.yaml;

extropic-net-output: $(extropicwd)cloud-services/gcloud/terraform.tfstate
	@cd $(extropicwd)cloud-services/gcloud; \
	terraform output

.PHONY: $(extropicwd)cloud-services/gcloud/terraform.tfstate \
	extropic-net-apply extropic-net-destroy extropic-net-output
