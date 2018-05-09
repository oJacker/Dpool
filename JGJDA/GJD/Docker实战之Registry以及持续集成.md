# Docker实战之Registry以及持续集成 #

重点：如何通过Docker以及Registry实现自动化的镜像构建，自动部署以及持续集成测试

1. 通过GIT仓库，自动生成Docker 镜像
2. 自动将多个容器部署
3. 利用jenkins自动做集成测试


docker-compose up 

docker-compose stop
docker-compose ps
docker-compose rm


docker run -d -p 8080:8080 --name jankins -v /usr/bin/docker:/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -v /root/maven-tar:/root csphere/jenkins:1.609

docker exec -it docker  /bin/bash

docker ps -a
