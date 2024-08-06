##
## Variables
## -----
##

RENOVATE_VERSION=38

##
## Project
## -----
##

.PHONY: install
install: .git/hooks/pre-commit ## Install the project

.PHONY: validate-config
validate-config: ## Validate the config
	@npx --yes --package renovate@${RENOVATE_VERSION} -- renovate-config-validator --strict *.json

##
## Git hooks
## -----------------
##

check-lefthook-is-installed:
ifndef CI
ifdef IS_DEV_ENV
ifeq (, $(shell which lefthook))
$(error "lefthook is missing, see https://github.com/evilmartians/lefthook/blob/master/docs/install.md")
endif
endif
endif

.PHONY: pre-commit
pre-commit: check-lefthook-is-installed ## Run pre-commit hook
	@lefthook run pre-commit

##
## rules based on files
## -----
##

.git/hooks/pre-commit: check-lefthook-is-installed
ifndef CI
	@lefthook install
endif

##
## Makefile
## -----
##

.DEFAULT_GOAL := help
default: help

.PHONY: help
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
