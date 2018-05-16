## 外部端点 ##

外部端点定义以JSON编写。

它必须由一个数组组成，每个端点定义由一个元素组成。

	[
	  {
	    "Name": "my-first-endpoint",
	    "URL": "tcp://myendpoint.mydomain:2375"
	  },
	  {
	    "Name": "my-second-endpoint",
	    "URL": "tcp://mysecondendpoint.mydomain:2375",
	    "TLS": true,
	    "TLSSkipVerify": true,
	    "TLSCACert": "/tmp/ca.pem",
	    "TLSCert": "/tmp/cert.pem",
	    "TLSKey": "/tmp/key.pem"
	  }
	]


### 端点定义格式 ###

端点元素必须是有效的JSON对象。

例：

	{
	  "Name": "my-secure-endpoint",
	  "URL": "tcp://myendpoint.mydomain:2375",
	  "TLS": true,
	  "TLSCACert": "/tmp/ca.pem",
	  "TLSCert": "/tmp/cert.pem",
	  "TLSKey": "/tmp/key.pem"
	}


它由多个领域组成，一些强制性的和一些选择权。

**Name**

端点的名称。用于在同步请求期间检查数据库中是否已存在端点。它也将显示在UI中。该字段是强制性的。

**URL**

协议必须指定，目前仅支持tcp://和unix://支持。任何不使用这两种协议之一的定义都将被跳过。该字段是强制性的。

**TLS**

如果您需要使用TLS连接到端点，请将此字段指定为true。默认为false。将真值应用于此字段时，Portainer会期望也定义TLSCACertPath，TLSCertPath和TLSKeyPath字段。该字段是可选的。

**TLSSkipVerify**

如果您想跳过服务器验证，请将此字段指定为true。默认为false。该字段是可选的。

**TLSCACert**

用于连接到端点的CA的路径。该字段是可选的。

**TLSCert**

用于连接到端点的证书路径。该字段是可选的。

**TLSKey**

用于连接到端点的密钥路径。该字段是可选的。

## 端点同步 ##


当使用该**--external-endpoints**标志时，Portainer将在启动时读取指定的JSON文件并自动创建端点。

然后Portainer会根据**--sync-interval**（每个60s默认值）中定义的时间间隔读取文件，并自动执行以下操作：

- 对于数据库中的每个端点，它将自动合并文件中的任何配置查找，并使用enpoint名称作为比较关键字
- 如果端点存在于数据库中但不在文件中，它将从数据库中删除
- 如果一个端点存在于文件中但不存在于数据库中，它将在数据库中创建


当使用外部端点管理时，端点管理将通过UI被禁用，以避免任何可能的配置覆盖（端点视图仍然可以访问，但只显示端点列表而不提供创建/更新端点的可能性）。一个简单的警告消息将显示在端点视图中。