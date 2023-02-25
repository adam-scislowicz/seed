extropicwd := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

$(extropicwd)cloud-services/gcloud/terraform.tfstate:
	@cd $(extropicwd)cloud-services/gcloud; \
	test -e terraform.tfstate \
		&& exit 0; \
	terraform init

extropic-net-apply: $(extropicwd)cloud-services/gcloud/terraform.tfstate
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
			--stack-name extropic-net-iam ||:;\
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation delete-stack \
			--stack-name extropic-net-lander ||:;

extropic-net-info: $(extropicwd)cloud-services/gcloud/terraform.tfstate
	@cd $(extropicwd)cloud-services/gcloud; \
		terraform output ||: ; \
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation list-stack-resources \
			--stack-name extropic-net-iam ||:;
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation describe-stacks --stack-name extropic-net-iam ||: ; \
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation list-stack-resources \
			--stack-name extropic-net-lander ||:;

$(extropicwd)xnetworks-controld/xnetworks-controld:
	cd $(extropicwd)xnetworks-controld; \
		go mod download \
		&& go get xnetworks-controld \
		&& go build -buildvcs=false

xnetworks-controld: $(extropicwd)xnetworks-controld/xnetworks-controld

extropic-net-iam: $(extropicwd)xnetworks-controld/xnetworks-controld
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation create-stack \
			--stack-name extropic-net-iam \
			--template-body file://iam.cf.yaml \
			--capabilities CAPABILITY_IAM ||:;
	cd $(extropicwd)cloud-services/aws; \
		aws cloudformation list-stack-resources \
			--stack-name extropic-net-iam ||:;
	#aws sts assume-role --role-arn $ROLE_ARN \
    #	--role-session-name semiautonomous-extropic-networks

clean::
	cd $(extropicwd)xnetworks-controld; \
		rm -f go.sum xnetworks-controld || :;

.PHONY: $(extropicwd)cloud-services/gcloud/terraform.tfstate \
	clean extropic-net-apply extropic-net-destroy extropic-net-iam extropic-net-info
