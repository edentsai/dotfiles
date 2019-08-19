MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/sh
.SHELLFLAGS := -o nounset -o errexit -c
.SUFFIXES :=

OPT_MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
OPT_DIR := $(shell dirname $(OPT_MAKEFILE))
ROOT_MAKEFILE := $(abspath $(OPT_DIR)/../Makefile)

include $(ROOT_MAKEFILE)

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
.PHONY: install-tmux-package
install-tmux-package: BYACC_INSTALL_PREFIX ?= $(HOME)/opt/byacc
install-tmux-package: NCURSES_INSTALL_PREFIX ?= $(HOME)/opt/ncurses6
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
		echo "     export PATH=\"$(NCURSES_INSTALL_PREFIX)/bin:\$$PATH\""; \
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
