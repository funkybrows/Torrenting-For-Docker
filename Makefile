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

	