.PHONY: help build-playground test-playground docker-clean
.DEFAULT_GOAL := help

help: ## Display this help
	@grep -E '^[a-zA-Z_0-9]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	    awk 'BEGIN {FS = ":.*?## "} {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | \
	    sed -e 's/\[//g' -e 's/\]//g'

build-playground: ## Build and run the playground container locally
	docker compose run --rm --build playground-local

test-playground: ## Run the test stage for the playground image
	docker build --no-cache --target test playground/

build-mdbook: ## Build and run the mdbook container locally
	docker compose run --rm --build mdbook-local

test-mdbook: ## Run the test stage for the mdbook image
	docker build --no-cache --target test mdbook/

build-robotframework: ## Build and run the robotframework container locally
	docker compose run --rm --build robotframework-local

test-robotframework: ## Run the test stage for the robotframework image
	docker build --no-cache --target test robotframework/

clean-images: ## Clean intermediate images
	docker image prune --force

clean-builder: ## Clean the builder cache (takes a while)
	docker builder prune --force
