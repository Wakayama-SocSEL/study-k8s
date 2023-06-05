cd todoweb
docker image build -t ch04/todoweb:latest .
docker image tag ch04/todoweb:latest localhost:5000/ch04/todoweb:latest
docker image push localhost:5000/ch04/todoweb:latest
docker container exec -it manager docker stack deploy -c /stack/todo-frontend.yml todo_frontend
docker container exec -it manager docker stack deploy -c /stack/todo-ingress.yml todo_ingress
