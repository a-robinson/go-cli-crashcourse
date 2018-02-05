# Project name.
PROJECT_NAME = crashcourse

# Makefile parameters.
TAG ?= $(shell git describe)

# General.
SHELL = /bin/bash
TOPDIR = $(shell git rev-parse --show-toplevel)

# Project specifics.
BUILD_DIR = dist
PLATFORMS = linux darwin
OS = $(word 1, $@)
GOOS = $(shell uname -s | tr A-Z a-z)
GOARCH = amd64

default: setup

help: # Display help
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST) | sort

build: ## Build the project for the current platform
	mkdir -p $(BUILD_DIR)
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o $(BUILD_DIR)/$(PROJECT_NAME)-$(TAG)-$(GOOS)-$(GOARCH)

ci: ci-linters ci-tests ## Run all the CI targets

ci-linters: ## Run the static analyzers
	@echo "Not implemented yet." && exit 1

ci-tests: ## Run the unit tests
	go test

clean: clean-code ## Clean everything (!DESTRUCTIVE!)

clean-code: ## Remove unwanted files in this project (!DESTRUCTIVE!)
	@cd $(TOPDIR) && git clean -ffdx && git reset --hard

dist: $(PLATFORMS) ## Package the project for all available platforms

prepare: ## Prepare the environment
	glide install

setup: prepare ## Setup the full environment (default)

.PHONY: help build ci ci-linters ci-tests clean clean-code dist prepare setup

$(PLATFORMS): # Build the project for all available platforms
	mkdir -p $(BUILD_DIR)
	GOOS=$(OS) GOARCH=$(GOARCH) go build -o $(BUILD_DIR)/$(PROJECT_NAME)-$(TAG)-$(OS)-$(GOARCH)
.PHONY: $(PLATFORMS)