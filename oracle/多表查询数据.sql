--������


--��ѯԱ�����֣����ű�ţ���������
select * from dept;

select * from emp;

--oracle��ͳд��
select distinct d.deptno,d.dname,ename 
from dept d,emp e where d.DEPTNO = e.DEPTNO order by e.ename;

select * from dept d,emp e where d.DEPTNO = e.DEPTNO order by e.ename;

--sql ��׼д��natural join �Զ�����������ͬ��ͬ���͵ģ��Զ����е�
select ename,deptno,dname from emp natural join dept ;

-- ��׼д�� join using ʹ��ָ������������,�Զ����е�ʽ����
select * from emp join dept using(deptno)  ;

--׼д�� join ʹ��ָ������ָ���������������й���
select e.ename,e.deptno,d.dname from emp e join dept d on e.deptno=d.deptno

/*
1.�﷨���
2.������
3.��������Լ��
4.ͬ���ת��
5.Ȩ��
6.����ִ�мƻ�
7.ִ��

1 hash join
2 sort merge
3 nested loop
*/









