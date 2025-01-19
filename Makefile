SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail $(if $(TRACE),-x,) -c

.DEFAULT_GOAL := all
.ONESHELL:
.DELETE_ON_ERROR:

## env ##########################################

NAME := $(shell pwd | xargs basename)
TARGET := itzg/minecraft-server:java21-alpine
GEYSERVERSION := 2.6.0

## interface ####################################
all: distclean dist check build
init: assets assets/Geyser-Spigot.jar
install:
clean:  distclean

## workflow #####################################
assets:
	: ## $@
	mkdir -p $@
assets/Geyser-Spigot.jar:
	: ## $@
	curl https://download.geysermc.org/v2/projects/geyser/versions/2.6.0/builds/latest/downloads/spigot \
		-sLD/dev/stderr \
		-o $@

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
	mkdir $</plugins
	rsync -av assets/Geyser-Spigot.jar $</plugins

install:
	: ## $@
	: ## Deploy orchestration target
	docker volume create "$(NAME)-data"    ||:
	docker volume create "$(NAME)-plugins" ||:
	docker rm -f $(NAME) ||:
	docker run \
		-d \
		--publish 25565:25565 \
		--name "$(NAME)" \
		--volume "$(NAME)-data:/data" \
		--volume "$(NAME)-plugins:/plugins" \
		--env "EULA=TRUE" \
		-- $(TARGET)
