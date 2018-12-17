# Makefile for the documentation

# 
# Core configuration 
# These can be overridden by variables passed on the command-line or environment variables.
#
BUILDDIR      = build
FONTSDIR      = fonts
STYLESDIR     = resources/themes
STYLE         = owncloud
BASEDIR       = $(shell pwd)
APPVERSION    = 10.0.19
BRANCH        = $(shell git rev-parse --verify HEAD)
UI_BUNDLE	  = https://minio.owncloud.com/documentation/ui-bundle.zip

.PHONY: help clean pdf

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  check-xrefs    to validate the Xrefs in the source content."
	@echo "  clean          to clean the build directory of any leftover artifacts from the previous build."
	@echo "  install        to install the Antora command-line tools."
	@echo "  pdf            to generate the PDF version of the manual."

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
# Remove any build artifacts from previous builds.
#
clean:		
	@echo "Cleaning up any artifacts from the previous build."
	@-rm -rf $(BUILDDIR)/*
	@echo 

html:
	@echo "Building HTML version of the documentation"
	antora generate --stacktrace --pull site.yml
	@echo

#
# Installs the Antora command-line tools locally, so that users only have to do as little as possible
# to get up and running.
#
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
	@echo "The PDF copy of the manuals have been generated in the build directory: $(BUILDDIR)/."

check_all_files_prose: 
	@echo "Checking quality of the prose in all files"
	write-good --parse modules/{administration,developer,user}_manual/**/*.adoc

FILES=$(shell git diff --staged --name-only $(BRANCH) | grep -E \.adoc$)
check_staged_files_prose: 
	@echo "Checking quality of the prose in the changed files"
	$(foreach file,$(FILES),write-good --parse $(file);)
