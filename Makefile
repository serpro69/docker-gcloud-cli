.DEFAULT_GOAL := help

.PHONY: build
build: ## builds docker image
	docker build -t serpro69/google-cloud-cli:$$(git rev-parse --short HEAD) .
	docker tag serpro69/google-cloud-cli:$$(git rev-parse --short HEAD) serpro69/google-cloud-cli:latest 

.PHONY: publish
publish: build ## publish docker image
	docker push serpro69/google-cloud-cli:$$(git rev-parse --short HEAD)
	docker push serpro69/google-cloud-cli:latest 

.PHONY: help
help: ## Displays this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
