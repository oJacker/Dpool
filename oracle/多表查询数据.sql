--表连接


--查询员工名字，部门编号，部门名称
select * from dept;

select * from emp;

--oracle传统写法
select distinct d.deptno,d.dname,ename 
from dept d,emp e where d.DEPTNO = e.DEPTNO order by e.ename;

select * from dept d,emp e where d.DEPTNO = e.DEPTNO order by e.ename;

--sql 标准写法natural join 自动查找两个中同名同类型的，自动进行等
select ename,deptno,dname from emp natural join dept ;

-- 标准写法 join using 使用指定的列做连接,自动进行等式关联
select * from emp join dept using(deptno)  ;

--准写法 join 使用指定的列指定的连接条件进行关联
select e.ename,e.deptno,d.dname from emp e join dept d on e.deptno=d.deptno

/*
1.语法检查
2.语义检查
3.对象存在性检查
4.同义词转换
5.权限
6.生成执行计划
7.执行

1 hash join
2 sort merge
3 nested loop
*/









