--select *|[DISTINCT column|expression [alias],...] from table [where codition(s)]
--SELECT,from distinct --��д����ؼ���
--|�����ѡ��--
--[]��ѡ�� 

--select ename ,empno,sal,comm ... from emp
--������������
--where
select * From emp where deptno=10;

--and 
select * from emp where deptno=10 and sal>2500;

--between and
select * from emp where sal between 2000 and 5000;

--IN

select * from emp where empno in(7780,7698,7566);

--like
--%����0-N���ַ�
-- _����һ���ַ�

select * from emp 
where ename like '%E%';

--����ĸE����
select * from emp where ename like '%E';

--�������ĸ���ĸ���
select * from emp where ename like '_____';

--�������ĸ���ĸ��ɲ�����λΪN
select * from emp where ename like '___N_';

--null
select * from emp where comm is null ;

--����
select * from emp order by empno asc;
--����
select * from emp order by empno desc;

-- ���������
select * from emp order by deptno asc,sal desc;





