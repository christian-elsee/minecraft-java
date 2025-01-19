SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail $(if $(TRACE),-x,) -c

.DEFAULT_GOAL := all
.ONESHELL:
.DELETE_ON_ERROR:

## env ##########################################

NAME := $(shell pwd | xargs basename)

## interface ####################################
all: distclean dist check build
init:
install:
clean:  distclean

## workflow #####################################
distclean:
	: ## $@
	: ## Remove orchestration target
	rm -rf dist
dist:
	: ## $@
	: ## Create orchestration target
	mkdir -p $@

check:
	: ## $@
	: ## Validate orchestration target artifacts

build: dist
	: ## $@
	: ## Build an orchestration target

install:
	: ## $@
	: ## Deploy orchestration target
	docker compose up -d

clean:
	: ## $@
	: ## Remove all orchestration artifacts
	docker compose down --volumes --remove-orphans
