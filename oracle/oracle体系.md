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


## oracle体系结构实例管理-内存管理
	oracle 实例结构 ：
		三大内存池（shared pool/buffer cache/log buffer）
		五大后天进程（pmon/smon/dbwr/lgwr/ckpt）

	

### 1：了解什么是硬件析和软件析

	shared pool：用来存放共享的sql和pl/sql，数据库metadata主要作用是在session间对cache的游标进行共享

	当客户端进场，将sql语句通过监听器发送到oracle时，会触发一个server process生成，来对该客户进场服务。Server process 得到sql语句之后，对sql语句进行计划拿来执行，最后将执行结果返回该客户端，这种sql解析叫软解析，如果不存在，则会对该sql进行解析parse，然后执行，返回结果，这种sql解析叫硬解析；
	
	硬解析的步骤：
	1）对sql语句进行语法检查，看是否有语法错误；
	2）通过数据字典（row cache），检查sql语句中设计的对象和列是否存在。
	3）检查sql语句的用户是否对涉及的对象是否有权限。
	4）通过优化器创建一个最优的执行计划，这个过程会更加数据字典的对象统计信息，来计算多个执行计划的cost，从而得到一个最优的执行计划，这一步涉及到大量的数据运算，从而会消耗大量的CPU资源：（library cache 最主要的目的就是通过软解析来减少这个步骤）
	5）将该游标生产的执行计划，sql文本缓存到libray cache中的heap中
		
	软解析：所谓软解析，就是因为相同文本的sql语句存在于library cache中，所以本次sql语句的解析就可以去掉硬解析中的一个或多个步骤，从而节省大量的资源的消耗。

