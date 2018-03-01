# Linux 中软件包的安装

### 1： rpm 软件包管理命令
	1:光盘镜像中有很多软件可以使用 挂载光盘，查看软件包
		1:mkdir /mnt/rhel
		2:mount /dev/cdrom /mnt/rhel/

	2:从软件的官方获取， .rpm
		安装rpm包
			rpm -ivh 软件包名称
		删除rmp包  rpm  -e  tigervnc
		查看rpm包的安装信息  rpm -ql 软件包
		查看某一个文件来源包  
			rpm -qf 地址  |  rpm -qf /bin/ls

### 2: yum 管理软命令

	本地yum源
		cd /etc/yum.repos.d/
		编辑/etc/yum.repos.d/***.repo文件
		[repo_id]
		name = repo_name
		enabled=1
		qpgcheck=0
		baseurl=file:///mnt/rhel

	yum repolist
	配置yum源   
	使用yum安装软件 yum intall 软件名称
	使用yum删除软件	yum remove  软件名称
	查看yum列表  	yum list 
	使用yum搜索软件  yum  search