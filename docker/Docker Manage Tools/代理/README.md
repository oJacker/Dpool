## 目的 ##

代理的目的是解决Docker API的限制。当使用Docker API管理Docker环境时，用户与特定资源（容器，网络，卷和映像）的交互限于Docker API请求所指向的节点上的这些可用资源。

Docker Swarm模式引入了Docker节点集群的概念。有了这个概念，它还引入了集群感知资源的服务，任务，配置和秘密。这意味着只要您在管理器节点上执行Docker API请求，就可以查询服务列表或检查集群中任何节点内的任务。

容器，网络，卷和映像是特定于节点的资源，不支持群集。如果要获取集群中节点号为3的所有可用卷的列表，则需要执行请求以查询该特定节点上的卷。

代理目的旨在解决该问题，并在保持Docker API请求格式的同时使容器，网络和卷资源集群可识别。

这意味着您只需执行一个Docker API请求即可检索群集中的所有卷。

最终目标是在管理Swarm集群时带来更好的Docker UX。


## 部署 ##

部署Portainer代理并将Portainer连接到代理的说明。

### 其部署为堆栈 ###

查看[Swarm]()集群中的部署文档，以便通过Swarm集群快速部署代理和Portainer实例。**docker stack deploy**

### 手动部署 ### 

总体而言，该设置包含以下步骤：

- 第1步：在您的Swarm群集中为Portainer代理创建一个新的覆盖网络
- 步骤2：将Portainer代理部署为群集中的全局服务（在先前创建的覆盖网络中）
- 第3步：使用代理IP：PORT作为端点，将Portainer实例连接到任何代理

**注意：**此设置将假定您正在Swarm管理器节点上执行以下指令。


第一步，在您的Swarm集群中创建一个新的覆盖网络：

	$ docker network create --driver overlay portainer_agent_network

第二步，在您之前创建的网络内将代理部署为全局服务：

	$ docker service create \
	    --name portainer_agent \
	    --network portainer_agent_network \
	    -e AGENT_CLUSTER_ADDR=tasks.portainer_agent \
	    --mode global \
	    --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
	    portainer/agent

第三步，将Portainer实例部署为服务：

	$ docker service create \
	    --name portainer \
	    --network portainer_agent_network \
	    --publish 9000:9000 \
	    --replicas=1 \
	    --constraint 'node.role == manager' \
	    portainer/portainer -H "tcp://tasks.portainer_agent:9001" --tlsskipverify

### 将现有的Portainer实例连接到代理 ###

如果要将现有的Portainer实例连接到代理，则可以在创建新端点时选择代理环境类型。

确保您在部署代理时（默认端口为9001）通过Swarm集群内的Agent端口暴露：

	$ docker service create \
	    --name portainer_agent \
	    --network portainer_agent_network \
	    --publish 9001:9001 \
	    -e AGENT_CLUSTER_ADDR=tasks.portainer_agent \
	    --mode global \
	    --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
	    portainer/agent

然后，您可以使用代理程序URL字段内群集中任何节点的地址（以及代理程序端口）。

### 配置 ###

您可以使用环境变量更改代理的配置。

可以调整以下环境变量：

- AGENT_PORT：代理端口（默认：9001）
- LOG_LEVEL：代理日志级别（默认：INFO）