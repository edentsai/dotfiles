SHELL := /bin/sh -o nounset -o errexit
MAKEFLAGS += --warn-undefined-variables

# Reference: https://suva.sh/posts/well-documented-makefiles/
.DEFAULT_GOAL := help
.PHONY += help
help: ## Display help message
help: _display-help-for-public-targets

.PHONY += _help
_help: ## Display help message for private targets
_help: _display-help-for-private-targets

# Find private targets with description by regular expression in AWK:
#   Pattern> _Target: ## Description
.PHONY += _display-help-for-private-targets
_display-help-for-private-targets: ## Display help message for private targets
_display-help-for-private-targets: HELP_AWK_REGEXP_TARGET_WITH_DESCRIPTION := /^\_[a-zA-Z0-9\_\-\%]+:.*?\#\#/
_display-help-for-private-targets: HELP_AWK_ALIGN_RESERVED_CHARS = 40
_display-help-for-private-targets:
	@awk '$(HELP_AWK_SCRIPT)' $(MAKEFILE_LIST);

# Find targets with description by regular expression in AWK:
#   Pattern> Target: ## Description
.PHONY += _display-help-for-public-targets
_display-help-for-public-targets: ## Display help message for public targets
_display-help-for-public-targets: HELP_AWK_REGEXP_TARGET_WITH_DESCRIPTION := /^[a-zA-Z][a-zA-Z0-9\_\-]+:.*?\#\#/
_display-help-for-public-targets: HELP_AWK_ALIGN_RESERVED_CHARS = 30
_display-help-for-public-targets:
	@awk '$(HELP_AWK_SCRIPT)' $(MAKEFILE_LIST);

define HELP_AWK_SCRIPT
	BEGIN { \
		FS = ":.*##"; \
		printf "Usage: \n"; \
		printf "    make \033[36m<target>\033[0m \n"; \
		printf "\n"; \
		printf "Targets: \n"; \
		last_target = ""; \
	} \
	$(HELP_AWK_REGEXP_TARGET_WITH_DESCRIPTION) { \
		target = $$1; \
		description = $$2; \
		gsub(/^[[:space:]]/, "", target); \
		gsub(/^[[:space:]]/, "", description); \
		name = (target == last_target) ? "" : target; \
		printf "    \033[36m%-$(HELP_AWK_ALIGN_RESERVED_CHARS)s  \033[0m%s \n", name, description; \
		last_target = target; \
	} \
	END { \
		printf "\n"; \
	}
endef
