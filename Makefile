# See sample env for variables passed to deploy-project

DOCKER_TAG_VERSION ?= latest
DOCKER_APP_DEST ?= /app
NAMESPACE ?= production
PROJECT_NAME ?= torrenting
PYTHON_VERSION ?= 3.9

pull-python-docker:
	if ! [ -d git_projects/python-docker ]; then\
		mkdir -p git_projects;\
		git clone https://github.com/jusjayson/Python-Docker.git git_projects/python-docker;\
	fi
	cd git_projects/python-docker && git pull;

pull-arrnounced:
	if ! [ -r git_projects/arrnounced ]; then\
		mkdir -p git_projects;\
		git clone https://github.com/funkybrows/sonarr-announced.git git_projects/arrnounced;\
	fi
	cd git_projects/arrnounced && git pull;

pull-autodl-trackers:
	if ! [ -r config/arrnounced/autodl-trackers ]; then\
		git clone https://github.com/autodl-community/autodl-trackers.git config/arrnounced/autodl-trackers;\
	fi
	cd config/arrnounced/autodl-trackers && git pull;

pull-deluge-control:
	if ! [ -r git_projects/deluge_control ]; then\
		mkdir -p git_projects;\
		git clone https://github.com/funkybrows/Deluge-Control.git git_projects/deluge_control;\
	fi
	cd git_projects/deluge_control && git pull;

build-base-image: export DOCKER_COMMON_ENV_PATH_FROM_PYTHON_DOCKER=../../config/docker/env/common.env
build-base-image: export DOCKER_SPECIFIC_ENV_PATH_FROM_PYTHON_DOCKER=../../config/docker/env/python.env
build-base-image: export PYTHON_VERSION=$(PYTHON_VERSION)
build-base-image:
	make -C git_projects/python-docker build-base-image

build-arrnounced: export DOCKER_COMMON_ENV_PATH=../../config/docker/env/common.env
build-arrnounced: export DOCKER_SPECIFIC_ENV_PATH=../../config/docker/env/arrnounced_build.env
build-arrnounced:
	make -C git_projects/arrnounced build-project


build-deluge-control: export DOCKER_COMMON_ENV_PATH_FROM_PYTHON_DOCKER=../../config/docker/env/common.env
build-deluge-control: export DOCKER_SPECIFIC_ENV_PATH_FROM_PYTHON_DOCKER=../../config/docker/env/deluge_control_build.env
build-deluge-control:
	make -C git_projects/deluge_control build-project

include config/docker/env/common.env
include config/docker/env/launch.env
export

deploy-project:

	DOCKER_APP_DEST=$(DOCKER_APP_DEST) \
	DOCKER_TAG_VERSION=$(DOCKER_TAG_VERSION) \
	NAMESPACE=$(NAMESPACE) \
	docker compose \
		-f config/docker/compose/docker-compose.yaml \
		up

teardown-project:
	docker compose \
		-f config/docker/compose/docker-compose.yaml \
		down

DOCKER_LOCAL_CMD ?= /bin/bash

launch-local-project:
	DOCKER_APP_DEST=$(DOCKER_APP_DEST) \
	DOCKER_TAG_VERSION=$(DOCKER_TAG_VERSION) \
	NAMESPACE=$(NAMESPACE) \
	docker compose \
		-f config/docker/compose/docker-compose.yaml \
		run -it deluge-control $(DOCKER_LOCAL_CMD)
