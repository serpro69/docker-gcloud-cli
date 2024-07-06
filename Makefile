.DEFAULT_GOAL := help
.PHONY: build help publish

GIT_HASH=$(shell git rev-parse --short HEAD)

help: ## Displays this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## builds docker image
	docker build -t serpro69/google-cloud-cli:build .

clean: # clean up build image
	docker rmi serpro69/google-cloud-cli:build

publish-hash: build ## publish docker image with current git commit tag
	docker tag serpro69/google-cloud-cli:build serpro69/google-cloud-cli:$(GIT_HASH)
	docker push serpro69/google-cloud-cli:$(GIT_HASH)

publish-latest: build ## publish docker image with latest tag
	docker tag serpro69/google-cloud-cli:build serpro69/google-cloud-cli:latest
	docker push serpro69/google-cloud-cli:latest 
