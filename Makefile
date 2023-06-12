SHELL=/bin/bash

.PHONY: build.swarm build.tododb build.todoapi build.nginx build.todoweb build

build.swarm:
	@docker container exec -it manager docker swarm init
	
	@JOIN_TOKEN=$$(docker container exec -it manager docker swarm join-token -q worker | cut -c -85); \
	docker container exec -it worker01 docker swarm join --token $${JOIN_TOKEN} manager:2377; \
	docker container exec -it worker02 docker swarm join --token $${JOIN_TOKEN} manager:2377; \
	docker container exec -it worker03 docker swarm join --token $${JOIN_TOKEN} manager:2377; \
	
	@docker container exec -it manager docker network create --driver=overlay --attachable todoapp

build.tododb:
	@cd tododb && \
	docker image build -t ch04/tododb:latest . && \
	docker image tag ch04/tododb:latest localhost:5000/ch04/tododb:latest && \
	docker image push localhost:5000/ch04/tododb:latest && \
	docker container exec -it manager docker stack deploy -c /stack/todo-mysql.yml todo_mysql

build.todoapi:
	@cd todoapi && \
	docker image build -t ch04/todoapi:latest . && \
	docker image tag ch04/todoapi:latest localhost:5000/ch04/todoapi:latest && \
	docker image push localhost:5000/ch04/todoapi:latest && \
	docker container exec -it manager docker stack deploy -c /stack/todo-app.yml todo_app

build.nginx:
	@cd todonginx && \
	docker image build -t ch04/nginx:latest . && \
	docker image tag ch04/nginx:latest localhost:5000/ch04/nginx:latest && \
	docker image push localhost:5000/ch04/nginx:latest && \
	docker container exec -it manager docker stack deploy -c /stack/todo-app.yml todo_app

build.todoweb:
	@cd todoweb && \
	docker image build -t ch04/todoweb:latest . && \
	docker image tag ch04/todoweb:latest localhost:5000/ch04/todoweb:latest && \
	docker image push localhost:5000/ch04/todoweb:latest && \
	docker container exec -it manager docker stack deploy -c /stack/todo-frontend.yml todo_frontend && \
	docker container exec -it manager docker stack deploy -c /stack/todo-ingress.yml todo_ingress

build: build.swarm build.tododb build.todoapi build.nginx build.todoweb