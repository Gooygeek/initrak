
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

.PHONY: pre-commit
pre-commit:
	pre-commit install

.PHONY: install
install:
	npm install

.PHONY: dev
dev:
	npm run dev

.PHONY: build
build:
	npm run build
