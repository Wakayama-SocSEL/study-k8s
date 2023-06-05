cd todonginx
docker image build -t ch04/nginx:latest .
docker image tag ch04/nginx:latest localhost:5000/ch04/nginx:latest
docker image push localhost:5000/ch04/nginx:latest
docker container exec -it manager docker stack deploy -c /stack/todo-app.yml todo_app
