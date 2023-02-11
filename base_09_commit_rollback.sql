-- ----------DCL
# TCL 事务管理控制语言

# commit : 提交数据 
#	一旦commit 数据永久保留在数据库中
#	意味着不能回滚

# rollback：回滚数据，执行时，
#	可以实现数据回滚，
#	回滚到最近一次commit

对比 TRUNCATE TABLE 和 DELETE FROM 
相同点：都可以实现对表中所有数据的删除
	不删除表结构
	
不同点： TRUNCATE TABLE(DDL) 执行后不支持回滚

	 DELETE FROM(DML) 可以清除部分数据
		可有选择性的清除数据
		并且执行后，可以回滚

DDL ：操作一旦执行，不可以回滚（执行完后自动commit）

DML ： 默认情况下一旦执行不能回滚，
	但执行DML前，执行了 SET autocommit= flase
				(不自动提交)
	则执行的DML可以实现回滚

实现 
USE atguigudb;
CREATE TABLE myemp
AS
SELECT employee_id,salary
FROM employees

COMMIT;

delete实现

SET autocommit = FALSE;

SELECT * FROM myemp;

DELETE FROM myemp;

ROLLBACK;

TRUNCATE TABLE myemp;

DROP TABLE myemp




