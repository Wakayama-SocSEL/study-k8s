docker image build -t ch04/todoapi:latest .
docker image tag ch04/todoapi:latest localhost:5000/ch04/todoapi:latest
docker image push localhost:5000/ch04/todoapi:latest
docker container exec -it manager docker stack deploy -c /stack/todo-app.yml todo_app
docker container exec -it manager docker service logs -f todo_app_api
