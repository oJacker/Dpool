# Oracle体系

硬件：服务器pc server IBM小型机 PC客户端
存储(存储数据文件) 交换机等等
软件：oracle数据库软件ASM/集群服务需要安装GRID
如果需要数据库需要安装DATABASE

数据库dbca创建生产的
数据库=实例+数据文件
实例=内存+进程


CLIENT---[通过网络,network]----监听----SERVER[software]--->  存储[datafiles]


SGA[共享池【执行sql关键区域】,数据缓冲区,日志缓冲区,流池,大型池,java池]-----> PGA 
进程[dbwn,lgwr,ckpt,pmon,smon]
[控制文件，日志文件，数据文件，参数文件，归档文件]
