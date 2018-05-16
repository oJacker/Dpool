## 配置 ##

Portainer  可以使用CLI标志轻松调整

### 禁用认证 ###

要禁用Portainer内部认证机制，请使用以下--no-auth标志启动Portainer

	$ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer --no-auth

### 管理员密码 ###

**命令行：**

Portainer允许您从管理员帐户的命令行中指定加密的密码。您需要先生成加密的密码。

可以使用以下命令生成加密密码：

	$ htpasswd -nb -B admin <password> | cut -d ":" -f 2

或者如果你的系统没有提供htpasswd你可以使用docker容器和命令：

	$ docker run --rm httpd:2.4-alpine htpasswd -nbB admin <password> | cut -d ":" -f 2

命令行指定管理员密码，请使用以下--admin-password标志启动Portainer ：

	$ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer --admin-password '$2y$05$qFHAlNAH0A.6oCDe1/4W.ueCWC/iTfBMXIHBI97QYfMWlMCJ7N.a6'

**文件**

可以将明文密码存储在文件中并使用该--admin-password-file标志：

	# mypassword is plaintext here
	$ echo -n mypassword > /tmp/portainer_password
	$ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/portainer_password:/tmp/portainer_password portainer/portainer --admin-password-file /tmp/portainer_password

也适用于**Swarm和Docker**的秘密：

	# mypassword is plaintext here
	$ echo -n mypassword | docker secret create portainer-pass -
	$ docker service create \
	  --name portainer \
	  --secret portainer-pass \
	  --publish 9000:9000 \
	  --replicas=1 \
	  --constraint 'node.role == manager' \
	  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
	  portainer/portainer \
	  --admin-password-file '/run/secrets/portainer-pass' \
	  -H unix:///var/run/docker.sock

注意：这将自动创建一个名为admin的管理员帐户，并使用指定的密码。

### 隐藏特定容器 ###

Portainer允许您使用-l标志来隐藏具有特定标签的容器。

例如，取一个以标签owner = acme开头的容器（请注意，这是一个示例标签，您可以定义自己的标签）：

	$ docker run -d --label owner=acme nginx

要隐藏此容器，只需在启动Portainer时在CLI中添加该选项即可：-l owner=acme

	$ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer -l owner=acme


-l标志可以重复多次以指定多个标签：

	$ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer -l owner=acme -l service=secret

### 使用你自己的标志 ###

可以轻松地使用标志切换外部徽标（它必须完全为155像素×55像素）--logo：

	$ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer --logo "https://www.docker.com/sites/all/themes/docker/assets/images/brand-full.svg"


### 使用你自己的模板 ###

Portainer允许您使用App Templates快速部署容器。

默认使用Portainer模板，但您也可以定义自己的模板。

添加--templates标志并在启动Portainer时指定模板的外部位置：

	$ docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer --templates http://my-host.my-domain/templates.json

有关自己的模板定义的更多信息，请参阅模板

### 使用外部端点源 ###

Portainer允许您从JSON文件中定义UI中可用的所有端点。

您只需使用**--external-endpoints**标志启动Portainer 并指定容器中JSON文件的路径。

注意：当使用外部端点管理时，终端管理将在用户界面中被禁用。

	$ docker run -d -p 9000:9000 -v /tmp/endpoints:/endpoints portainer/portainer --external-endpoints /endpoints/endpoints.json

有关端点定义格式的更多信息，请参阅**外部端点**


### 可用标志 ###

以下CLI标志可用：

	--host，-H：Docker守护进程端点
	--bind，-p：地址和端口提供Portainer（默认值：:9000）
	--data，-d：存储Portainer数据的目录（默认：/data在Linux上，C:\data在Windows上）
	--tlsverify：支持TLS（默认false）
	--tlscacert：CA的路径（默认：/certs/ca.pem在Linux上，C:\certs\ca.pem在Windows上）
	--tlscert：TLS证书文件的路径（默认：/certs/cert.pem，C:\certs\cert.pem在Windows上）
	--tlskey：TLS键的路径（默认：/certs/key.pem，C:\certs\key.pem在Windows上）
	--no-analytics：禁用分析（默认值：false）
	--no-auth：禁止内部认证机制（默认值：false）
	--external-endpoints：通过指定文件中JSON端点源的路径来启用外部端点管理
	--sync-interval：两个端点的同步请求之间的时间间隔表示为一个字符串，例如30s，5m，1h...利用所支持的time.ParseDuration方法（默认：60s）
	--admin-password：表单中的管理员密码 admin:<hashed_password>
	--admin-password-file：包含管理员用户密码的文件的路径
	--ssl：使用SSL安全Portainer实例（默认值：false）
	--sslcert：用于保护Portainer实例的SSL证书的路径（默认：/certs/portainer.crt，C:\certs\portainer.crt在Windows上）
	--sslkey：用于保护Portainer实例的SSL密钥的路径（默认：/certs/portainer.key，C:\certs\portainer.key在Windows上）
	--hide-label，-l：在UI中隐藏具有特定标签的容器
	--logo：图片的URL在UI中显示为徽标，如果未指定，则使用Portainer徽标
	--templates，-t：网址模板（应用程序）的定义（默认值：https://raw.githubusercontent.com/portainer/templates/master/templates.json）