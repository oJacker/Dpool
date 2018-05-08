# Docker 图形化管理和监控 #

## Docker 管理工具 ##

### Docker 管理工具之管方三剑客 ###

#### Docker Machine ####

**以前** 需要登录主机，安装主机及操作系统特有的安装以及配置步骤安装Docker，使其能运行Docker容器

**现在** Docker Machine 的生产简化了这一个过程，让你可以使用一条命令在你的计算机，公有云平台以及私有数据中心创建及管理Docker主机

Create Docker Machine  主要包括三个Create过程：

- 首先是Provider Crate （libmachine/provider.go）,此函数主要是在当前运行docker-machine命令主机上创建以machine name 命名的文件夹，并将根证书，服务器证书以及用户证书拷贝到此文件夹

- 其次是Driver create（例如drivers/virtualbox/virtualbox.go）来创建主机

- 最后是运行Host create (libmachine/host.go) 通过SSH安装并配置Docker。目前在本环境中使用的是boot2docker镜像，云端环境使用的是Ubuntu镜像

自动创建一个虚拟机并且安装好设置好Docker Engine

- Docker Machine简化了部署的复杂度，无论是在本机的虚拟机上还是在公有云平台，只需要一条命令便可搭建好Docker主机

- Docker Machine提供了多平台多Docker主机的集中管理

- Docker Machine 使应用由本地迁移到云端变得简单，只需要修改一下环境变量即可和任意Docker主机通信部署应用。

与容器技术同样受到关注的微服务架构也在潜移默化的改变着应用的部署方式，其提倡将应用分割成一系列细小
的服务，每个服务专注于单一业务功能，服务之间采用轻量级通信机制相互沟通
#### Docker Swarm ####

**Swarm作为一个管理Docker集群的工具，可以单独部署于
一个节点。**

**Swarm的具体工作流程： Docker Client发送请求给Swarm
； Swarm处理请求并发送至相应的Docker Node； Docker
Node执行相应的操作并返回响应。**

1. 运行一个命令去创建一个集群.
2. 运行另一个命令去启动Swarm.
3. 在运行有Docker Engine的每个主机上，运行一个命令与上面的集群相连

在某些点, Swarm将可以在主机故障时重调度容器.
Swarm可以很好地与第三方容器编配产品和运供应商提供
的编配服务整合，如Mesos

**swarm**则将一组**docker enginge**作为一个集群进行管理，并提供过了**lablel， schedule， filter**的能力。其中调度部分，允许用户定制自己的调度策略。

	1. docker run -e "constraint:operationsystm=fedora"
	2. docker run -e "constraint:storagedriver=aufs"

#### Docker Composer ####
**Docker Compose**将所管理的容器分为三层，工程（ project），服务（ service）以及容器（ contaienr）。

一个工程当中可包含多个服务，每个服务中定义了容器运行的镜像，参数，依赖。一个服务当中可包括多个容
器实例， **Docker Compose并没有解决负载均衡的问题，因此需要借助其他工具实现服务发现及负载均衡。**

**Docker Compose**中定义构建的镜像只存在在一台Docker Swarm主机上， 无法做到多主机共享

**Docker 管理工具 ---Tutum 商业**

## Shipyard 入门 ##
**Shipyard** 是一个基于 **Web 的 Docker** 管理工具，支持多 **host**，可以把多个 **Docker host** 上的 **containers** 统
一管理；可以查看 **images**，甚至 **build images**；并提供 **RESTful API** 等等。 **Shipyard** 要管理和控制 **Docker**
**host** 的话需要先修改 **Docker host** 上的默认配置使其支持远程管理。

URL：[https://github.com/shipyard/shipyard/releases](https://github.com/shipyard/shipyard/releases)

需要纳管Docker主机，需要让Docker在TCP上监听，以便被纳管
OPTIONS=-H=unix:///var/run/docker.sock -H=tcp://0.0.0.0:2375

**安装shipyard**
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \ shipyard/deploy start

**运行：**
浏览器访问物理机的8080端口： http:ip:8080/ 默认用户名密码:**admin/shipyard**，，点击Engines标签页，
添加一个Docker主机（ Engine）：

需要配置Docker 主机的名字、 CPU核心数、内存数量（单位MB）、以及Labels，比如部署Web的标签为web，以后调度容器的时候，会优先调度到相应的标签。

添加docker是吧，则需要排除是否端口不可访问，可以用wget/telnet/curl等方式来排除问题；
	
	如：telnet ip  port
## cAdvisor入门 ##

**cAdvisor**的监控图默认1秒刷新一次，显示最近一分钟的实时数据，不显示汇聚的和历史数据，也没有阀值告警功能，此外它也无法同时监控多个Docker主机，不过由于其简单方便，并且具备很好的实时性能监控能力，所以适合特殊情况下的性能监控和问题排查。

google的cAdvisor，免费开源，实施简单，每个Docker主机上启动一个容器即可通过Web端口监控;

docker run --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --publish=8082:8082 --detach=true --name=cadvisorgoogle/cadvisor:latest --port=8082

上述部分参数可能与主机操作系统有关，需要修改，可参照官方文档： https://github.com/google/cadvisor
由于shipyard是在本机8080端口运行，因此上面把cAdvisor改为了8082端口，运行起来后，访问本机8082端口，可
看到监控界面：