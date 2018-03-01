# Linux 权限管理

### 1.ugo 权限管理

	查看UGO权限，使用：
	ll 或者 ls -l
	d	     rwx			r-x		    r-x 	    2     root     root        4096       Jul 14 23:14           test
	文件类型: u=user 	   g=group   o=other   硬连接数    属主     属组         大小        修改时间               文件名
	d 目录
	- 普通文件
	p pipe
	s socket
	l link
	c char
	b block

	r=read
	w=write
	x=exe
	-=没有对应的权限

	对普通文件
	r=可读
	w=可修改并保持
	x=可以执行

	对目录文件：
	r-x=访问目录
	w=可以在目录中增加或者删除文件
	rwx 0-7
	r=4
	w=2
	x=1
	rwx     r-x   r-x
	7        5     5
	八进制表示：755
	字符表示方法：rwxr-xr-x
	
	rwx r-x r-x
	u    g   o
	修改权限  chmod o+w test
### 2.suid.sgid.sticky权限
	SUID的使用： 设置给命令文件
	设置SUID
	chmod u+s 文件路径
	chmod u-s  文件路径

	如果设置了SUID，当其他用户调用该命令的时候，用户的有效ID为命令文件的属主ID
	当未设置SUID时，euid=uid，egid=gid
	oracle 用户执行passwd命令 修改/etc/passwd
	uid  gid  euid egid
	501  501   0      0

	euid=uid
	egid=gid
	内核通过判断euid，egid来判定命令堆资源的访问权限

	SGID 使用：（一般情况下都是设置给目录使用）
	设置SGID
	chmod g+s 文件路径
	chmod g-s 文件路径
	父目录跟随

	STICKY 粘带位
	
	设置方法：
	chmod  o+t 文件路径
	chmod  o-t  文件路径
	防止普通用户的文件被其他用户删除或者移动