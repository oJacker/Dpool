--select *|[DISTINCT column|expression [alias],...] from table [where codition(s)]
--SELECT,from distinct --大写代表关键字
--|代表多选项--
--[]可选项 

--select ename ,empno,sal,comm ... from emp
--限制排数数据
--where
select * From emp where deptno=10;

--and 
select * from emp where deptno=10 and sal>2500;

--between and
select * from emp where sal between 2000 and 5000;

--IN

select * from emp where empno in(7780,7698,7566);

--like
--%代表0-N个字符
-- _代表一个字符

select * from emp 
where ename like '%E%';

--以字母E结束
select * from emp where ename like '%E';

--名字以四个字母组成
select * from emp where ename like '_____';

--名字以四个字母组成并第三位为N
select * from emp where ename like '___N_';

--null
select * from emp where comm is null ;

--升序
select * from emp order by empno asc;
--降序
select * from emp order by empno desc;

-- 按多个排序
select * from emp order by deptno asc,sal desc;





