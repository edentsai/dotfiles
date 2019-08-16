SHELL := /bin/sh -o nounset -o errexit
MAKEFLAGS += --warn-undefined-variables

USER_PUID ?= $(shell id -u)
USER_PGID ?= $(shell id -g)
USER_HOME ?= $(abspath $(HOME))

ROOT_MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_DIR := $(shell dirname $(ROOT_MAKEFILE))
PROJECT_NAME ?= $(shell basename $(PROJECT_DIR))
PROJECT_NAMESPACE ?= $(shell whoami)
PROJECT_PATH ?= $(PROJECT_NAMESPACE)/$(PROJECT_NAME)
PROJECT_PATH_SLUG := $(subst /,-,$(PROJECT_PATH))

BACKUP_TIMESTAMP := $(shell date +%Y-%m-%dT%T%z)

EXIT_CODE_GENERAL_ERROR := 1

TEXT_OK := [OK]
TEXT_INFO := [INFO]
TEXT_ERROR := [ERROR]
SUPPORTED_COLOR := $(shell tput colors > /dev/null 2>&1 && echo -n "yes" || echo -n "no")
ifeq ("$(SUPPORTED_COLOR)", "yes")
	TEXT_COLOR_NONE := \033[0m
	TEXT_COLOR_RED := \033[0;31m
	TEXT_COLOR_GREEN := \033[0;32m
	TEXT_COLOR_CYAN := \033[0;36m

	TEXT_OK := $(TEXT_COLOR_GREEN)$(TEXT_OK)$(TEXT_COLOR_NONE)
	TEXT_INFO := $(TEXT_COLOR_CYAN)$(TEXT_INFO)$(TEXT_COLOR_NONE)
	TEXT_ERROR := $(TEXT_COLOR_RED)$(TEXT_ERROR)$(TEXT_COLOR_NONE)
endif

DOTFILES_DIR ?= $(PROJECT_DIR)
DOTFILES_DIR_TARGET_LINK ?= $(USER_HOME)/.dotfiles
SSH_DIR ?= $(PROJECT_DIR)/src/ssh
SSH_DIR_TARGET_LINK ?= $(USER_HOME)/.ssh

.PHONY: all
all: ## Backup existing configurations and install
all: backup
all: install

.PHONY: backup
backup: ## Backup existing configurations
backup: backup-bash
backup: backup-bin
backup: backup-dotfiles
# backup: backup-fonts
# backup: backup-git
# backup: backup-inputrc
# backup: backup-mostrc
# backup: backup-mycli
# backup: backup-mysql
# backup: backup-pgcli
# backup: backup-screen
# backup: backup-tig
# backup: backup-tmux
# backup: backup-vim

.PHONY: backup-bash
backup-bash: ## Backup Bash configurations
backup-bash: _backup-bash-target-path-if-different
backup-bash: _backup-bash-profile-target-path-if-different
backup-bash: _backup-bash-logout-target-path-if-different
backup-bash: _backup-bashrc-target-path-if-different
backup-bash: _backup-bashrc-local-target-path-if-different

.PHONY: backup-bin
backup-bin: ## Backup Bin directory
backup-bin: _backup-bin-target-path-if-different


.PHONY: backup-dotfiles
backup-dotfiles: ## Backup existing dotfiles
backup-dotfiles: _backup-dotfiles-target-path-if-different

.PHONY: backup-git
backup-git: ## Backup existing Git configurations
backup-git: _backup-gitconfig-target-path-if-different
backup-git: _backup-gitconfig-local-target-path-if-different
backup-git: _backup-gitignore-target-path-if-different

.PHONY: backup-ssh
backup-ssh: ## Backup existing SSH configurations
backup-ssh: _backup-ssh-target-path-if-different

.PHONY: install
install: ## Install all of symbolic links.
install: install-bash
install: install-bin
install: install-dotfiles
# install: install-fonts
# install: install-git
# install: install-homebrew
# install: install-inputrc
# install: install-mostrc
# install: install-mycli
# install: install-mysql
# install: install-pgcli
# install: install-screen
# install: install-tig
# install: install-tmux
# install: install-vim

.PHONY: install-bash
install-bash: ## Install symbolic links for Bash configurations
install-bash: _error-if-bash-source-path-not-exists         _error-if-bash-target-path-different
install-bash: _error-if-bash-logout-source-path-not-exists  _error-if-bash-logout-target-path-different
install-bash: _error-if-bash-profile-source-path-not-exists _error-if-bash-profile-target-path-different
install-bash: _error-if-bashrc-source-path-not-exists       _error-if-bashrc-target-path-different
install-bash: _error-if-bashrc-local-source-path-not-exists _error-if-bashrc-local-target-path-different
install-bash: _install-bash-link-if-not-installed
install-bash: _install-bash-logout-link-if-not-installed
install-bash: _install-bash-profile-link-if-not-installed
install-bash: _install-bashrc-link-if-not-installed
install-bash: _install-bashrc-local-link-if-not-installed

.PHONY: install-bin
install-bin: ## Install symbolic links for Bin scripts
install-bin: _install-bin-link-if-not-installed

.PHONY: install-dotfiles
install-dotfiles: ## Install symbolic links for dotfiles
install-dotfiles: _install-dotfiles-link-if-not-installed

.PHONY: install-fonts
install-fonts: ## Install symbolic links for Fonts
install-fonts: _install-fonts-link-if-not-installed

.PHONY: install-git
install-git: ## Install symbolic links for Git configurations
install-git: _install-gitconfig-link-if-not-installed
install-git: _install-gitconfig-local-link-if-not-installed
install-git: _install-gitignore-link-if-not-installed

.PHONY: install-homebrew
install-homebrew: ## Install symbolic links for Homebrew confugrations on MacOS only
install-homebrew: _install-homebrew-link-if-not-installed

.PHONY: install-inputrc
install-inputrc: ## Install symbolic links for Inputrc (GNU Readline)
install-inputrc: _install-inputrc-link-if-not-installed

.PHONY: install-ssh
install-ssh: ## Install symbolic links for SSH configurations
install-ssh: _install-ssh-link-if-not-installed

.PHONY: uninstall
uninstall: ## Delete all of symbolic links which created by Makefile
uninstall: uninstall-bash
uninstall: uninstall-bin
uninstall: uninstall-dotfiles
# uninstall: uninstall-fonts
# uninstall: uninstall-git
# uninstall: uninstall-inputrc
# uninstall: uninstall-mostrc
# uninstall: uninstall-mycli
# uninstall: uninstall-mysql
# uninstall: uninstall-pgcli
# uninstall: uninstall-screen
# uninstall: uninstall-tig
# uninstall: uninstall-tmux
# uninstall: uninstall-vim

.PHONY: uninstall-bash
uninstall-bash: ## Delete the symbolic links of Bash configurations
uninstall-bash: _uninstall-bash-link-if-installed
uninstall-bash: _uninstall-bash-logout-link-if-installed
uninstall-bash: _uninstall-bash-profile-link-if-installed
uninstall-bash: _uninstall-bashrc-link-if-installed
uninstall-bash: _uninstall-bashrc-local-link-if-installed

.PHONY: uninstall-bin
uninstall-bin: ## Delete the symbolic links of bin directory
uninstall-bin: _uninstall-bin-link-if-installed

.PHONY: uninstall-dotfiles
uninstall-dotfiles: ## Delete the symbolic links of dotfiles
uninstall-dotfiles: _uninstall-dotfiles-link-if-installed

.PHONY: uninstall-git
uninstall-git: ## Delete the symbolic links of Git configurations
uninstall-git: _uninstall-gitconfig-link-if-installed
uninstall-git: _uninstall-gitconfig-local-link-if-installed
uninstall-git: _uninstall-gitignore-link-if-installed

_backup-%-target-path-if-different: ## Backup `%` target path if exists and different
_backup-%-target-path-if-different: NAME ?= $(*)
_backup-%-target-path-if-different: SOURCE_PATH ?= $(PROJECT_PATH)
_backup-%-target-path-if-different: TARGET_PATH ?= $(USER_HOME)/.dotfiles
_backup-%-target-path-if-different: BACKUP_TARGET_PATH ?= $(TARGET_PATH)-backup-at-$(BACKUP_TIMESTAMP)
_backup-%-target-path-if-different: BACKUP_LOG ?= $(PROJECT_PATH)/backup/backup-list-$(BACKUP_TIMESTAMP)
_backup-%-target-path-if-different:
	@# Backup $(TARGET_PATH) if exists and different
	@if test -e "$(TARGET_PATH)" \
		&& ! test "$(realpath $(TARGET_PATH))" = "$(realpath $(SOURCE_PATH))"; \
	then \
		echo "$(TEXT_INFO) Backup the existing and different target path: $(TARGET_PATH)"; \
		mkdir -v -p "$(shell dirname $(BACKUP_LOG))"; \
		printf "%s\t%s\t%s\n" "$(NAME)" "$(TARGET_PATH)" "$(BACKUP_TARGET_PATH)" >> "$(BACKUP_LOG)"; \
		if ! mv -v -n "$(TARGET_PATH)" "$(BACKUP_TARGET_PATH)"; then \
			echo "$(TEXT_ERROR) Backup the existing target path failed" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
	fi; \

_error-if-%-source-path-not-exists: ## Throw error if `%` source path not exists
_error-if-%-source-path-not-exists: NAME ?= $(*)
_error-if-%-source-path-not-exists: SOURCE_PATH ?= $(PROJECT_DIR)
_error-if-%-source-path-not-exists:
	@# Throw error if $(SOURCE_PATH) source path not exists
	@if ! test -e "$(SOURCE_PATH)"; then \
		echo "$(TEXT_ERROR) The source path '$(SOURCE_PATH)" > /dev/stderr; \
		exit $(EXIT_CODE_GENERAL_ERROR); \
	fi; \

_error-if-%-target-path-different: ## Throw error if `%` target path is exists and different
_error-if-%-target-path-different: NAME ?= $(*)
_error-if-%-target-path-different: SOURCE_PATH ?= $(PROJECT_DIR)
_error-if-%-target-path-different: TARGET_PATH ?= $(USER_HOME)/.dotfiles
_error-if-%-target-path-different:
	@# Throw error if $(TARGET_PATH) is exists and different
	@if test -e "$(TARGET_PATH)" \
		&& ! test "$(realpath $(TARGET_PATH))" = "$(realpath $(SOURCE_PATH))"; \
	then \
		echo "$(TEXT_ERROR) Please backup the existing '$(TARGET_PATH)' before install $(NAME)" > /dev/stderr; \
		exit $(EXIT_CODE_GENERAL_ERROR); \
	fi; \

_install-%-link-if-not-installed: ## Install a symbolic link for `%` if not installed
_install-%-link-if-not-installed: NAME ?= $(*)
_install-%-link-if-not-installed: SOURCE_PATH ?= $(PROJECT_DIR)
_install-%-link-if-not-installed: TARGET_PATH ?= $(USER_HOME)/.dotfiles
_install-%-link-if-not-installed: _error-if-%-source-path-not-exists _error-if-%-target-path-different
	@# Install a symbolic link for `%` if not installed
	@if ! test -e "$(TARGET_PATH)"; then \
		echo "$(TEXT_INFO) Create symbolic links for $(NAME)"; \
		if ! ln -v -s -T "$(SOURCE_PATH)" "$(TARGET_PATH)"; then \
			echo "$(TEXT_ERROR) Create symbolic link failed" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
	fi; \

_uninstall-%-link-if-installed: ## Delete the symbolic link for `%` if installed
_uninstall-%-link-if-installed: NAME ?= $(*)
_uninstall-%-link-if-installed: SOURCE_PATH ?= $(PROJECT_DIR)
_uninstall-%-link-if-installed: TARGET_PATH ?= $(USER_HOME)/.dotfiles
_uninstall-%-link-if-installed:
	@# Delete the symbolic link $(TARGET_PATH) if installed
	@if test -e "$(TARGET_PATH)" \
		&& test "$(realpath $(TARGET_PATH))" = "$(realpath $(SOURCE_PATH))"; \
	then \
		echo "$(TEXT_INFO) Remove the symbolic links of $(NAME)"; \
		if ! rm -v "$(TARGET_PATH)"; then \
			echo "$(TEXT_ERROR) Remove symbolic links failed" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
	fi; \

bash_implicit_targets += _backup-bash-target-path-if-different
bash_implicit_targets += _error-if-bash-source-path-not-exists
bash_implicit_targets += _error-if-bash-target-path-different
bash_implicit_targets += _install-bash-link-if-not-installed
bash_implicit_targets += _uninstall-bash-link-if-installed
$(bash_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/src/bash
$(bash_implicit_targets): TARGET_PATH := $(USER_HOME)/.bash
$(bash_implicit_targets):

bash_profile_implicit_targets += _backup-bash-profile-target-path-if-different
bash_profile_implicit_targets += _error-if-bash-profile-source-path-not-exists
bash_profile_implicit_targets += _error-if-bash-profile-target-path-different
bash_profile_implicit_targets += _install-bash-profile-link-if-not-installed
bash_profile_implicit_targets += _uninstall-bash-profile-link-if-installed
$(bash_profile_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/src/bash/bash_profile
$(bash_profile_implicit_targets): TARGET_PATH := $(USER_HOME)/.bash_profile
$(bash_profile_implicit_targets):

bash_logout_implicit_targets += _backup-bash-logout-target-path-if-different
bash_logout_implicit_targets += _error-if-bash-logout-source-path-not-exists
bash_logout_implicit_targets += _error-if-bash-logout-target-path-different
bash_logout_implicit_targets += _install-bash-logout-link-if-not-installed
bash_logout_implicit_targets += _uninstall-bash-logout-link-if-installed
$(bash_logout_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/src/bash/bash_logout
$(bash_logout_implicit_targets): TARGET_PATH := $(USER_HOME)/.bash_logout
$(bash_logout_implicit_targets):

bashrc_implicit_targets += _backup-bashrc-target-path-if-different
bashrc_implicit_targets += _error-if-bashrc-source-path-not-exists
bashrc_implicit_targets += _error-if-bashrc-target-path-different
bashrc_implicit_targets += _install-bashrc-link-if-not-installed
bashrc_implicit_targets += _uninstall-bashrc-link-if-installed
$(bashrc_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/src/bash/bashrc
$(bashrc_implicit_targets): TARGET_PATH := $(USER_HOME)/.bashrc
$(bashrc_implicit_targets):

bashrc_local_implicit_targets += _backup-bashrc-local-target-path-if-different
bashrc_local_implicit_targets += _error-if-bashrc-local-source-path-not-exists
bashrc_local_implicit_targets += _error-if-bashrc-local-target-path-different
bashrc_local_implicit_targets += _install-bashrc-local-link-if-not-installed
bashrc_local_implicit_targets += _uninstall-bashrc-local-link-if-installed
$(bashrc_local_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/src/bash/bashrc_local
$(bashrc_local_implicit_targets): TARGET_PATH := $(USER_HOME)/.bashrc-local
$(bashrc_local_implicit_targets):

bin_implicit_targets += _backup-bin-target-path-if-different
bin_implicit_targets += _error-if-bin-source-path-not-exists
bin_implicit_targets += _error-if-bin-target-path-different
bin_implicit_targets += _install-bin-link-if-not-installed
bin_implicit_targets += _uninstall-bin-link-if-installed
$(bin_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/bin
$(bin_implicit_targets): TARGET_PATH := $(USER_HOME)/.bin
$(bin_implicit_targets):

dotfiles_implicit_targets += _backup-dotfiles-target-path-if-different
dotfiles_implicit_targets += _error-if-dotfiles-source-path-not-exists
dotfiles_implicit_targets += _error-if-dotfiles-target-path-different
dotfiles_implicit_targets += _install-dotfiles-link-if-not-installed
dotfiles_implicit_targets += _uninstall-dotfiles-link-if-installed
$(dotfiles_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)
$(dotfiles_implicit_targets): TARGET_PATH := $(USER_HOME)/.dotfiles
$(dotfiles_implicit_targets):

gitconfig_implicit_targets += _backup-gitconfig-target-path-if-different
gitconfig_implicit_targets += _error-if-gitconfig-source-path-not-exists
gitconfig_implicit_targets += _error-if-gitconfig-target-path-different
gitconfig_implicit_targets += _install-gitconfig-link-if-not-installed
gitconfig_implicit_targets += _uninstall-gitconfig-link-if-installed
$(gitconfig_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/src/git/gitconfig-asdflkjajsdf
$(gitconfig_implicit_targets): TARGET_PATH := $(USER_HOME)/.gitconfig
$(gitconfig_implicit_targets):

gitconfig_local_implicit_targets += _backup-gitconfig-local-target-path-if-different
gitconfig_local_implicit_targets += _error-if-gitconfig-local-source-path-not-exists
gitconfig_local_implicit_targets += _error-if-gitconfig-local-target-path-different
gitconfig_local_implicit_targets += _install-gitconfig-local-link-if-not-installed
gitconfig_local_implicit_targets += _uninstall-gitconfig-local-link-if-installed
$(gitconfig_local_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/src/git/gitconfig-local
$(gitconfig_local_implicit_targets): TARGET_PATH := $(USER_HOME)/.gitconfig-local
$(gitconfig_local_implicit_targets):

gitignore_implicit_targets += _backup-gitignore-target-path-if-different
gitignore_implicit_targets += _error-if-gitignore-source-path-not-exists
gitignore_implicit_targets += _error-if-gitignore-target-path-different
gitignore_implicit_targets += _install-gitignore-link-if-not-installed
gitignore_implicit_targets += _uninstall-gitignore-link-if-installed
$(gitignore_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/src/git/gitignore
$(gitignore_implicit_targets): TARGET_PATH := $(USER_HOME)/.gitignore
$(gitignore_implicit_targets):

ssh_implicit_targets += _backup-ssh-target-path-if-different
ssh_implicit_targets += _error-if-different-ssh-source-path-not-exists
ssh_implicit_targets += _error-if-different-ssh-target-path-different
ssh_implicit_targets += _install-ssh-link-if-not-installed
ssh_implicit_targets += _uninstall-ssh-link-if-installed
$(ssh_implicit_targets): SOURCE_PATH := $(PROJECT_DIR)/src/ssh
$(ssh_implicit_targets): TARGET_PATH := $(USER_HOME)/.ssh
$(ssh_implicit_targets):

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

.PHONY: clean
clean: ## Clean all of dependencies, containers, images and artficats that created by Makefile
clean: clean-docker-images

.PHONY: clean-docker-images
clean-docker-images: ## Clean all docker images which builded by Makefile
clean-docker-images: DOCKER_IMAGE_NAMESPACE ?= $(PROJECT_PATH)
clean-docker-images:
	@image_ids="$$(docker image list --quiet '$(DOCKER_IMAGE_NAMESPACE)/*')"; \
	if [ -n "$${image_ids}" ]; then \
		docker image list "$(DOCKER_IMAGE_NAMESPACE)/*"; \
		docker image rm $$(docker image list --quiet "$(DOCKER_IMAGE_NAMESPACE)/*"); \
		echo ''; \
	fi

_docker-image-build-%: ## Build an image by specific build stage in Dockerfile
_docker-image-build-%: DOCKERFILE ?= $(PROJECT_DIR)/Dockerfile
_docker-image-build-%: DOCKER_BUILDKIT ?= 1
_docker-image-build-%: DOCKER_BUILD_CONTEXT ?= $(PROJECT_DIR)
_docker-image-build-%: DOCKER_BUILD_STAGE ?= $(*)
_docker-image-build-%: DOCKER_BUILD_OPTS ?=
_docker-image-build-%: DOCKER_IMAGE_REPOSITORY ?= $(PROJECT_PATH)/$(DOCKER_BUILD_STAGE)
_docker-image-build-%: DOCKER_IMAGE_TAG ?= latest
_docker-image-build-%: DOCKER_IMAGE_WITH_TAG ?= $(DOCKER_IMAGE_REPOSITORY):$(DOCKER_IMAGE_TAG)
_docker-image-build-%: _docker-image-remove-%-if-exists
	@DOCKER_BUILDKIT=$(DOCKER_BUILDKIT) docker image build --pull \
		--file "$(DOCKERFILE)" \
		--target "$(DOCKER_BUILD_STAGE)" \
		--tag "$(DOCKER_IMAGE_WITH_TAG)" \
		--build-arg "VERSION=$(DOCKER_IMAGE_TAG)" \
		--build-arg "OS_TYPE=$(shell uname -s)" \
		--build-arg "USER_NAME=$(shell whoami)" \
		--build-arg "USER_PUID=$(shell id -u)" \
		--build-arg "USER_PGID=$(shell id -g)" \
		$(DOCKER_BUILD_OPTS) \
		"$(DOCKER_BUILD_CONTEXT)"; \
	echo "";

_docker-image-remove-%-if-exists: ## Remove the image which built by specific build stage in Dockerfile
_docker-image-remove-%-if-exists: DOCKER_BUILD_STAGE ?= $(*)
_docker-image-remove-%-if-exists: DOCKER_IMAGE_REPOSITORY ?= $(PROJECT_PATH)/$(DOCKER_BUILD_STAGE)
_docker-image-remove-%-if-exists: DOCKER_IMAGE_TAG ?= latest
_docker-image-remove-%-if-exists: DOCKER_IMAGE_WITH_TAG ?= $(DOCKER_IMAGE_REPOSITORY):$(DOCKER_IMAGE_TAG)
_docker-image-remove-%-if-exists:
	@image_ids="$$(docker image list --quiet '$(DOCKER_IMAGE_WITH_TAG)')"; \
	if [ -n "$${image_ids}" ]; then \
		docker image list "$(DOCKER_IMAGE_WITH_TAG)"; \
		docker image rm "$(DOCKER_IMAGE_WITH_TAG)"; \
		echo ""; \
	fi

_docker-container-run-%: ## Run a temporary container by the image
_docker-container-run-%: ## which built by specific build stage in Dockerfile
_docker-container-run-%: DOCKER_BUILD_STAGE ?= $(*)
_docker-container-run-%: DOCKER_IMAGE_REPOSITORY ?= $(PROJECT_PATH)/$(DOCKER_BUILD_STAGE)
_docker-container-run-%: DOCKER_IMAGE_TAG ?= latest
_docker-container-run-%: DOCKER_IMAGE_WITH_TAG ?= $(DOCKER_IMAGE_REPOSITORY):$(DOCKER_IMAGE_TAG)
_docker-container-run-%: DOCKER_CONTAINER_NAME ?= $(PROJECT_PATH_SLUG)-$(DOCKER_BUILD_STAGE)
_docker-container-run-%: DOCKER_CONTAINER_USER ?= $(USER_PUID):$(USER_PGID)
_docker-container-run-%: DOCKER_CONTAINER_WORKDIR ?= $(PROJECT_DIR)
_docker-container-run-%: DOCKER_CONTAINER_OPT_TTY ?= --tty
_docker-container-run-%: DOCKER_CONTAINER_OPTS ?=
_docker-container-run-%: DOCKER_CONTAINER_ARGS ?=
# FIXME
_docker-container-run-%: DOCKER_CONTAINER_WORKDIR := "/home/edentsai/workspace/github/dotfiles"
_docker-container-run-%: DOCKER_CONTAINER_OPTS += --volume "$(PROJECT_DIR):/home/edentsai/workspace/github/dotfiles"
_docker-container-run-%: DOCKER_CONTAINER_OPTS += --volume "$(PROJECT_DIR)/src/bash/tmp/histories/edentsai-dotfiles-ubuntu-workspace/bash-history-edentsai:/home/edentsai/.bash_history"
_docker-container-run-%:
	@docker container run --rm --interactive $(DOCKER_CONTAINER_OPT_TTY) \
		--name "$(DOCKER_CONTAINER_NAME)" \
		--hostname "$(DOCKER_CONTAINER_NAME)" \
		--user "$(DOCKER_CONTAINER_USER)" \
		--workdir "$(DOCKER_CONTAINER_WORKDIR)" \
		--volume "$(PROJECT_DIR):$(PROJECT_DIR)" \
		$(DOCKER_CONTAINER_OPTS) \
		"$(DOCKER_IMAGE_WITH_TAG)" $(DOCKER_CONTAINER_ARGS); \
	echo ""

_docker-image-build-ubuntu-workspace:
_docker-container-run-ubuntu-workspace:
