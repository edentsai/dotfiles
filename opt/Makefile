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
install-tig-package: OPT_INSTALL_PREFIX ?= $(HOME)/opt
install-tig-package: TIG_REPOSITORY_URL ?= https://github.com/jonas/tig.git
install-tig-package: TIG_VERSION ?= master
install-tig-package: install-ncurses6-package
	@if ! test -f "$(OPT_INSTALL_PREFIX)/bin/tig"; then \
		echo "$(TEXT_INFO) download and install tig@$(TIG_VERSION) from: $(TIG_REPOSITORY_URL)"; \
		export PATH="$(OPT_INSTALL_PREFIX)/bin:$$PATH"; \
		if ! ( \
			cd "$$(mktemp -d)" \
			&& git clone "$(TIG_REPOSITORY_URL)" --branch "$(TIG_VERSION)" \
			&& cd "tig" \
			&& git checkout "$(TIG_VERSION)" \
			&& mkdir -v -p "$(OPT_INSTALL_PREFIX)" \
			&& make configure \
			&& ./configure --prefix="$(OPT_INSTALL_PREFIX)" \
			&& make prefix="$(OPT_INSTALL_PREFIX)" \
			&& make install prefix="$(OPT_INSTALL_PREFIX)" \
			&& test -x "$(OPT_INSTALL_PREFIX)/bin/tig" \
			&& cd .. \
			&& rm -rf "tig" \
		); then \
			echo "$(TEXT_ERROR) failed, temporary directory at: $${PWD}" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		echo "$(TEXT_OK) tig installed, you need to add the bin directory to your PATH from ~/.bashrc, like:"; \
		echo "     export PATH=\"$(OPT_INSTALL_PREFIX)/bin:\$$PATH\""; \
	fi; \

.PHONY: install-ncurses6-package
install-ncurses6-package: OPT_INSTALL_PREFIX := $(HOME)/opt
install-ncurses6-package: NCURSES_TAR_URL := https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.1.tar.gz
install-ncurses6-package: NCURSES_TAR_FILENAME := $(shell basename $(NCURSES_TAR_URL))
install-ncurses6-package: NCURSES_DIR := $(NCURSES_TAR_FILENAME:%.tar.gz=%)
install-ncurses6-package:
	@if ! test -f "$(OPT_INSTALL_PREFIX)/bin/ncurses6-config"; then \
		echo "$(TEXT_INFO) download and install ncurses6 from: $(NCURSES_TAR_URL)"; \
		export PATH="$(OPT_INSTALL_PREFIX)/bin:$$PATH"; \
		if ! ( \
			cd "$$(mktemp -d)" \
			&& wget "$(NCURSES_TAR_URL)" --output-document "$(NCURSES_TAR_FILENAME)" --verbose --server-response \
			&& tar -vxzf "$(NCURSES_TAR_FILENAME)" \
			&& cd "$(NCURSES_DIR)" \
			&& mkdir -p "$(OPT_INSTALL_PREFIX)" \
			&& ./configure --prefix="$(OPT_INSTALL_PREFIX)" \
			&& make \
			&& make install \
			&& test -x "$(OPT_INSTALL_PREFIX)/bin/ncurses6-config" \
			&& cd .. \
			&& rm -rf "$(NCURSES_DIR)" "$(NCURSES_TAR_FILENAME)" \
		); then \
			echo "$(TEXT_ERROR) failed, temporary directory at: $${PWD}" > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
		echo "$(TEXT_OK) ncurses6 installed, you need to add the bin directory to your PATH from ~/.bashrc, like:"; \
		echo "     export PATH=\"$(OPT_INSTALL_PREFIX)/bin:\$$PATH\""; \
	fi; \
