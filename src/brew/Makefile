MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/sh
.SHELLFLAGS := -o nounset -o errexit -c
.SUFFIXES :=

BREW_MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
BREW_DIR := $(shell dirname $(BREW_MAKEFILE))
ROOT_MAKEFILE := $(abspath $(BREW_DIR)/../../Makefile)

include $(ROOT_MAKEFILE)

OS_TYPE := $(shell uname -s)
OS_TYPE_MAC := Darwin

.PHONY: brew-bundle-dump
brew-bundle-dump: BREWFILE ?= $(BREW_DIR)/Brewfile
brew-bundle-dump: brew-tap-bundle
	@echo "$(TEXT_INFO) brew bundle dump to :"; \
	if ! brew bundle dump --describe --file="/dev/stdout" \
		| sed -e $$'s/^# /\\\n# /g' \
		| tee "$(BREWFILE)"; \
	then \
		echo "$(TEXT_ERROR) failed." > /dev/stderr; \
		exit $(EXIT_CODE_GENERAL_ERROR); \
	fi; \

.PHONY: brew-bundle-check
brew-bundle-check: BREWFILE ?= $(BREW_DIR)/Brewfile
brew-bundle-check: brew-tap-bundle
	@echo "$(TEXT_INFO) brew bundle check:"; \
	if ! brew bundle check --verbose \
		--file="$(BREWFILE)" \
		--no-upgrade; \
	then \
		echo "$(TEXT_ERROR) failed." > /dev/stderr; \
		exit $(EXIT_CODE_GENERAL_ERROR); \
	fi; \

.PHONY: brew-bundle-install
brewbundle-install: BREWFILE ?= $(BREW_DIR)/Brewfile
brewbundle-install: brew-tap-bundle
	@echo "$(TEXT_INFO) brew bundle install:"; \
	if ! brew bundle install --verbose \
		--file="$(BREWFILE)" \
		--no-upgrade; \
	then \
		echo "$(TEXT_ERROR) failed." > /dev/stderr; \
		exit $(EXIT_CODE_GENERAL_ERROR); \
	fi; \

.PHONY: brew-tap-bundle
brew-tap-bundle: BREW_TAP_BUNDLE = homebrew/bundle
brew-tap-bundle: _brew-error-if-not-on-macos
	@if ! brew tap | grep -o "homebrew/bundle" > /dev/null; then \
		echo "$(TEXT_INFO) brew tap: homebrew/bundle"; \
		if ! brew tap "homebrew/bundle"; then \
			echo "$(TEXT_ERROR) failed." > /dev/stderr; \
			exit $(EXIT_CODE_GENERAL_ERROR); \
		fi; \
	fi; \

.PHONY: _brew-error-if-not-on-macos
_brew-error-if-not-on-macos: OS_TYPE := $(shell uname -s)
_brew-error-if-not-on-macos: OS_TYPE_MACOS := Darwin
	@if [ "$(OS_TYPE)" != "${OS_TYPE_MAC}" ]; then \
		echo "$(TEXT_ERROR) not running on MacOS." > /dev/stderr; \
		exit $(EXIT_CODE_GENERAL_ERROR); \
	fi; \
