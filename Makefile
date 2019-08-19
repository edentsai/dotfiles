MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/sh
.SHELLFLAGS := -o nounset -o errexit -c
.SUFFIXES :=

USER_PUID ?= $(shell id -u)
USER_PGID ?= $(shell id -g)
USER_HOME ?= $(abspath $(HOME))
HOSTNAME ?= $(shell hostname)

ROOT_MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_DIR := $(shell dirname $(ROOT_MAKEFILE))
PROJECT_DIR_REALPATH := $(realpath $(PROJECT_DIR))
PROJECT_NAME ?= $(shell basename $(PROJECT_DIR))
PROJECT_NAMESPACE ?= $(shell whoami)
PROJECT_PATH ?= $(PROJECT_NAMESPACE)/$(PROJECT_NAME)
PROJECT_PATH_SLUG := $(subst /,-,$(PROJECT_PATH))

BACKUP_TIMESTAMP := $(shell date +%Y-%m-%dT%T%z)

EXIT_CODE_GENERAL_ERROR := 1

TEXT_OK := [OK]
TEXT_INFO := [INFO]
TEXT_ERROR := [ERROR]
SUPPORTED_COLOR := $(shell tput colors > /dev/null 2>&1 && echo "yes" || echo "no")
ifeq ("$(SUPPORTED_COLOR)", "yes")
	TEXT_COLOR_NONE := \033[0m
	TEXT_COLOR_RED := \033[0;31m
	TEXT_COLOR_GREEN := \033[0;32m
	TEXT_COLOR_CYAN := \033[0;36m

	TEXT_OK := $(TEXT_COLOR_GREEN)$(TEXT_OK)$(TEXT_COLOR_NONE)
	TEXT_INFO := $(TEXT_COLOR_CYAN)$(TEXT_INFO)$(TEXT_COLOR_NONE)
	TEXT_ERROR := $(TEXT_COLOR_RED)$(TEXT_ERROR)$(TEXT_COLOR_NONE)
endif

_%/$(HOME)/.bash:               SOURCE_PATH = $(PROJECT_DIR)/src/bash
_%/$(HOME)/.bash_logout:        SOURCE_PATH = $(PROJECT_DIR)/src/bash/bash_logout
_%/$(HOME)/.bash_profile:       SOURCE_PATH = $(PROJECT_DIR)/src/bash/bash_profile
_%/$(HOME)/.bashrc:             SOURCE_PATH = $(PROJECT_DIR)/src/bash/bashrc
_%/$(HOME)/.bashrc_local:       SOURCE_PATH = $(PROJECT_DIR)/src/bash/bashrc_local
_%/$(HOME)/.bin:                SOURCE_PATH = $(PROJECT_DIR)/bin
_%/$(HOME)/.curlrc:             SOURCE_PATH = $(PROJECT_DIR)/src/curl/curlrc
_%/$(HOME)/.dotfiles:           SOURCE_PATH = $(PROJECT_DIR)
_%/$(HOME)/.fonts:              SOURCE_PATH = $(PROJECT_DIR)/src/fonts
_%/$(HOME)/.git:                SOURCE_PATH = $(PROJECT_DIR)/src/git
_%/$(HOME)/.gitconfig:          SOURCE_PATH = $(PROJECT_DIR)/src/git/gitconfig
_%/$(HOME)/.gitconfig_local:    SOURCE_PATH = $(PROJECT_DIR)/src/git/gitconfig_local
_%/$(HOME)/.gitignore:          SOURCE_PATH = $(PROJECT_DIR)/src/git/gitignore
_%/$(HOME)/.inputrc:            SOURCE_PATH = $(PROJECT_DIR)/src/readline/inputrc
_%/$(HOME)/.mostrc:             SOURCE_PATH = $(PROJECT_DIR)/src/most/mostrc
_%/$(HOME)/.my.cnf:             SOURCE_PATH = $(PROJECT_DIR)/src/mysql/my.cnf
_%/$(HOME)/.mycli:              SOURCE_PATH = $(PROJECT_DIR)/src/mycli
_%/$(HOME)/.myclirc:            SOURCE_PATH = $(PROJECT_DIR)/src/mycli/myclirc
_%/$(HOME)/.mysql:              SOURCE_PATH = $(PROJECT_DIR)/src/mysql
_%/$(HOME)/.npm:                SOURCE_PATH = $(PROJECT_DIR)/src/npm
_%/$(HOME)/.npmrc:              SOURCE_PATH = $(PROJECT_DIR)/src/npm/npmrc
_%/$(HOME)/.pgcli:              SOURCE_PATH = $(PROJECT_DIR)/src/pgcli
_%/$(HOME)/.pgclirc:            SOURCE_PATH = $(PROJECT_DIR)/src/pgcli/pgclirc
_%/$(HOME)/.screenrc:           SOURCE_PATH = $(PROJECT_DIR)/src/screen/screenrc
_%/$(HOME)/.ssh/config:         SOURCE_PATH = $(PROJECT_DIR)/src/ssh/config
_%/$(HOME)/.ssh/config_local:   SOURCE_PATH = $(PROJECT_DIR)/src/ssh/config_local
_%/$(HOME)/.tig:                SOURCE_PATH = $(PROJECT_DIR)/src/tig
_%/$(HOME)/.tigrc:              SOURCE_PATH = $(PROJECT_DIR)/src/tig/tigrc
_%/$(HOME)/.tmux.conf:          SOURCE_PATH = $(PROJECT_DIR)/src/tmux/tmux.conf
_%/$(HOME)/.tmux:               SOURCE_PATH = $(PROJECT_DIR)/src/tmux
_%/$(HOME)/.vim:                SOURCE_PATH = $(PROJECT_DIR)/src/vim
_%/$(HOME)/.vimrc:              SOURCE_PATH = $(PROJECT_DIR)/src/vim/_vimrc
_%/$(HOME)/.vimrc_local:        SOURCE_PATH = $(PROJECT_DIR)/src/vim/_vimrc_local

dotfiles_target_paths  += $(HOME)/.dotfiles
bin_target_paths       += $(HOME)/.bin
bash_target_paths      += $(HOME)/.bash
bash_target_paths      += $(HOME)/.bash_logout
bash_target_paths      += $(HOME)/.bash_profile
bash_target_paths      += $(HOME)/.bashrc
bash_target_paths      += $(HOME)/.bashrc_local
curl_target_paths      += $(HOME)/.curlrc
fonts_target_paths     += $(HOME)/.fonts
git_target_paths       += $(HOME)/.git
git_target_paths       += $(HOME)/.gitconfig
git_target_paths       += $(HOME)/.gitconfig_local
git_target_paths       += $(HOME)/.gitignore
most_target_paths      += $(HOME)/.mostrc
mycli_target_paths     += $(HOME)/.mycli
mycli_target_paths     += $(HOME)/.myclirc
mysql_target_paths     += $(HOME)/.mysql
mysql_target_paths     += $(HOME)/.my.cnf
npm_target_paths       += $(HOME)/.npm
npm_target_paths       += $(HOME)/.npmrc
pgcli_target_paths     += $(HOME)/.pgcli
pgcli_target_paths     += $(HOME)/.pgclirc
readline_target_paths  += $(HOME)/.inputrc
screen_target_paths    += $(HOME)/.screenrc
ssh_target_paths       += $(HOME)/.ssh/config
ssh_target_paths       += $(HOME)/.ssh/config_local
tig_target_paths       += $(HOME)/.tig
tig_target_paths       += $(HOME)/.tigrc
tmux_target_paths      += $(HOME)/.tmux
tmux_target_paths      += $(HOME)/.tmux.conf
vim_target_paths       += $(HOME)/.vim
vim_target_paths       += $(HOME)/.vimrc
vim_target_paths       += $(HOME)/.vimrc_local

.PHONY: all
all: ## Backup existing configurations and install
all: backup
all: install

.PHONY: backup
backup: ## Backup existing all configurations at target paths.
backup: backup-dotfiles
backup: backup-bin
backup: backup-bash
backup: backup-curl
backup: backup-fonts
backup: backup-git
backup: backup-most
backup: backup-mycli
backup: backup-mysql
backup: backup-npm
backup: backup-pgcli
backup: backup-readline
backup: backup-screen
backup: backup-ssh
backup: backup-tig
backup: backup-tmux
backup: backup-vim

.PHONY: backup-dotfiles
backup-dotfiles: ## Backup existing target path of dotfiles in $HOME/
backup-dotfiles: $(dotfiles_target_paths:%=_backup/%)

.PHONY: backup-bin
backup-bin: ## Backup existing target path of bin in $HOME/
backup-bin: $(bin_target_paths:%=_backup/%)

.PHONY: backup-bash
backup-bash: ## Backup existing target path of src/bash in $HOME/
backup-bash: $(bash_target_paths:%=_backup/%)

.PHONY: backup-curl
backup-curl: ## Backup existing target path of src/curl in $HOME/
backup-curl: $(curl_target_paths:%=_backup/%)

.PHONY: backup-fonts
backup-fonts: ## Backup existing target path of src/fonts in $HOME/
backup-fonts: $(fonts_target_paths:%=_backup/%)

.PHONY: backup-git
backup-git: ## Backup existing target path of src/git in $HOME/
backup-git: $(git_target_paths:%=_backup/%)

.PHONY: backup-most
backup-most: ## Backup existing target path of src/most in $HOME/
backup-most: $(most_target_paths:%=_backup/%)

.PHONY: backup-mycli
backup-mycli: ## Backup existing target path of src/mycli in $HOME/
backup-mycli: $(mycli_target_paths:%=_backup/%)

.PHONY: backup-mysql
backup-mysql: ## Backup existing target path of src/mysql in $HOME/
backup-mysql: $(mysql_target_paths:%=_backup/%)

.PHONY: backup-npm
backup-npm: ## Backup existing target path of src/npm in $HOME/
backup-npm: $(npm_target_paths:%=_backup/%)

.PHONY: backup-pgcli
backup-pgcli: ## Backup existing target path of src/pgcli in $HOME/
backup-pgcli: $(pgcli_target_paths:%=_backup/%)

.PHONY: backup-readline
backup-readline: ## Backup existing target path of src/readline in $HOME/
backup-readline: $(readline_target_paths:%=_backup/%)

.PHONY: backup-screen
backup-screen: ## Backup existing target path of src/screen in $HOME/
backup-screen: $(screen_target_paths:%=_backup/%)

.PHONY: backup-ssh
backup-ssh: ## Backup existing target path of src/ssh in $HOME/
backup-ssh: $(ssh_target_paths:%=_backup/%)

.PHONY: backup-tig
backup-tig: ## Backup existing target path of src/tig in $HOME/
backup-tig: $(tig_target_paths:%=_backup/%)

.PHONY: backup-tmux
backup-tmux: ## Backup existing target path of src/tmux in $HOME/
backup-tmux: $(tmux_target_paths:%=_backup/%)

.PHONY: backup-vim
backup-vim: ## Backup existing target path of src/vim in $HOME/
backup-vim: $(vim_target_paths:%=_backup/%)

.PHONY: install
install: ## Install symbolic links of all configurations into $HOME/
install: install-dotfiles
install: install-bin
install: install-bash
install: install-curl
install: install-fonts
install: install-git
install: install-most
install: install-mycli
install: install-mysql
install: install-npm
install: install-pgcli
install: install-readline
install: install-screen
install: install-ssh
install: install-tig
install: install-tmux
install: install-vim

.PHONY: install-dotfiles
install-dotfiles: ## Install symbolic links of $PROJECT_DIR into $HOME/
install-dotfiles: $(dotfiles_target_paths:%=_install-link/%)

.PHONY: install-bin
install-bin: ## Install symbolic links of bin into $HOME/
install-bin: $(bin_target_paths:%=_install-link/%)

.PHONY: install-bash
install-bash: ## Install symbolic links of src/bash into $HOME/
install-bash: $(bash_target_paths:%=_install-link/%)

.PHONY: install-curl
install-curl: ## Install symbolic links of src/curl into $HOME/
install-curl: $(curl_target_paths:%=_install-link/%)

.PHONY: install-fonts
install-fonts: ## Install symbolic links of src/fonts into $HOME/
install-fonts: $(fonts_target_paths:%=_install-link/%)

.PHONY: install-git
install-git: ## Install symbolic links of src/git into $HOME/
install-git: $(git_target_paths:%=_install-link/%)

.PHONY: install-most
install-most: ## Install symbolic links of src/most into $HOME/
install-most: $(most_target_paths:%=_install-link/%)

.PHONY: install-mycli
install-mycli: ## Install symbolic links of src/mycli into $HOME/
install-mycli: $(mycli_target_paths:%=_install-link/%)

.PHONY: install-mysql
install-mysql: ## Install symbolic links of src/mysql into $HOME/
install-mysql: $(mysql_target_paths:%=_install-link/%)

.PHONY: install-npm
install-npm: ## Install symbolic links of src/npm into $HOME/
install-npm: $(npm_target_paths:%=_install-link/%)

.PHONY: install-pgcli
install-pgcli: ## Install symbolic links of src/pgcli into $HOME/
install-pgcli: $(pgcli_target_paths:%=_install-link/%)

.PHONY: install-readline
install-readline: ## Install symbolic links of src/readline into $HOME/
install-readline: $(readline_target_paths:%=_install-link/%)

.PHONY: install-screen
install-screen: ## Install symbolic links of src/screen into $HOME/
install-screen: $(screen_target_paths:%=_install-link/%)

.PHONY: install-ssh
install-ssh: ## Install symbolic links of src/ssh into $HOME/
install-ssh: $(ssh_target_paths:%=_install-link/%)

.PHONY: install-tig
install-tig: ## Install symbolic links of src/tig into $HOME/
install-tig: $(tig_target_paths:%=_install-link/%)

.PHONY: install-tmux
install-tmux: ## Install symbolic links of src/tmux into $HOME/
install-tmux: $(tmux_target_paths:%=_install-link/%)

.PHONY: install-vim
install-vim: ## Install symbolic links of src/vim into $HOME/
install-vim: $(vim_target_paths:%=_install-link/%)

.PHONY: uninstall
uninstall: ## Delete all of symbolic links in $HOME/
uninstall: uninstall-dotfiles
uninstall: uninstall-bin
uninstall: uninstall-bash
uninstall: uninstall-fonts
uninstall: uninstall-git
uninstall: uninstall-most
uninstall: uninstall-mycli
uninstall: uninstall-mysql
uninstall: uninstall-npm
uninstall: uninstall-pgcli
uninstall: uninstall-readline
uninstall: uninstall-screen
uninstall: uninstall-ssh
uninstall: uninstall-tig
uninstall: uninstall-tmux
uninstall: uninstall-vim

.PHONY: uninstall-dotfiles
uninstall-dotfiles: ## Delete installed symbolic links of $PROJECT_DIR in $HOME/
uninstall-dotfiles: $(dotfiles_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-bin
uninstall-bin: ## Delete installed symbolic links of bin in $HOME/
uninstall-bin: $(bin_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-bash
uninstall-bash: ## Delete installed symbolic links of src/bash in $HOME/
uninstall-bash: $(bash_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-curl
uninstall-curl: ## Delete installed symbolic links of src/curl in $HOME/
uninstall-curl: $(curl_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-fonts
uninstall-fonts: ## Delete installed symbolic links of src/fonts in $HOME/
uninstall-fonts: $(fonts_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-git
uninstall-git: ## Delete installed symbolic links of src/git in $HOME/
uninstall-git: $(git_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-most
uninstall-most: ## Delete installed symbolic links of src/most in $HOME/
uninstall-most: $(most_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-mycli
uninstall-mycli: ## Delete installed symbolic links of src/mycli in $HOME/
uninstall-mycli: $(mycli_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-mysql
uninstall-mysql: ## Delete installed symbolic links of src/mysql in $HOME/
uninstall-mysql: $(mysql_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-npm
uninstall-npm: ## Delete installed symbolic links of src/npm in $HOME/
uninstall-npm: $(npm_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-pgcli
uninstall-pgcli: ## Delete installed symbolic links of src/pgcli in $HOME/
uninstall-pgcli: $(pgcli_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-readline
uninstall-readline: ## Delete installed symbolic links of src/readline in $HOME/
uninstall-readline: $(readline_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-screen
uninstall-screen: ## Delete installed symbolic links of src/screen in $HOME/
uninstall-screen: $(screen_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-ssh
uninstall-ssh: ## Delete installed symbolic links of src/ssh in $HOME/
uninstall-ssh: $(ssh_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-tig
uninstall-tig: ## Delete installed symbolic links of src/tig in $HOME/
uninstall-tig: $(tig_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-tmux
uninstall-tmux: ## Delete installed symbolic links of src/tmux in $HOME/
uninstall-tmux: $(tmux_target_paths:%=_uninstall-link/%)

.PHONY: uninstall-vim
uninstall-vim: ## Delete installed symbolic links of src/vim in $HOME/
uninstall-vim: $(vim_target_paths:%=_uninstall-link/%)

_backup/%: ## Backup target path if exists and not equals to source path,
_backup/%: ## in any of following cases:
_backup/%: ##   - The target path is exists and not a symbolic link.
_backup/%: ##   - The target path is a symbolic link and not equal to the source path.
_backup/%: TARGET_PATH ?= $(*)
_backup/%: TARGET_REALPATH = $(realpath $(TARGET_PATH))
_backup/%: SOURCE_PATH ?=
_backup/%: SOURCE_REALPATH = $(realpath $(SOURCE_PATH))
_backup/%: BACKUP_TARGET_PATH = $(TARGET_PATH).backup-at-$(BACKUP_TIMESTAMP)
_backup/%: BACKUP_LOG ?= $(PROJECT_DIR)/backup/$(HOSTNAME)/backup-list-$(BACKUP_TIMESTAMP)
_backup/%: _error-if-source-path-is-invalid/%
	@# Backup target path if exists and not equals to source path.
	@if ls "$(TARGET_PATH)" > /dev/null 2>&1 \
		&& ! test "$(TARGET_PATH)" -ef "$(SOURCE_PATH)"; \
	then \
		echo "$(TEXT_INFO) backup the existing target path: $(TARGET_PATH)"; \
		mkdir -v -p "$(shell dirname $(BACKUP_LOG))"; \
		printf "%s\t%s\n" "$(TARGET_PATH)" "$(BACKUP_TARGET_PATH)" >> "$(BACKUP_LOG)"; \
		if ! mv -v -n "$(TARGET_PATH)" "$(BACKUP_TARGET_PATH)"; then \
			echo "$(TEXT_ERROR) failed" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
	fi; \

_install-link/%: ## Install a symbolic link from source path to target path.
_install-link/%: TARGET_PATH ?= $(*)
_install-link/%: TARGET_PATH_DIR ?= $(shell dirname $(TARGET_PATH))
_install-link/%: SOURCE_PATH ?=
_install-link/%: _error-if-target-file-different/% _error-if-source-path-is-invalid/%
	@# Install a symbolic link for `%` if not installed
	@if ! test -e "$(TARGET_PATH)"; then \
		echo "$(TEXT_INFO) install a symbolic link:"; \
		if ! ( \
			mkdir -v -p "$(TARGET_PATH_DIR)" \
			&& ln -v -s "$(SOURCE_PATH)" "$(TARGET_PATH)" \
		); then \
			echo "$(TEXT_ERROR) failed" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
	fi; \

_uninstall-link/%: ## Delete the symbolic link from source path to target path.
_uninstall-link/%: TARGET_PATH ?= $(*)
_uninstall-link/%: SOURCE_PATH ?=
_uninstall-link/%: _error-if-source-path-is-invalid/%
	@# Delete the symbolic link from source path to target path.
	@if test -e "$(TARGET_PATH)" \
		&& test "$(TARGET_PATH)" -ef "$(SOURCE_PATH)"; \
	then \
		echo "$(TEXT_INFO) remove the symbolic link:"; \
		if ! rm -v "$(TARGET_PATH)"; then \
			echo "$(TEXT_ERROR) failed" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
	fi; \

.PRECIOUS: _error-if-target-path-not-supported/%
_error-if-target-path-not-supported/%: ## Throw an error if the target path not supported.
_error-if-target-path-not-supported/%: TARGET_PATH ?= $(*)
_error-if-target-path-not-supported/%: SOURCE_PATH ?=
_error-if-target-path-not-supported/%:
	@# Throw an error if the target path not supported.
	@if [ "$(SOURCE_PATH)" = "" ]; then \
		echo "$(TEXT_ERROR) target not supported: $(TARGET_PATH)" > /dev/stderr; \
		exit $(EXIT_CODE_GENERAL_ERROR); \
	fi; \

.PRECIOUS: _error-if-target-file-different/%
_error-if-target-file-different/%: ## Throw an error if the target file is exists and not equal to source file.
_error-if-target-file-different/%: TARGET_PATH ?= $(*)
_error-if-target-file-different/%: SOURCE_PATH ?=
_error-if-target-file-different/%: _error-if-target-path-not-supported/%
	@# Throw an error if the target file is exists and not equal to source file.
	@if test -e "$(TARGET_PATH)" \
		&& ! test "$(TARGET_PATH)" -ef "$(SOURCE_PATH)"; \
	then \
		echo "$(TEXT_ERROR) Please backup the existing '$(TARGET_PATH)' before install link" > /dev/stderr; \
		exit $(EXIT_CODE_GENERAL_ERROR); \
	fi; \

.PRECIOUS: _error-if-source-path-is-invalid/%
_error-if-source-path-is-invalid/%: ## Throw an error if the source path is invalid.
_error-if-source-path-is-invalid/%: TARGET_PATH ?= $(*)
_error-if-source-path-is-invalid/%: SOURCE_PATH ?=
_error-if-source-path-is-invalid/%: SOURCE_REALPATH = $(realpath $(SOURCE_PATH))
_error-if-source-path-is-invalid/%: _error-if-target-path-not-supported/%
	@# Throw an error if the source path is invalid
	@if [ "$(SOURCE_REALPATH)" = "" ]; then \
		echo "$(TEXT_ERROR) realpath not exists or is empty by the source path: $(SOURCE_PATH)" > /dev/stderr; \
		exit $(EXIT_CODE_GENERAL_ERROR); \
	fi; \

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
		--build-arg "HOST_OS_TYPE=$(shell uname -s)" \
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
_docker-container-run-%: DOCKER_CONTAINER_WORKDIR := "/home/edentsai/workspace-dotfiles"
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
