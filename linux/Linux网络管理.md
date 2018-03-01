# Linux 网络管理

### 1：主机名的设置
	查看主机名： hostname

	临时设置主机名： hostname www.xxx.com

	永久设置主机名： vim /etc/sysconfig/network
	
### 2：查看网络

	查看网卡信息：ifconfig   或者 ip a

	临时设置IP: ifconfig eth0 192.168.100.100/24

	永久设置IP：
		1：setup配置 配合激活网卡命令  
			service network restart
		临时激活网卡：ifup eth0
		关闭：ifdown eth0
		2：修改网卡配置文件
		/etc/sysconfig/network-scripts/ifcfg-eth0

		DEVICE=eth0
		HWADDR=00:0c:29:1d:90:3e
		TYPE=Ethernet
		UUID=4eed0808-f94b-44c4-bfab-ec3dca805682
		ONBOOT=yes
		NM_CONTROLLED=yes
		BOOTPROTO=none
		IPADDR=192.168.0.7
		NETMASK=255.255.255.0
		DNS2=8.8.8.8
		GATEWAY=192.168.0.254
		DNS1=202.96.134.133
		IPV6INIT=no
		USERCTL=no
		
		重启网络服务  service network restart