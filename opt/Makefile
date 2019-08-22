MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/sh
.SHELLFLAGS := -o nounset -o errexit -c
.SUFFIXES :=

OPT_MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
OPT_DIR := $(shell dirname $(OPT_MAKEFILE))
ROOT_MAKEFILE := $(abspath $(OPT_DIR)/../Makefile)

include $(ROOT_MAKEFILE)

.PHONY: install-bash-completion-package
install-bash-completion-package: ## Install Bash completion package
install-bash-completion-package: INSTALL_PREFIX ?= $(HOME)/opt/bash-completion
install-bash-completion-package: REPOSITORY_URL ?= https://github.com/scop/bash-completion.git
install-bash-completion-package: VERSION ?= master
install-bash-completion-package:
	@if ! test -f "$(INSTALL_PREFIX)/share/bash-completion/bash_completion"; then \
		echo "$(TEXT_INFO) download and install bash-completion@$(VERSION) from: $(REPOSITORY_URL)"; \
		if ! ( \
			cd "$$(mktemp -d)" \
			&& git clone "$(REPOSITORY_URL)" --branch "$(VERSION)" \
			&& cd "bash-completion" \
			&& autoreconf -i \
			&& ./configure --prefix="$(INSTALL_PREFIX)" \
			&& make \
			&& make install \
			&& test -f "$(INSTALL_PREFIX)/share/bash-completion/bash_completion" \
		); then \
			echo "$(TEXT_ERROR) failed, temporary directory at: $${PWD}" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		echo "$(TEXT_OK) bash-completion installed, you need to add the following settings to your ~/.bashrc, like:"; \
		echo "     source \"$(INSTALL_PREFIX)/share/bash-completion/bash_completion\""; \
		echo "     export XDG_DATA_DIRS=\"$(INSTALL_PREFIX)/share\""; \
	fi; \

.PHONY: install-php-composer-package
install-php-composer-package: ## Install PHP Composer package
install-php-composer-package: COMPOSER_INSTALL_PREFIX ?= $(HOME)/opt/composer
install-php-composer-package: COMPOSER_INSTALLER_URL ?= https://getcomposer.org/installer
install-php-composer-package: COMPOSER_INSTALLER ?= composer-setup.php
install-php-composer-package:
	@if ! test -f "$(COMPOSER_INSTALL_PREFIX)/bin/composer"; then \
		echo "$(TEXT_INFO) download and install PHP composer from: $(COMPOSER_INSTALLER_URL)"; \
		if ! ( \
			cd "$$(mktemp -d)" \
			&& wget "$(COMPOSER_INSTALLER_URL)" --output-document "$(COMPOSER_INSTALLER)" --verbose --server-response \
			&& echo \
				"a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1" \
				" $(COMPOSER_INSTALLER)" \
				> "sha384sum-$(COMPOSER_INSTALLER).txt" \
			&& shasum --algorithm "384" --check "sha384sum-$(COMPOSER_INSTALLER).txt" \
			&& php "$(COMPOSER_INSTALLER)" \
			&& test -x "composer.phar" \
			&& mkdir -v -p "$(COMPOSER_INSTALL_PREFIX)/bin" \
			&& mv "composer.phar" "$(COMPOSER_INSTALL_PREFIX)/bin/composer" \
			&& test -x "$(COMPOSER_INSTALL_PREFIX)/bin/composer" \
			&& rm -v "$(COMPOSER_INSTALLER)" "sha384sum-$(COMPOSER_INSTALLER).txt" \
		); then \
			echo "$(TEXT_ERROR) failed, temporary directory at: $${PWD}" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		echo "$(TEXT_OK) php-composer installed, you need to add it to your PATH from ~/.bashrc, like:"; \
		echo "     export PATH=\"$(COMPOSER_INSTALL_PREFIX)/bin:\$$PATH\""; \
	fi; \

# [MacOS] Install tig command from source
# https://gist.github.com/fscm/8b0344179133d1d9d0ad519363e90405
.PHONY: install-tig-package
install-tig-package: NCURSES_INSTALL_PREFIX ?= $(HOME)/opt/ncurses6
install-tig-package: TIG_INSTALL_PREFIX ?= $(HOME)/opt/tig
install-tig-package: TIG_REPOSITORY_URL ?= https://github.com/jonas/tig.git
install-tig-package: TIG_VERSION ?= master
install-tig-package: install-ncurses6-package
	@if ! test -f "$(TIG_INSTALL_PREFIX)/bin/tig"; then \
		echo "$(TEXT_INFO) download and install tig@$(TIG_VERSION) from: $(TIG_REPOSITORY_URL)"; \
		export PATH="$(NCURSES_INSTALL_PREFIX)/bin:$$PATH"; \
		export PATH="$(TIG_INSTALL_PREFIX)/bin:$$PATH"; \
		if ! ( \
			cd "$$(mktemp -d)" \
			&& git clone "$(TIG_REPOSITORY_URL)" --branch "$(TIG_VERSION)" \
			&& cd "tig" \
			&& git checkout "$(TIG_VERSION)" \
			&& mkdir -v -p "$(TIG_INSTALL_PREFIX)" \
			&& make configure \
			&& ./configure --prefix="$(TIG_INSTALL_PREFIX)" \
			&& make \
			&& make install \
			&& test -x "$(TIG_INSTALL_PREFIX)/bin/tig" \
			&& cd .. \
			&& rm -rf "tig" \
		); then \
			echo "$(TEXT_ERROR) failed, temporary directory at: $${PWD}" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		echo "$(TEXT_OK) tig installed, you need to add the bin directory to your PATH from ~/.bashrc, like:"; \
		echo "     export PATH=\"$(TIG_INSTALL_PREFIX)/bin:\$$PATH\""; \
	fi; \

# https://github.com/tmux/tmux
# https://gist.github.com/ryin/3106801
.PHONY: install-tmux-package
install-tmux-package: BYACC_INSTALL_PREFIX ?= $(HOME)/opt/byacc
install-tmux-package: NCURSES_INSTALL_PREFIX ?= $(HOME)/opt/ncurses6
install-tmux-package: LIBEVENT_INSTALL_PREFIX ?= $(HOME)/opt/libevent
install-tmux-package: TMUX_INSTALL_PREFIX ?= $(HOME)/opt/tmux
install-tmux-package: TMUX_REPOSITORY_URL ?= https://github.com/tmux/tmux.git
install-tmux-package: TMUX_VERSION ?= master
install-tmux-package:
	@if ! test -f "$(TMUX_INSTALL_PREFIX)/bin/tmux"; then \
		echo "$(TEXT_INFO) download and install tmux@$(TMUX_VERSION) from: $(TMUX_REPOSITORY_URL)"; \
		export PATH="$(BYACC_INSTALL_PREFIX)/bin:$$PATH"; \
		export PATH="$(NCURSES_INSTALL_PREFIX)/bin:$$PATH"; \
		export PATH="$(TMUX_INSTALL_PREFIX)/bin:$$PATH"; \
		if ! command -v yacc > /dev/null; then \
			echo "$(TEXT_ERROR) require byacc package for build tmux from source," > /dev/stderr; \
			echo "        please run install byacc first: make install-byacc-package" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		if ! ( \
			cd "$$(mktemp -d)" \
			&& git clone "$(TMUX_REPOSITORY_URL)" --branch "$(TMUX_VERSION)" \
			&& cd "tmux" \
			&& mkdir -v -p "$(TMUX_INSTALL_PREFIX)" \
			&& sh autogen.sh \
			&& ./configure --prefix="$(TMUX_INSTALL_PREFIX)" \
				CFLAGS=" \
					-I$(LIBEVENT_INSTALL_PREFIX)/lib \
					-I$(LIBEVENT_INSTALL_PREFIX)/include \
					-I$(NCURSES_INSTALL_PREFIX)/include \
				" \
				LDFLAGS=" \
					-L$(LIBEVENT_INSTALL_PREFIX)/lib \
					-L$(LIBEVENT_INSTALL_PREFIX)/include \
					-L$(NCURSES_INSTALL_PREFIX)/include \
				" \
			&& make \
			&& make install \
			&& test -x "$(TMUX_INSTALL_PREFIX)/bin/tmux" \
			&& cd .. \
			&& rm -rf "tmux" \
		); then \
			echo "$(TEXT_ERROR) failed, temporary directory at: $${PWD}" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		echo "$(TEXT_OK) tmux installed, you need to add the bin directory to your PATH from ~/.bashrc, like:"; \
		echo "     export PATH=\"$(TMUX_INSTALL_PREFIX)/bin:\$$PATH\""; \
		echo "     export LD_LIBRARY_PATH=\"$(LIBEVENT_INSTALL_PREFIX)/lib:\$$LD_LIBRARY_PATH\""; \
	fi; \

.PHONY: install-ncurses6-package
install-ncurses6-package: NCURSES_INSTALL_PREFIX := $(HOME)/opt/ncurses6
install-ncurses6-package: NCURSES_TAR_URL := https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.1.tar.gz
install-ncurses6-package: NCURSES_TAR_FILENAME := $(shell basename $(NCURSES_TAR_URL))
install-ncurses6-package: NCURSES_DIR := $(NCURSES_TAR_FILENAME:%.tar.gz=%)
install-ncurses6-package:
	@if ! test -f "$(NCURSES_INSTALL_PREFIX)/bin/ncurses6-config"; then \
		echo "$(TEXT_INFO) download and install ncurses6 from: $(NCURSES_TAR_URL)"; \
		export PATH="$(NCURSES_INSTALL_PREFIX)/bin:$$PATH"; \
		if ! ( \
			cd "$$(mktemp -d)" \
			&& wget "$(NCURSES_TAR_URL)" --output-document "$(NCURSES_TAR_FILENAME)" --verbose --server-response \
			&& tar -vxzf "$(NCURSES_TAR_FILENAME)" \
			&& cd "$(NCURSES_DIR)" \
			&& mkdir -p "$(NCURSES_INSTALL_PREFIX)" \
			&& ./configure --prefix="$(NCURSES_INSTALL_PREFIX)" \
			&& make \
			&& make install \
			&& test -x "$(NCURSES_INSTALL_PREFIX)/bin/ncurses6-config" \
			&& cd .. \
			&& rm -rf "$(NCURSES_DIR)" "$(NCURSES_TAR_FILENAME)" \
		); then \
			echo "$(TEXT_ERROR) failed, temporary directory at: $${PWD}" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		echo "$(TEXT_OK) ncurses6 installed, you need to add the bin directory to your PATH from ~/.bashrc, like:"; \
		echo "     export PATH=\"$(NCURSES_INSTALL_PREFIX)/bin:\$$PATH\"";\
	fi; \

.PHONY: install-libevent-package
install-libevent-package: LIBEVENT_INSTALL_PREFIX := $(HOME)/opt/libevent
install-libevent-package: LIBEVENT_TAR_URL := https://github.com/libevent/libevent/releases/download/release-2.1.10-stable/libevent-2.1.10-stable.tar.gz
install-libevent-package: LIBEVENT_TAR_FILENAME := $(shell basename $(LIBEVENT_TAR_URL))
install-libevent-package: LIBEVENT_DIR := $(LIBEVENT_TAR_FILENAME:%.tar.gz=%)
install-libevent-package:
	@if ! test -f "$(LIBEVENT_INSTALL_PREFIX)/bin/event_rpcgen.py"; then \
		echo "$(TEXT_INFO) download and install libevent from: $(LIBEVENT_TAR_URL)"; \
		if ! ( \
			cd "$$(mktemp -d)" \
			&& wget "$(LIBEVENT_TAR_URL)" --output-document "$(LIBEVENT_TAR_FILENAME)" --verbose --server-response \
			&& tar -vxzf "$(LIBEVENT_TAR_FILENAME)" \
			&& cd "$(LIBEVENT_DIR)" \
			&& mkdir -p "$(LIBEVENT_INSTALL_PREFIX)" \
			&& ./configure --prefix="$(LIBEVENT_INSTALL_PREFIX)" \
			&& make \
			&& make install \
			&& test -x "$(LIBEVENT_INSTALL_PREFIX)/bin/event_rpcgen.py" \
			&& cd .. \
			&& rm -rf "$(LIBEVENT_DIR)" "$(LIBEVENT_TAR_FILENAME)" \
		); then \
			echo "$(TEXT_ERROR) failed, temporary directory at: $${PWD}" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		echo "$(TEXT_OK) libevent installed, you need to add the bin directory to your PATH from ~/.bashrc, like:"; \
		echo "     export LD_LIBRARY_PATH=\"$(LIBEVENT_INSTALL_PREFIX)/lib:\$$LD_LIBRARY_PATH\""; \
	fi; \

# https://invisible-mirror.net/archives/byacc/
.PHONY: install-byacc-package
install-byacc-package: BYACC_INSTALL_PREFIX ?= $(HOME)/opt/byacc
install-byacc-package: BYACC_TAR_URL ?= https://invisible-mirror.net/archives/byacc/byacc-20190617.tgz
install-byacc-package: BYACC_TAR_FILENAME := $(shell basename $(BYACC_TAR_URL))
install-byacc-package: BYACC_DIR := $(BYACC_TAR_FILENAME:%.tgz=%)
install-byacc-package:
	@if ! test -f "$(BYACC_INSTALL_PREFIX)/bin/yacc"; then \
		echo "$(TEXT_INFO) download and install byacc from: $(BYACC_TAR_URL)"; \
		export PATH="$(BYACC_INSTALL_PREFIX)/bin:$$PATH"; \
		if ! ( \
			cd "$$(mktemp -d)" \
			&& wget "$(BYACC_TAR_URL)" --output-document "$(BYACC_TAR_FILENAME)" --verbose --server-response \
			&& tar -vxzf "$(BYACC_TAR_FILENAME)" \
			&& cd "$(BYACC_DIR)" \
			&& mkdir -p "$(BYACC_INSTALL_PREFIX)" \
			&& ./configure --prefix="$(BYACC_INSTALL_PREFIX)" \
			&& make \
			&& make install \
			&& test -x "$(BYACC_INSTALL_PREFIX)/bin/yacc" \
			&& cd .. \
			&& rm -rf "byacc" \
		); then \
			echo "$(TEXT_ERROR) failed, temporary directory at: $${PWD}" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		echo "$(TEXT_OK) byacc installed, you need to add the bin directory to your PATH from ~/.bashrc, like:"; \
		echo "     export PATH=\"$(BYACC_INSTALL_PREFIX)/bin:\$$PATH\""; \
	fi; \
