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

build-base-image: export DOCKER_COMMON_ENV_PATH_FROM_PYTHON_DOCKER=../../config/docker/env/common.env
build-base-image: export DOCKER_SPECIFIC_ENV_PATH_FROM_PYTHON_DOCKER=../../config/docker/env/python.env
build-base-image:
	make -C git_projects/python-docker build-base-image

build-arrnounced: export DOCKER_COMMON_ENV_PATH=../../config/docker/env/common.env
build-arrnounced: export DOCKER_SPECIFIC_ENV_PATH=../../config/docker/env/arrnounced_build.env
build-arrnounced:
	make -C git_projects/arrnounced build-project


include config/docker/env/common.env
include config/docker/env/launch.env
export

deploy-project:

	DOCKER_APP_DEST=$(DOCKER_APP_DEST) \
	DOCKER_TAG_VERSION=$(DOCKER_TAG_VERSION) \
	NAMESPACE=$(NAMESPACE) \
	docker compose \
		-f config/docker/compose/docker-compose.arrnounced.yaml \
		up

	