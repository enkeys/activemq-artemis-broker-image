#!make

SHELL := /bin/sh -x

all: build configure

build:
	@set -a; . ./.env; \
	cekit --verbose build docker --tag $$IMAGE_NAME:latest

configure:
	docker network create --subnet=172.18.0.0/16 test-net | true

dgoss-validate:
	@set -a; . ./.env; \
	dgoss run --net test-net --ip $$IP_ADDR --env-file .env $$IMAGE_NAME

dgoss-validate-ci:
	@set -a; . ./.env; \
	dgoss run --net test-net --ip $$IP_ADDR --env-file .env $$IMAGE_NAME; \
	GOSS_OPTS="--format junit --format-options verbose" dgoss run --net test-net --ip $$IP_ADDR --env-file .env $$IMAGE_NAME > validate_results.junit.xml
dgoss-validate-target:
	@set -a; . ./.env; \
	dgoss run --net test-net --ip $$IP_ADDR --env-file .env $$TARGET_IMAGE

dgoss-validate-target-ci:
	@set -a; . ./.env; \
	dgoss run --net test-net --ip $$IP_ADDR --env-file .env $$TARGET_IMAGE; \
	GOSS_OPTS="--format junit --format-options verbose" dgoss run --net test-net --ip $$IP_ADDR --env-file .env $$TARGET_IMAGE > validate_results.junit.xml