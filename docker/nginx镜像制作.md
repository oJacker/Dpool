һ��׼������
ʹ�ù��ߣ�
1��docker�汾��18.04.0-ce
2��centos�Ĺٷ�docker������Ϊ��������
3��nginx-

������������
1:����һ��centos������Ϊ��������
docker pull centos:6.7
[root@localhost ~]# docker run -it --name nginx centos:6.7 bash
2:��centos:6.7�����У���װ��Ҫ���������wget�����¹���Դ
[root@ece827c05ff8 /]# yum install -y wget gcc gcc-c++ make openssl-devel
