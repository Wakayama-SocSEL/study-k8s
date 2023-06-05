# 3つのDockerホストを立ち上げる（manager, worker01, worker02）
docker-compose up -d

# 10秒待つ
sleep 10

# managerをSwarm managerとしてSwarmクラスタを作成する
docker container exec -it manager docker swarm init

# join-tokenを取得する
JOIN_TOKEN=$(docker container exec -it manager docker swarm join-token -q worker)
JOIN_TOKEN=$(echo $JOIN_TOKEN | cut -c -85)

# worker01, worker02，worker03をSwarmクラスタに登録する
docker container exec -it worker01 docker swarm join --token $JOIN_TOKEN manager:2377
docker container exec -it worker02 docker swarm join --token $JOIN_TOKEN manager:2377
docker container exec -it worker03 docker swarm join --token $JOIN_TOKEN manager:2377

# 複数のホストをOverlayネットワークで通信できるようにする
docker container exec -it manager docker network create --driver=overlay --attachable todoapp

# Dockerfileのビルド
cd tododb
docker image build -t ch04/tododb:latest .

# registryコンテナにDocker imageをpushする
docker image tag ch04/tododb:latest localhost:5000/ch04/tododb:latest
docker image push localhost:5000/ch04/tododb:latest

# StackをSwarmクラスタにデプロイ
# ch03_5_1のdocker-compose.ymlをstackの下へ移動させておく
docker container exec -it manager docker stack deploy -c /stack/todo-mysql.yml todo_mysql

# Serviceがデプロイされているか確認
docker container exec -it manager docker service ls

# MasterコンテナがSwarm上のどのノードに配置されているのか確認する
docker container exec -it manager docker service ps todo_mysql_master --no-trunc --filter "desired-state=running"
