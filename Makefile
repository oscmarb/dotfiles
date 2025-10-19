MAKEFLAGS += --no-print-directory
.EXPORT_ALL_VARIABLES:

.PHONY: help
help:
ifeq ($(shell uname -s), Linux)
	@grep -P '^[a-zA-Z_-]+:.*?\#\# .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?\#\# "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
else
	@awk -F ':.*\#\#' '$$0 ~ FS {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) 
endif

.PHONY: install
install: ## Install dotfiles
	@bash ./installation/install

install-references: ## Install references
	@bash ./installation/install_references

set-permissions: ## Set permissions for scripts, aliases, completions, and installation
	@find "./scripts" -type f -exec chmod +x {} \;
	@find "./private/dotfiles/shell/aliases" -type f -exec chmod +x {} \;
	@find "./shell/aliases" -type f -exec chmod +x {} \;
	@find "./shell/completions" -type f -exec chmod +x {} \;
	@find "./installation" -type f -exec chmod +x {} \;

exec-ubuntu: ## Exec ubuntu container with dotfiles dependencies installed
	@echo 'FROM ubuntu:latest \n RUN apt update && apt install -y git curl unzip make sudo \n RUN echo "ALL ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/nopasswd' | docker build -t dotfiles-ubuntu - > /dev/null
	@docker run -u 0 --rm -v .:/root/.dotfiles -w /root/.dotfiles -it dotfiles-ubuntu

validate-bash:
	@shellcheck ./scripts/**/* ./shell/aliases/**/* ./shell/completions/**/* ./installation/**/*

pre-commit:
	@set-permissions
	@validate-bash

