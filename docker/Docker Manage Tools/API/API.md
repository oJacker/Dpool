
## 介绍 ##

 本文提供了一种通过使用Portainer作为网关来管理Docker资源的简单方法（针对Portainer API的HTTP查询）。

警告：本文档适用于Portainer> = 1.14.0。

注意：我使用httpie从CLI执行HTTP查询。

### 部署Portainer实例 ###

	# Note: I'm bind-mouting the Docker socket to be able to manage the local engine where Portainer is running.
	# You can skip the bind-mount if you want to manage a remote environment.
	
	$ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer

### 初始化管理员密码 ###

	$ http POST :9000/api/users/admin/init Username="admin" Password="adminpassword"

### 使用管理员帐户进行API验证 ###

	$ http POST :9000/api/auth Username="admin" Password="adminpassword"

响应是在该jwt字段内包含JWT令牌的JSON对象：

	{
	   “ jwt ”：“ eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE ” 
	}

你需要检索这个令牌。在执行针对API的验证查询时，您需要在**授权**标头内传递此令牌。

**授权**标头的值必须是格式Bearer <JWT_TOKEN>。

	Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE

**注意**：此令牌具有8小时的有效期，您需要生成另一个令牌，以便在此令牌到期后执行已验证的查询。

### 创建一个新的端点 ###

在这里，我将展示如何创建3种不同类型的端点：
- 
- 使用Docker套接字通信的本地端点
- 使用TCP通信的远程端点
- 使用通过TLS保护的TCP通信的远程端点

### 通过Docker套接字的本地端点 ###

该查询将创建一个名为test-local的端点，并使用Docker套接字与此环境进行通信。

注意：本示例要求在运行Portainer时绑定挂载Docker套接字。

	$ http POST :9000/api/endpoints \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	Name="test-local" URL="unix:///var/run/docker.sock"

响应是包含该Id字段中端点ID的JSON对象：

	{
	   “ Id ”：1 
	}


检索此ID，它将用于针对该端点的Docker引擎执行查询。

### 远程端点 ###

此查询将创建一个名为test-remote的端点，并将使用IP地址10.0.7.10和端口2375（这些是示例值，确保您使用正确的IP和端口）通过TCP与此环境进行通信。

注意：Docker API必须公开在该IP地址和端口上。请参考Docker文档来检查如何配置它。

	$ http POST :9000/api/endpoints \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	Name="test-remote" URL="tcp://10.0.7.10:2375"


响应是包含该Id字段中端点ID的JSON对象：

	{
	   “ Id ”：1 
	}
检索此ID，它将用于针对该端点的Docker引擎执行查询。

### 使用TLS保护远程端点 ###


此查询将创建一个名为test-remote-tls的端点，并将使用IP地址10.0.7.10和端口2376通过TCP（使用TLS进行保护）与此环境进行通信（这些是示例值，确保您使用的是正确的IP ＆ 港口）。

注意：Docker API必须公开在该IP地址和端口上。请参考Docker文档来检查如何配置它。

	$ http POST :9000/api/endpoints \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	Name="test-remote" URL="tcp://10.0.7.10:2376" TLS:=true

响应是包含该Id字段中端点ID的JSON对象：

	{
	   “ Id ”：1 
	}

检索此ID，它将用于针对该端点的Docker引擎执行查询。

作为额外的步骤，您需要上传与此端点进行TLS通信所需的文件。

上传查询是针对以下API端点执行的/api/upload/tls/<FILE_TYPE>?folder=<ENDPOINT_ID>，确保您在进入下一步之前检索到端点ID。

上传TLS CA文件：

	$ http --form POST :9000/api/upload/tls/ca?folder=1 \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	file@/path/to/ca.pem

上传TLS证书文件：

	$ http --form POST :9000/api/upload/tls/cert?folder=1 \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	file@/path/to/cert.pem
上传TLS密钥文件：

	$ http --form POST :9000/api/upload/tls/key?folder=1 \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	file@/path/to/key.pem


### 针对特定端点执行Docker查询 ###


通过使用以下Portainer HTTP API端点/api/endpoints/<ENDPOINT_ID>/docker，您现在可以执行任何Docker HTTP API请求。

这个Portainer HTTP API端点充当Docker HTTP API的反向代理。

注意：您可以参考[**Docker API**](https://docs.docker.com/engine/api/v1.30/)文档以获取有关如何查询Docker引擎的更多信息。

作为一个例子，下面是如何列出特定端点中可用的所有容器：

	$ http GET :9000/api/endpoints/1/docker/containers/json \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	all==true

响应与Docker API的ContainerList操作返回的完全相同，请参阅[ContainerList操作](https://docs.docker.com/engine/api/v1.30/#operation/ContainerList)的文档。

### 创建一个容器 ###

以下是如何使用Portainer HTTP API作为网关在特定端点中创建容器。

此查询将使用ID 1在端点内创建一个新的Docker容器。该容器将命名为web01，使用nginx：最新的 Docker镜像，并通过主机上的8080端口发布容器端口80。

请参阅下面的链接以获取有关如何使用Docker HTTP API创建容器的更多信息。

	$ http POST :9000/api/endpoints/1/docker/containers/create \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	name=="web01" Image="nginx:latest" \
	ExposedPorts:='{ "80/tcp": {} }' \
	HostConfig:='{ "PortBindings": { "80/tcp": [{ "HostPort": "8080" }] } }'


响应与Docker API的[ContainerCreate](https://docs.docker.com/engine/api/v1.30/#operation/ContainerCreate)操作返回的完全相同，请参阅ContainerCreate操作的文档。

响应示例：

	{
	     “ Id ”：“ 5fc2a93d7a3d426a1c3937436697fc5e5343cc375226f6110283200bede3b107 ”，
	     “警告”：null 
	}
检索容器的ID，您将需要它对该容器执行操作。

### 启动一个容器 ###


您现在可以启动您之前使用端点创建的容器/api/endpoints/<ENDPOINT_ID>/docker/containers/<CONTAINER_ID>/start（确保您检索了预先创建的容器的ID）：

	$ http POST :9000/api/endpoints/1/docker/containers/5fc2a93d7a3d426a1c3937436697fc5e5343cc375226f6110283200bede3b107/start \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE"
该响应与Docker API的ContainerStart操作返回的完全相同，请参阅[ContainerStart操作](https://docs.docker.com/engine/api/v1.30/#operation/ContainerStart)的文档。

### 删除一个容器 ###

您可以使用以下端点创建容器/api/endpoints/<ENDPOINT_ID>/docker/containers/<CONTAINER_ID>/remove：

	$ http DELETE :9000/api/endpoints/1/docker/containers/5fc2a93d7a3d426a1c3937436697fc5e5343cc375226f6110283200bede3b107 \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	force==true
该响应与Docker API的ContainerDelete操作返回的完全相同，请参阅[ContainerDelete](https://docs.docker.com/engine/api/v1.30/#operation/ContainerDelete)操作的文档。

## 在Swarm环境中管理Docker堆栈 ##

 
通过使用以下Portainer HTTP API端点/api/endpoints/<ENDPOINT_ID>/stacks，您可以在特定的Docker环境（Portainer端点）内部署和移除堆栈。

警告：这些说明仅适用于Swarm群集。

在下面的说明中，我假设使用ID 1的端点连接到Swarm集群。

在尝试创建任何堆栈之前，您需要检索Swarm集群的标识符。它将用于在接下来的步骤中创建堆栈。

	$ http GET :9000/api/endpoints/1/docker/info \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE"


在该查询的响应中，您可以在Swarm.Cluster.ID项目下找到Swarm集群的标识符：

	{
	   “ Swarm ”：{
	     “ Cluster ”：{
	       “ ID ”：“ jpofkc0i9uo9wtx1zesuk649w ”
	    }
	  }  
	}

### 从公共Git存储库部署新的堆栈 ###

该查询将使用ID 1在端点内创建一个新堆栈。该堆栈将被命名为myTestStack，使用存储在公共Git存储库[https://github.com/portainer/templates](https://github.com/portainer/templates)下的路径堆栈/ cockroachdb / docker-stack.yml中的堆栈文件。

	$ http POST :9000/api/endpoints/1/stacks?method=repository \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE" \
	Name="myTestStack" \
	SwarmID="jpofkc0i9uo9wtx1zesuk649w" \
	GitRepository="https://github.com/portainer/templates" \
	PathInRepository="stacks/cockroachdb/docker-stack.yml"

响应是包含Id字段中堆栈ID的JSON对象：

	{
	   “ Id ”：“ myTestStack_jpofkc0i9uo9wtx1zesuk649w ” 
	}

保留这个标识符，你需要它来管理堆栈。

### 删除现有的堆栈 ###

该查询将使用ID 1在端点内移除标识为myTestStack_jpofkc0i9uo9wtx1zesuk649w的现有堆栈。

	$ http DELETE :9000/api/endpoints/1/stacks/myTestStack_jpofkc0i9uo9wtx1zesuk649w \
	"Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsImV4cCI6MTQ5OTM3NjE1NH0.NJ6vE8FY1WG6jsRQzfMqeatJ4vh2TWAeeYfDhP71YEE"