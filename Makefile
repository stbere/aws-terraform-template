.DEFAULT_GOAL := help
help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: bootstrap
bootstrap: ## Bootstrapping AWS to be managed using Terraform
	bash bootstrap/bootstrap.sh -b terraform-bucket \
								-e dev \
								-r us-east-1 \
								-d teraform-state-lock