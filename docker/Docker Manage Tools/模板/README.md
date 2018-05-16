# 模板 #


模板定义是用JSON编写的。

它必须包含一个数组，每个模板定义由一个元素组成。

## 容器模板定义格式 ##

模板元素必须是有效的JSON对象。

容器模板示例：

	{
	  "type": "container",
	  "title": "Nginx",
	  "description": "High performance web server",
	  "logo": "https://cloudinovasi.id/assets/img/logos/nginx.png",
	  "image": "nginx:latest",
	  "ports": [
	    "80/tcp",
	    "443/tcp"
	  ]
	}

它由多个领域组成，一些强制性的和一些选择权。

**type**

模板类型，无论是容器还是堆栈。该字段是强制性的。

**title**

模板的标题。该字段是强制性的。

**description**

模板描述。该字段是强制性的。

**image**

与模板关联的Docker镜像。图像标签必须包含在内。该字段是强制性的。

**name**

用户界面中用于此模板的默认名称。该字段是可选的。

**logo**

模板徽标的网址。该字段是可选的。

**registry**

Docker镜像存储的注册表。如果未指定，Portainer将使用Dockerhub作为默认注册表。该字段是可选的。

**command**

要在容器中运行的命令。如果未指定，容器将使用在其Dockerfile中指定的默认命令。该字段是可选的。

例：

	{
	  "command": "/bin/bash -c \"echo hello\" && exit 777"
	}

**env**

描述模板所需的环境变量的JSON数组。数组中的每个元素都必须是有效的JSON对象。

将在模板视图中为阵列中的每个元素生成一个输入。

根据类型字段中的值，视图将显示不同的输入。例如，当为类型字段使用值容器时，UI将显示包含所有正在运行的容器的下拉菜单。容器主机名将作为值插入到环境变量中。

支持的类型：

- 容器

该字段是**可选的**。

元素格式：

	{
	  "name": "the name of the environment variable, as supported in the container image (mandatory)",
	  "label": "label for the input in the UI (mandatory)",
	  "type": "only container is available at the moment (optional)",
	  "set": "pre-defined value for the variable, will not generate an input in the UI (optional)"
	}


例：

	{
	  "env": [
	    {
	      "name": "MYSQL_ROOT_PASSWORD",
	      "label": "Root password"
	    },
	    {
	      "name": "MYSQL_USER",
	      "label": "MySQL user",
	      "set": "myuser"
	    },
	    {
	      "name": "MYSQL_PASSWORD",
	      "label": "MySQL password",
	      "set": "mypassword"
	    }
	  ]
	}

**network**

一个字符串，对应于现有Docker网络的名称。

将在模板视图中自动选择网络（如果存在）。该字段是可选的。

例：

	{
	  "network": "host"
	}

**volumes**

描述模板相关卷的JSON数组。数组中的每个元素必须是具有必需容器属性的有效JSON对象。

对于数组中的每个元素，将在创建容器时创建并关联Docker卷。如果定义了绑定属性，则它将用作绑定安装的源。

该字段是可选的。

例：

	{
	  "volumes": [
	    {
	      "container": "/etc/nginx"
	    },
	    {
	      "container": "/usr/share/nginx/html",
	      "bind": "/var/www"
	    }
	  ]
	}


**ports**

描述由模板公开的端口的JSON数组。数组中的每个元素都必须是一个有效的JSON字符串，用于指定容器和协议中的端口号。

启动容器时，Docker会自动将主机绑定到主机上。

该字段是可选的。

例：

	{
	  "ports": ["80/tcp", "443/tcp"]
	}


**labels**

描述与模板关联的标签的JSON数组。数组中的每个元素必须是具有两个属性name和的有效JSON对象value。

该字段是可选的。

例：

	{
	  "labels": [
	    { "name": "com.example.vendor", "value": "Acme" },
	    { "name": "com.example.license", "value": "GPL" },
	    { "name": "com.example.version", "value": "1.0" }
	  ]
	}

**privileged**

容器应该以特权模式启动。布尔值，如果未指定，则默认为false。

该字段是可选的。

	{
	  "privileged": true
	}

**interactive**

容器应该在前台启动（相当于标志）。布尔值，如果未指定，则默认为false。-i -t

该字段是可选的。

	{
	  "interactive": true
	}

**restart_policy**

重新启动与容器关联的策略。值必须是以下值之一：

- 没有
- 除非，停止
- 在故障
- 总是


该字段是可选的。always如果未指定，将默认为。

	{
	  "restart_policy": "unless-stopped"
	}


**hostname**

设置容器的主机名。

该字段是可选的。如果未指定，将使用Docker默认值。

	{
	  "hostname": "mycontainername"
	}

**note**

有关模板的用法/额外信息。这将显示在Portainer UI中的模板创建表单中。

支持HTML。

该字段是可选的。

	{
	  "note": "You can use this field to specify extra information. <br/> It supports <b>HTML</b>."
	}

**platform**

支持的平台。该字段值必须设置为linux或windows。这将在Portainer UI中显示一个与平台相关的小图标。

该字段是可选的。

	{
	  "platform": "linux"
	}

**categories**

将与模板关联的一组类别。Portainer UI类别过滤器将根据所有可用的类别进行填充。

该字段是可选的。

	{
	  "categories": ["webserver", "open-source"]
	}

### 堆栈模板定义格式 ###


模板元素必须是有效的JSON对象。

堆栈模板只能通过Swarm集群部署。Portainer目前不兼容。**docker stack deploydocker-compose**

堆栈模板示例：


	{
	  "type": "stack",
	  "title": "CockroachDB",
	  "description": "CockroachDB cluster",
	  "note": "Deploys an insecure CockroachDB cluster, please refer to <a href=\"https://www.cockroachlabs.com/docs/stable/orchestrate-cockroachdb-with-docker-swarm.html\" target=\"_blank\">CockroachDB documentation</a> for production deployments.",
	  "categories": ["database"],
	  "platform": "linux",
	  "logo": "https://cloudinovasi.id/assets/img/logos/cockroachdb.png",
	  "repository": {
	    "url": "https://github.com/portainer/templates",
	    "stackfile": "stacks/cockroachdb/docker-stack.yml"
	  }
	}

它由多个领域组成，一些强制性的和一些选择权。

**type**

模板类型，无论是容器还是堆栈。

该字段是强制性的。

**title**

模板的标题。

该字段是强制性的。

**description**

模板描述。

该字段是强制性的。

**repository**

一个JSON对象，用于描述将从中加载堆栈模板的公共git存储库。它指示了git存储库的URL以及存储库内的Compose文件的路径。

元素格式：
	
	{
	  "url": "URL of the public git repository (mandatory)",
	  "stackfile": "Path to the Compose file inside the repository (mandatory)",
	}

例：

	{
	  "url": "https://github.com/portainer/templates",
	  "stackfile": "stacks/cockroachdb/docker-stack.yml"
	}

该字段是**强制性**的。

**name**


用户界面中用于此模板的默认名称。该字段是可选的。

**logo**

模板徽标的网址。该字段是可选的。

**env**

描述模板所需的环境变量的JSON数组。数组中的每个元素都必须是有效的JSON对象。

将在模板视图中为阵列中的每个元素生成一个输入。根据对象属性，可以生成不同类型的输入（文本输入，选择）。该字段是可选的。

元素格式：
	
	{
	  "name": "the name of the environment variable, as supported in the container image (mandatory)",
	  "label": "label for the input in the UI (mandatory unless set is present)",
	  "description": "a short description for this input, will be available as a tooltip in the UI (optional)",
	  "set": "pre-defined value for the variable, will not generate an input in the UI (optional)",
	  "select": "an array of possible values, will generate a select input (optional)"
	}


例：

	{
	  "env": [
	    {
	      "name": "MYSQL_ROOT_PASSWORD",
	      "label": "Root password",
	      "description": "Password used by the root user."
	    },
	    {
	      "name": "ENV_VAR_WITH_DEFAULT_VALUE",
	      "set": "some_value"
	    },
	    {
	      "name": "ENV_VAR_WITH_SELECT_VALUE",
	      "label": "An environment variable",
	      "select": [
	        {
	          "text": "Yes, I agree",
	          "value": "Y"
	        },
	        {
	          "text": "No, I disagree",
	          "value": "N"
	        },
	        {
	          "text": "Maybe",
	          "value": "YN"
	        }
	      ],
	      "description": "Some environment variable."
	    }
	  ]
	}

**note**


有关模板的用法/额外信息。这将显示在Portainer UI中的模板创建表单中。

支持HTML。该字段是可选的。

	{
	  "note": "You can use this field to specify extra information. <br/> It supports <b>HTML</b>."
	}


**platform**


支持的平台。该字段值必须设置为linux或windows。这将在Portainer UI中显示一个与平台相关的小图标。

该字段是可选的。

	{
	  "platform": "linux"
	}

**categories**

将与模板关联的一组类别。Portainer UI类别过滤器将根据所有可用的类别进行填充。该字段是**可选的。**

	{
	  "categories": ["webserver", "open-source"]
	}

### 建立和托管你自己的模板 ###

您可以构建自己的容器，它将使用Nginx来提供模板定义。

克隆Portainer模板存储库，编辑模板文件，构建并运行容器：

	$ git clone https://github.com/portainer/templates.git portainer-templates
	$ cd portainer-templates
	# Edit the file templates.json
	$ docker build -t portainer-templates .
	$ docker run -d -p "8080:80" portainer-templates

现在你可以访问你的模板定义http://docker-host:8080/templates.json。

您也可以templates.json在容器中安装文件，以便您可以编辑文件并查看实时更改：

	$ docker run -d -p "8080:80" -v "${PWD}/templates.json:/usr/share/nginx/html/templates.json" portainer-templates

