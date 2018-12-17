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

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  check-staged-files-prose       to check the prose in staged files."
	@echo "  check-unstaged-files-prose     to check the prose in unstaged files."
	@echo "  check-xrefs    				to validate the Xrefs in the source content."
	@echo "  install        				to install the Antora command-line tools."


.PHONY: check-unstaged-files-prose
STAGED_FILES=$(shell git diff -w --ignore-blank-lines --name-only | grep -E \.adoc$)
check-unstaged-files-prose: 
	@echo "Checking quality of the prose in unstaged files"
	$(foreach file,$(STAGED_FILES),write-good --parse $(file);)

.PHONY: check-staged-files-prose
UNSTAGED_FILES=$(shell git diff -w --staged --ignore-blank-lines --name-only | grep -E \.adoc$)
check-staged-files-prose: 
	@echo "Checking quality of the prose in staged files"
	$(foreach file,$(UNSTAGED_FILES),write-good --parse $(file);)

#
# Use a limited Antora build to check the Xrefs through the Playbook's source files
# 
.PHONY: check-xrefs
check-xrefs: 
	@echo "Checking for invalid Xrefs in all source files"
	@echo
	antora generate \
		--cache-dir $(CACHE_DIR) \
		--generator=./generator/xref-validator.js \
		--pull \
		--stacktrace \
		--ui-bundle-url $(UI_BUNDLE) \
		$(PLAYBOOK)

#
# Installs the Antora command-line tools locally, so that users only have to do as little as possible
# to get up and running.
#
.PHONY: install
install: 
	@echo "Installing Antora's command-line tools (locally)"
	npm install

#
# Generate PDF versions of the administration, developer, and user manuals.
#
.PHONY: pdf
pdf:
	@echo "Building PDF manual."
	asciidoctor-pdf \
		-a pdf-stylesdir=$(STYLESDIR)/ \
		-a pdf-style=$(STYLE) \
		-a pdf-fontsdir=$(FONTSDIR) \
		-a examplesdir=modules/ROOT/examples \
		-a imagesdir=modules/ROOT/assets/images \
		-a appversion=$(VERSION) \
		--base-dir $(CURDIR) \
		--out-file Building_Branded_ownCloud_Clients.pdf \
		--destination-dir $(BUILDDIR) \
		pdf.adoc
	
	@echo
	@echo "Finished building the PDF manual."
	@echo "The PDF copy of the manual has been generated in the build directory: $(BUILDDIR)/."

check_all_files_prose: 
	@echo "Checking quality of the prose in all files"
	write-good --parse modules/{administration,developer,user}_manual/**/*.adoc

FILES=$(shell git diff --staged --name-only $(BRANCH) | grep -E \.adoc$)
check_staged_files_prose: 
	@echo "Checking quality of the prose in the changed files"
	$(foreach file,$(FILES),write-good --parse $(file);)