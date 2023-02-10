################### 聚合函数 ###########
-- 常见的聚合函数
-- 还有方差，标准差，中位数
SELECT AVG(salary),SUM(salary),MAX(salary),
# 平均值，求和，最大值，
	MIN(salary),COUNT(commission_pct)
#最小值，计数
FROM employees;

# max,min 适用于数值类型，字符串类型，
	# 时间类型，
	
# count 计算指定字段中出现的个数,除去null
SELECT COUNT(last_name),COUNT(commission_pct),COUNT(first_name),
	COUNT(manager_id)
FROM employees;
#查看有多少条记录【count（1），count（*）】
SELECT SUM(salary)/COUNT(1),AVG(salary)
FROM employees;

SELECT SUM(commission_pct)/COUNT(commission_pct),AVG(commission_pct),
	SUM(commission_pct)/107
-- sum,avg 不考虑null值
FROM employees;

# 查询平均avg有空值时，是错误的
# 应该使用 sum()/count(1)

# 如果统计个数，那个效率最高？count()
myisam存储引擎 三个方法一样时间
innodb存储引擎三者效率不一样 COUNT(*)=COUNT(1)>COUNT(字段)

-- -----------------------------------------------------------------------------------------------------------


-- 分组 group by
-- 查询各部门的平均工资
SELECT department_id,AVG(salary),SUM(salary)
FROM employees
GROUP BY department_id

-- 查询各job_id 的平均工资

-- 使用多个列进行分组
-- 查询各department_id,job_id的平均工资
SELECT department_id,AVG(salary),SUM(salary)
FROM employees
GROUP BY department_id,job_id;
或者---一样的
SELECT department_id,AVG(salary),SUM(salary)
FROM employees
GROUP BY job_id,department_id

-- --------------------------select ..
-- --------------------------from ..
-- --------------------------where ..（不能有分组函数）
-- --------------------------group by .. having ..
-- --------------------------order by ..
-- --------------------------limit ..

-- 结论：查询的原生字段 一定要出现在分组字段中
-- 新特性：MySQL     group by中使用with rollup 
SELECT department_id,AVG(salary)
FROM employees
GROUP BY department_id

SELECT department_id,AVG(salary)
FROM employees
GROUP BY department_id WITH ROLLUP
-- 之后不能加排序






-- --------------------------------------------------------------------------------------------------
-- HAVING
-- 作用 ： 过滤数据，分组之后的过滤
	-- 过滤条件中有聚合函数，只能使用having过滤
	-- 没有分组也能使用having，但意义不大
	
各个部门中最高工资比10000高的部门信息

SELECT department_id,MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary)>10000

查询部门 id 为10，20，30，40，
这4个部门中最高工资比10000高的部门信息
-- 执行效率高
SELECT department_id,MAX(salary)
FROM employees
WHERE department_id IN (10,20,30,40)
GROUP BY department_id
HAVING MAX(salary)>10000
或者
-- 执行效率低
SELECT department_id,MAX(salary)
FROM employees
GROUP BY department_id
HAVING department_id IN (10,20,30,40)
	AND MAX(salary)>10000

当过滤条件中有聚合函数时，则过滤条件必须写在having后
当过滤条件没有聚合函数时，则where更快，having中效率低

where与 having对比
1.having适用范围更广
2.如果过滤条件没有分组函数，where过滤效率更快
  where先过滤后聚合，having先分组聚合再过滤


-- -------------------------------------------------------------------------------------------------------------
-- SQL底层执行原理	
SQL92 
SELECT ... , ... , ... (存在聚合)
FROM ... , ... , ...
WHERE 多表连接条件 AND 不包含聚合函数的过滤条件
GROUP BY ... , ...
HAVING 包含分组函数的过滤条件
ORDER BY ... , ... (DESC/ASC)
LIMIT ...

SQL99
SELECT ... , ... , ... (存在聚合)
FROM ... 
(LEFT/RIGHT) JOIN ... ON ...
WHERE 不包含聚合函数的过滤条件
GROUP BY ... , ...
HAVING 包含分组函数的过滤条件
ORDER BY ... , ... (DESC/ASC)
LIMIT ...

执行顺序 
每一个过程都会生成一张虚拟表
FROM -> ON -> (LEFT/RIGHT) JOIN -> WHERE -> GROUP BY -> HAVING
-> SELECT -> DISTINCT -> ORDER BY -> LIMIT

-- ----------------------------练习--------------------------------------------------------------------------------------
# 1.where子句可否使用组函数进行过滤?
不可以，因为执行where语句是还没有进行数据分组，
只有经过groupby分组之后才可以使用分组函数作为过滤条件，
之后是having过滤，条件可以使用分组函数

# 2.查询公司员工工资的最大值，最小值，平均值，总和

SELECT MAX(salary),MIN(salary),AVG(salary),SUM(salary)
FROM employees;

# 3.查询各job_id的员工工资的最大值，最小值，平均值，总和

SELECT job_id,MAX(salary),MIN(salary),AVG(salary),SUM(salary)
FROM employees
GROUP BY job_id

# 4.选择具有各个job_id的员工人数

SELECT job_id,COUNT(*)
FROM employees
GROUP BY job_id

# 5.查询员工最高工资和最低工资的差距（DIFFERENCE）

SELECT MAX(salary)-MIN(salary) AS difference
FROM employees;

# 6.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，
	# 没有管理者的员工不计算在内
	
SELECT MIN(salary) AS salary_min
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING 	MIN(salary) >= 6000
ORDER BY MIN(salary)
LIMIT 15

# 7.查询所有部门的名字，location_id，员工数量和平均工资，并按平均工资降序
-- count 使用具体字段
SELECT d.department_name,d.location_id,COUNT(e.employee_id) AS emp_number,
		TRUNCATE(IFNULL(SUM(e.salary)/COUNT(1),0),0) AS avg_sal
FROM employees e 
-- right join departments d on e.department_id = d.department_id
RIGHT JOIN departments d USING(department_id)
GROUP BY department_name
ORDER BY avg_sal



# 8.查询每个工种、每个部门的部门名、工种名和最低工资

SELECT e.job_id,d.department_name,j.job_title,MIN(e.salary)
FROM employees e 
RIGHT JOIN jobs j USING(job_id)
RIGHT JOIN departments d USING(department_id)
GROUP BY job_title,department_name

