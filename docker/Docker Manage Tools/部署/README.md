## 部署 ##

Portainer 构建在Docker上运行，部署简单，适用于任何平台

## 快速入门 ##

### docker 部署 ###

	$ docker volume create portainer_data
	$ docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

现在可以通过访问IP:9000 来使用Portainer

### Swarm  集群内部 ###

使用代理设置在Swarm集群内部部署Portainer。

注意：此设置将假定您正在Swarm管理器节点上执行以下指令。

	$ curl -L https://portainer.io/download/portainer-agent-stack.yml -o portainer-agent-stack.yml
	$ docker stack deploy --compose-file=portainer-agent-stack.yml portaine

查看**代理**部分以查找有关如何将现有Portainer实例连接到手动部署Portainer代理的更多详细信息。

### Portainer数据 ###

默认情况下，Portainer将其数据存储/data在Linux（C:\\dataWindows上）文件夹中的容器中。

您需要Portainer数据，以便在重新启动/升级Portainer容器后保留更改。您可以使用绑定挂载来保存Docker主机文件夹上的数据：

	$ docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /path/on/host/data:/data portainer/portainer

**Windows上的示例：**

	$ docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v C:\ProgramData\Portainer:C:\data portainer/portainer

将Portainer部署为Docker Swarm服务：

	$ docker service create \
	    --name portainer \
	    --publish 9000:9000 \
	    --replicas=1 \
	    --constraint 'node.role == manager' \
	    --mount type=bind,src=//path/on/host/data,dst=/data \
	    portainer/portainer

注意：Swarm服务示例将为群/path/on/host/data集中的每个主机持久保存Portainer数据。如果容器在另一个节点上重新排定，则现有的Portainer数据可能不可用。在Swarm集群的所有节点上持久保存数据超出了本文档的范围。


## 高级部署 ##

**Docker环境以进行部署管理**

可以指定您希望Portainer通过CLI管理的初始环境，使用-H标志和tcp://协议连接到远程Docker环境：

	$ docker run -d -p 9000:9000 --name portainer --restart always -v portainer_data:/data portainer/portainer -H tcp://<REMOTE_HOST>:<REMOTE_PORT>

确保您更换REMOTE_HOST，并REMOTE_PORT与您要管理的服务器泊坞窗的地址/端口。

还可以绑定装载Docker套接字来管理本地Docker环境（**仅适用于Unix套接字可用的环境**）：

	$ docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer -H unix:///var/run/docker.sock


如果您的Docker环境使用TLS进行保护，则需要确保您有权访问CA，证书和用于访问Docker引擎的公钥。

您可以通过Portainer UI上载所需的文件或使用**--tlsverifyCLI**上的标志。

Portainer将尝试使用以下路径指定先前指定的文件（在Linux上，请参阅配置部分以获取有关Windows的详细信息）：

- CA： /certs/ca.pem
- 证书： /certs/cert.pem
- 公钥： /certs/key.pem

必须使用绑定挂载确保这些文件存在于容器中：

	$ docker run -d -p 9000:9000 --name portainer --restart always  -v /path/to/certs:/certs -v portainer_data:/data portainer/portainer -H tcp://<DOCKER_HOST>:<DOCKER_PORT> --tlsverify

也可以使用**--tlscacert，--tlscert**而**--tlskey**如果你想分别更改默认路径CA，证书和密钥文件的标志：

	$ docker run -d -p 9000:9000 --name portainer -v /path/to/certs:/certs portainer/portainer -H tcp://<DOCKER_HOST>:<DOCKER_PORT> --tlsverify --tlscacert /certs/myCa.pem --tlscert /certs/myCert.pem --tlskey /certs/myKey.pem
	$ docker run -d -p 9000:9000 --name portainer --restart always  -v /path/to/certs:/certs -v portainer_data:/data portainer/portainer -H tcp://<DOCKER_HOST>:<DOCKER_PORT> --tlsverify --tlscacert /certs/myCa.pem --tlscert /certs/myCert.pem --tlskey /certs/myKey.pem


### 安全Portainer使用SSL ###

默认情况下，Portainer的Web界面和API通过HTTP公开。这不是安全的，建议在生产环境中启用SSL。

为此，您可以使用以下标志**--ssl，--sslcert**并且**--sslkey**：

	$ docker run -d -p 443:9000 --name portainer --restart always -v ~/local-certs:/certs -v portainer_data:/data portainer/portainer --ssl --sslcert /certs/portainer.crt --sslkey /certs/portainer.key

可以使用以下命令来生成所需的文件：

	$ openssl genrsa -out portainer.key 2048
	$ openssl ecparam -genkey -name secp384r1 -out portainer.key
	$ openssl req -new -x509 -sha256 -key portainer.key -out portainer.crt -days 3650

也可以使用**Certbot**来生成证书和密钥。

**docker-compose 来部署Protainer**

Dockerfile:

	version: '2'
	
	services:
	  portainer:
	    image: portainer/portainer
	    command: -H unix:///var/run/docker.sock
	    volumes:
	      - /var/run/docker.sock:/var/run/docker.sock
	      - portainer_data:/data
	
	volumes:
	  portainer_data:

**Protainer 二进制安装**

	$ cd /opt
	$ wget https://github.com/portainer/portainer/releases/download/1.17.0/portainer-1.17.0-linux-amd64.tar.gz
	$ tar xvpfz portainer-1.17.0-linux-amd64.tar.gz


注意：Portainer默认会尝试将其数据写入/ data文件夹。你必须确保这个文件夹首先存在（或者通过改变它将使用的路径--data，见下文）。

	$ mkdir /data
	$ cd /opt/portainer
	$ ./portainer

	使用该-p标志在另一个端口上为Portainer服务：

	$ ./portainer -p :8080

	可以更改Portainer使用的文件夹以存储其数据--data：

	$ ./portainer --data /opt/portainer-data