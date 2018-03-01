# Linux 用户，组操作命令

### 1:用户的基本操作
	创建用户	useradd [参数] 用户名
	查看用户	id 用户名     cat  /etc/passwd
	删除用户	userdel -r 用户名
	修改用户	usermod [参数]  用户名
	切换用户 su - 用户名 
	
### 2:组基本操作

	创建组   groupadd 组名
	删除组	groudel 组名
	添加附属组成员	gpasswd -a 用户名  组名