一、准工作：
使用工具：
1：docker版本：18.04.0-ce
2：centos的官方docker镜像作为基础镜像
3：nginx-

二、制作容器
1:启动一个centos容器作为基础镜像
docker pull centos:6.7
[root@localhost ~]# docker run -it --name nginx centos:6.7 bash
2:在centos:6.7容器中，安装需要编译的命令wget并更新国内源
[root@ece827c05ff8 /]# yum install -y wget gcc gcc-c++ make openssl-devel
