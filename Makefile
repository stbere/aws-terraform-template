BUCKET_NAME := aws-terraform-s3-bucket
REGION := us-east-1
DYNAMO_DB := aws-terraform--state-live-lock
AWS_PROFILE := dev
CUR_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := help
help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: ## Clean initialisation of terraform against backend s3 bucket
	terraform init -reconfigure -backend-config="bucket=${BUCKET_NAME}"

.PHONY: plan
plan: ## Creates plan
	terraform plan -out=tfplan

.PHONY: apply
apply: ## Apply terraform plan
	terraform apply tfplan

.PHONY: fmt
fmt: ## Formats terraform code
	terraform fmt -recursive

.PHONY: test
test: ## Rudimentary test for terraform code
	terraform fmt -check
	terraform validate

.PHONY: lint
lint: ## Runs terraform linter against the code
	tflint ${CUR_DIR}
	
.PHONY: audit
audit: ## Audits terraform code against any security issues
	tfsec ${CUR_DIR}

.PHONY: bootstrap
bootstrap: ## Bootstrapping AWS to be managed using Terraform
	bash bootstrap/bootstrap.sh -b ${BUCKET_NAME} \
								-e ${AWS_PROFILE} \
								-r ${REGION} \
								-d ${DYNAMO_DB}

