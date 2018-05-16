# 常见问题 #

## 我的主机正在使用SELinux，我可以使用Portainer吗？ ##

如果您想在启用SELinux的情况下管理本地Docker环境，则--privileged在部署Portainer时需要将该标志传递给Docker运行命令：

	$ docker run -d --privileged -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

## 如何通过TCP公开Docker API以便Portainer可以与我的环境进行通信？ ##

要管理远程Docker环境，Portainer必须能够通过网络与Docker API进行通信（通常在TCP 2375,2376上使用TLS）。

您必须根据您的网络环境考虑安全问题。

## 我如何在Windows Server 2016上安装Portainer？ ##

查看Airdesk博客文章中的说明。

## 如何在公开演示之外使用Portainer？ ##

您可以在Play-with-Docker中将Portainer部署为堆栈。

## 如何配置我的反向代理服务Portainer？ ##

这里是Nginx的工作配置（在1.11测试）为myhost.mydomain / portainer上的Portainer服务：

	upstream portainer {
	    server ADDRESS:PORT;
	}
	
	server {
	  listen 80;
	
	  location /portainer/ {
	      proxy_http_version 1.1;
	      proxy_set_header Connection "";
	      proxy_pass http://portainer/;
	  }
	  location /portainer/api/websocket/ {
	      proxy_set_header Upgrade $http_upgrade;
	      proxy_set_header Connection "upgrade";
	      proxy_http_version 1.1;
	      proxy_pass http://portainer/api/websocket/;
	  }
	}

替换ADDRESS:PORTPortainer服务器/容器的详细信息。

## 我如何配置我的反向代理服务Portainer使用HAProxy？ ##

这是一个工作配置HAProxy的以服务Portainer portainer.127.0.0.1.xip.io：

	global
	    maxconn                     10000
	    daemon
	    ssl-server-verify           none
	    tune.ssl.default-dh-param   2048
	
	defaults
	    mode    http
	    log     global
	    option  httplog
	    option  dontlognull
	    option  http-server-close
	    option  forwardfor          except 127.0.0.0/8
	    option  redispatch
	    retries 30
	    timeout http-request        300s
	    timeout queue               1m
	    timeout connect             10s
	    timeout client              1m
	    timeout server              1m
	    timeout http-keep-alive     10s
	    timeout check               10s
	    maxconn 10000
	
	userlist users
	    group all
	    group demo
	    group haproxy
	
	listen stats
	    bind            *:2100
	    mode            http
	    stats           enable
	    maxconn         10
	    timeout client  10s
	    timeout server  10s
	    timeout connect 10s
	    timeout         queue   10s
	    stats           hide-version
	    stats           refresh 30s
	    stats           show-node
	    stats           realm Haproxy\ Statistics
	    stats           uri  /
	    stats           admin if TRUE
	
	frontend www-http
	    bind    *:80
	    stats   enable
	    mode    http
	    option  http-keep-alive
	
	    acl portainer   hdr_end(host)   -i portainer.127.0.0.1.xip.io
	
	    use_backend     portainer       if portainer
	
	backend portainer
	    stats   enable
	    option  forwardfor
	    option  http-keep-alive
	    server  portainer    127.0.0.1:9000 check



**注意：必须为前端和后端都设置http-keep-alive**

## 容器视图中的公开端口将我重定向到0.0.0.0，我该怎么办？ ##

为了使Portainer能够将您重定向到您的Docker主机IP地址而不是0.0.0.0地址，您将不得不更改Docker守护程序的配置并添加该--ip选项。

查看Docker文档以获取更多详细信息。

请注意，您将不得不重新启动Docker守护程序，以使更改生效。

## 我重新启动Portainer并丢失了所有数据，为什么？ ##

Portainer数据存储在Docker容器中。如果您想在重新启动/升级后保留Portainer实例的数据，则需要保存数据。请参阅部署

## 我在登录时收到错误“您的会话已过期”，无法登录。怎么了？ ##

在容器中运行Portainer时，它将使用Docker引擎系统时间计算身份验证令牌到期时间。使用计算机/虚拟机休眠时，可能会在Docker系统中出现时间延迟。您需要确保您的Docker引擎系统时间与机器系统时间相同，如果没有，请重新启动Docker引擎。

检查Docker系统时间的简单方法是使用或者如果信息不可用。docker infodocker run busybox date

Docker for Windows用户也可以通过导航到超v管理 - >虚拟机 - >右键单击MobyLinuxVM - >设置 - >集成服务并启用服务列表中的时间同步复选框来修复此问题。

## 我如何在Windows上的2375端口上访问Docker API？ ##

在某些Windows安装程序中，Docker正在侦听本地环回地址，无法从Portainer容器中访问该地址。您可以使用netsh创建端口重定向，然后使用新创建的IP地址从Portainer连接。

创建一个重定向从端口2375上的环回地址到端口2375（DOS / Powershell命令）上新创建的地址10.0.75.1：

	> netsh interface portproxy add v4tov4 listenaddress=10.0.75.1 listenport=2375 connectaddress=127.0.0.1 connectport=2375

然后，您可以使用10.0.75.1:2375作为您的端点的URL。

## 我如何在代理后面使用Portainer？ ##

在代理服务器后面使用Portainer时，某些需要访问Internet的功能（例如应用程序模板）可能不可用。

当作为一个容器运行Portainer时，你可以指定HTTP_PROXY和HTTPS_PROXYenv var来指定应该使用哪个代理。

例：

	$ docker run -d -p 9000:9000 -e HTTP_PROXY=my.proxy.domain:7777 portainer/portainer

## 我如何升级我的Portainer版本？ ##

如果您将Portainer作为容器运行，那么这只是Docker镜像版本的问题。只需停止现有的Portainer容器，拉取最新的Portainer / Portainer图像，并创建一个新的Portainer容器（使用您用于创建前一个的相同选项）。

如果您在Swarm集群中将Portainer作为服务运行，则可以发出以下命令更新映像（假设您的Docker服务称为portainer）：

	$ docker service update --image portainer/portainer:latest portainer

## 如何使用Portainer管理远程Dokku主机？ ##

看看这个[要点](https://gist.github.com/woudsma/03c69260715327ee8453f73b121f416c)的说明。

## 我如何启用LDAP认证？ ##

看看[这篇文章](https://www.linkedin.com/pulse/teamgroup-management-docker-portainerio-neil-cresswell)的详细说明。