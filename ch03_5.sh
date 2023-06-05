cd ch03_5

# 3つのDockerホストを立ち上げる（manager, worker01, worker02）
docker-compose up -d

# managerをSwarm managerとしてSwarmクラスタを作成する
docker container exec -it manager docker swarm init

# join-tokenを取得する
JOIN_TOKEN=$(docker container exec -it manager docker swarm join-token -q worker)

# worker01, worker02，worker03をSwarmクラスタに登録する
docker container exec -it worker01 docker swarm join --token $JOIN_TOKEN manager:2377
docker container exec -it worker02 docker swarm join --token $JOIN_TOKEN manager:2377
docker container exec -it worker03 docker swarm join --token $JOIN_TOKEN manager:2377

# 複数のホストをOverlayネットワークで通信できるようにする
docker container exec -it manager docker network create --driver=overlay --attachable todoapp
