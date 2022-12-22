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

	