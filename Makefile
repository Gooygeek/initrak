
# Force the use of bash
SHELL := bash

# Use a single shell per recipe instead of per line
.ONESHELL:

# -e Immediately exit if any command has a non-zero exit status
# -u Referencing any undefined variable is an error
# -o pipefail If any command in a pipeline fails, that return code will be used as the return code of the whole pipeline
.SHELLFLAGS := -eu -o pipefail -c

# If a recipe fails, delete the file
.DELETE_ON_ERROR:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.DEFAULT_GOAL := default

DOCKER_RUN = docker run --rm -it -v "$$(pwd)":/app -w /app -p 5000:5000 node:20

.PHONY: pre-commit
pre-commit:
	pre-commit install

.PHONY: install
install:
	$(DOCKER_RUN) make _install

.PHONY: _install
_install:
	npm install

.PHONY: dev
dev:
	$(DOCKER_RUN) make _dev

.PHONY: _dev
_dev: _install
	npm run dev -- --host --port 5000

.PHONY: build
build:
	npm run build



.PHONY: default
default: install dev
