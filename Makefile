# Makefile for the documentation

# 
# Core configuration 
# These can be overridden by variables passed on the command-line or environment variables.
#
BASEDIR       ?= $(shell pwd)
BUILDDIR      ?= build
CACHE_DIR 	  ?= cache
FONTSDIR      ?= fonts
PLAYBOOK 	  ?= site.yml
STYLE         ?= owncloud
STYLESDIR     ?= resources/themes
UI_BUNDLE	  ?= https://minio.owncloud.com/documentation/ui-bundle.zip

.PHONY: help clean check-xrefs install


help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  check-xrefs    to validate the Xrefs in the source content."
	@echo "  install        to install the Antora command-line tools."

#
# Use a limited Antora build to check the Xrefs through the Playbook's source files
# 
check-xrefs: 
	@echo "Checking for invalid Xrefs in all source files"
	@echo
	antora generate \
		--generator=./generator/xref-validator.js \
		--pull \
		--stacktrace \
		--ui-bundle-url $(UI_BUNDLE) \
		site.yml

#
# Installs the Antora command-line tools locally, so that users only have to do as little as possible
# to get up and running.
#
install: 
	@echo "Installing Antora's command-line tools (locally)"
	npm install

check_all_files_prose: 
	@echo "Checking quality of the prose in all files"
	write-good --parse modules/{administration,developer,user}_manual/**/*.adoc

FILES=$(shell git diff --staged --name-only $(BRANCH) | grep -E \.adoc$)
check_staged_files_prose: 
	@echo "Checking quality of the prose in the changed files"
	$(foreach file,$(FILES),write-good --parse $(file);)
