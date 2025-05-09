.PHONY: help

help: ## Print command list
	@perl -nle'print $& if m{^[a-zA-Z0-9_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean:
	git clean -dxf

bootstrap: ## Bootstrap chezmoi
	chezmoi init

dotfiles: ## Update dotfiles
	chezmoi apply -i files

apply: ## Run chezmoi apply
	@chezmoi apply -v
