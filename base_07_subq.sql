################ 子查询 #######################################################
-- 4.1就有了


-- 工资比abel高的员工
-- 1.
SELECT salary
FROM employees
WHERE last_name = 'Abel'

SELECT last_name
FROM employees
WHERE salary>11000

-- 2.自连接
SELECT e2.last_name
FROM employees e1 
JOIN employees e2 ON e1.salary<e2.salary
WHERE e1.last_name= 'Abel'

-- 3.子查询

SELECT last_name
FROM employees
WHERE salary>(
	SELECT salary
	FROM employees
	WHERE last_name='Abel')

-- 规范语言：外查询（主查询），内查询（子查询）
子查询在主查询之前完成，结果被主查询使用
写在括号内，一般在右侧，单行操作符对应单行子查询
多行操作符对应多行子查询

# 分类：
  #返回结果个数
	# 单行子查询 
	--  结果是一个
	# 多行子查询
	--  结果是多个
	
  #内查询是否被执行多次
	# 相关子查询
	-- 查询工资大于本部门平均工资
	-- 人变基准变
	# 不相关子查询
	-- 人变基准不变
	
# -- 从里往外写，从外往里写

# 查询工资大于149号员工工资的员工的信息

SELECT last_name
FROM employees
WHERE salary > (
	SELECT salary
	FROM employees
	WHERE employee_id = 149)

# 返回job_id与141号员工相同，
	# salary比143号员工多的员工姓名，
	# job_id和工资

SELECT last_name,job_id,salary
FROM employees
WHERE job_id=(
	SELECT job_id
	FROM employees
	WHERE employee_id = 141)
  AND salary>(
	SELECT salary
	FROM employees
	WHERE employee_id = 143)

# 返回公司工资最少的员工的last_name,job_id和salary


SELECT last_name,job_id,salary
FROM employees
WHERE salary = (SELECT MIN(salary)
		FROM employees)


# 查询与141号或174号员工的manager_id和
	# department_id相同的其他员工的employee_id，
	# manager_id，department_id
-- 方法1
SELECT employee_id,manager_id,department_id
FROM employees
WHERE manager_id IN (
		SELECT manager_id
		FROM employees
		WHERE employee_id IN (141,174))
  AND department_id IN (
		SELECT department_id
		FROM employees
		WHERE employee_id IN(141,174)
		)
  AND employee_id NOT IN (141,143)

-- 方法二

SELECT employee_id,manager_id,department_id
FROM employees
WHERE (manager_id,department_id) IN (
		SELECT manager_id,department_id
		FROM employees
		WHERE employee_id IN (141,174))
  AND employee_id NOT IN (141,143)



# 查询最低工资大于50号部门最低工资的部门id
	# 和其最低工资

SELECT department_id,MIN(salary)
FROM employees
# where department_id is not null
GROUP BY department_id
HAVING MIN(salary)>(
		SELECT MIN(salary)
		FROM employees
		WHERE department_id = 50
		GROUP BY department_id)




# 查找员工的employee_id,last_name和location_id。
# 其中，若员工department_id与
# location_id为1800的department_id相同，
# 则location为’Canada’，其余则为’USA’。

SELECT employee_id,last_name,CASE department_id WHEN 
		(
		SELECT department_id
		FROM departments
		WHERE location_id = 1800) THEN 'Canada'
		ELSE 'USA' END AS location
FROM employees 
/*
join departments using(department_id)
where department_id =(
		select department_id
		from departments
		where location_id = 1800)
*/

子查询返回结果过为空值时，主查询不报错但没结果


######################### 多行子查询 ################################################
# in any(some) all

#返回其它job_id中比job_id为‘IT_PROG’部门任一工资低
#的员工的员工号、姓名、job_id 以及salary
SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id <>'IT_PROG'
 AND salary <  ANY (SELECT (salary)
		FROM employees 
		WHERE job_id = 'IT_PROG'
		GROUP BY job_id
		)

#返回其它job_id中比job_id为‘IT_PROG’部门所有工资都低
#的员工的员工号、姓名、job_id以及salary

SELECT employee_id,last_name,job_id,salary
FROM employees
WHERE job_id <>'IT_PROG'
 AND salary <  ALL (SELECT (salary)
		FROM employees 
		WHERE job_id = 'IT_PROG'
		GROUP BY job_id
		)


#查询平均工资最低的部门id
SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY AVG(salary)
LIMIT 1

SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary)<= ALL(
			SELECT AVG(salary)AS avg_sal
			FROM employees
			GROUP BY department_id)


SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) IN (SELECT MIN(a1)
			FROM(
			SELECT AVG(salary) a1
			FROM employees
			GROUP BY department_id )AS a) 
-- 字段别名，表别名的使用


-- 多行子查询空值 
-- 子查询返回结果有空值，主查询不报错，但不返回数据

###################### 相关子查询 ######################################################################


# 查询员工中工资大于本部门平均工资的员工的
# last_name,salary和其department_id
-- 1.相关子查询
SELECT last_name,salary,department_id
FROM employees e1
WHERE salary >  (
		SELECT AVG(salary)
		FROM employees e2
		WHERE e2.`department_id`=e1.department_id)


-- 2.from中子查询
SELECT e1.last_name,e1.salary,e1.department_id
FROM employees e1 
JOIN (SELECT department_id d_id,AVG(salary) avg_sal
			FROM employees
			GROUP BY department_id)AS d_s
ON d_S.d_id = e1.department_id
WHERE salary>avg_sal


# 查询员工的id,salary,按照department_name 排序
SELECT employee_id,salary,d.department_name
FROM employees e1 LEFT JOIN departments d
ON e1.department_id = d.department_id
ORDER BY department_name

SELECT employee_id,salary
FROM employees e1
ORDER BY (SELECT department_name
	FROM departments d
	WHERE d.department_id=e1.department_id)


-- 结论 ：子查询不可以出现在 groupby limit
		 



# 若employees表中employee_id与job_history表中
# employee_id相同的数目不小于2，输出这些相同
# id的员工的employee_id,last_name和其job_id
SELECT e.employee_id,e.last_name,e.job_id
FROM employees e
WHERE e.employee_id IN (
			SELECT employee_id
			FROM job_history
			GROUP BY employee_id
			HAVING COUNT(employee_id) >= 2)


SELECT e.employee_id,e.last_name,e.job_id
FROM employees e
WHERE 2<= (
	SELECT COUNT(1)
	FROM job_history j
	WHERE e.employee_id = j.`employee_id`
	)

--  相关子查询关键字 exists / notexists

# 查询公司管理者的employee_id，last_name，
	# job_id，department_id信息

SELECT DISTINCT e2.employee_id,e2.last_name,
		e2.job_id,e2.department_id
FROM employees e1,employees e2
WHERE e1.manager_id = e2.employee_id

SELECT employee_id,last_name,job_id,department_id
FROM employees
WHERE employee_id IN(SELECT DISTINCT manager_id
			FROM employees)

SELECT employee_id,last_name,job_id,department_id
FROM employees e1
WHERE EXISTS( SELECT * FROM employees e2 
		-- * 可以是任何字段
		WHERE e1.employee_id = e2.`manager_id`)


# 查询departments表中，不存在于employees表
	# 中的部门的department_id和department_name
SELECT department_id,department_name
FROM departments d1
WHERE NOT EXISTS(
		SELECT * FROM employees e
		WHERE d1.department_id = e.`department_id`
		)
		
# 相关更新
# 相关删除

# 自连接效率更高，但是大部分 数据库管理系统都做了相应的优化
# 将可以该为自连接的子查询，都改为自连接

################### 练习 ##################################################################

#1.查询和Zlotkey相同部门的员工姓名和工资

-- 避免有重名 使用in 
SELECT last_name,salary
FROM employees
WHERE department_id IN (
			SELECT department_id
			FROM employees
			WHERE last_name = 'Zlotkey')

#2.查询工资比公司平均工资高的员工的员工号，姓名和工资。

-- 
SELECT employee_id,last_name,salary
FROM employees
WHERE salary > (
		SELECT AVG(salary)
		FROM employees)

#3.选择工资大于所有JOB_ID = 'SA_MAN'的员工的工资的员工的 
	# last_name,job_id, salary

SELECT 	last_name,job_id, salary
FROM employees
WHERE salary > ALL (
		    SELECT salary
		    FROM employees
		    WHERE job_id ='SA_MAN')

#4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名

-- 查询出来的 部门id可以去重
SELECT employee_id,last_name
FROM employees
WHERE department_id IN (
			SELECT DISTINCT department_id
			FROM employees
			WHERE last_name LIKE '%u%')

#5.查询在部门的location_id为1700的部门工作的员工的员工号

SELECT employee_id
FROM employees
WHERE department_id IN (SELECT department_id
			FROM departments
			WHERE location_id = 1700)


#6.查询管理者是King的员工姓名和工资

SELECT last_name,salary,manager_id
FROM employees
WHERE manager_id IN (SELECT  employee_id
		    FROM employees
		    WHERE last_name = 'King')

#7.查询工资最低的员工信息: last_name, salary

SELECT last_name, salary
FROM employees
ORDER BY salary
LIMIT 1

SELECT last_name, salary
FROM employees
WHERE  salary = (SELECT MIN(salary)
		FROM employees)

#8.查询平均工资最低的部门信息

-- 部门信息
SELECT * FROM departments
WHERE department_id =(SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary)<=ALL(SELECT AVG(salary)
						FROM employees
						GROUP BY department_id)
						)

#9.查询平均工资最低的部门信息和该部门的平均工资（相关子查询）
SELECT * ,(SELECT AVG(salary) 
	   FROM employees e 
	   WHERE e.department_id = d.department_id)
FROM departments d
WHERE department_id =(SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary)<=ALL(SELECT AVG(salary)
						FROM employees
						GROUP BY department_id)
						)
						
						
SELECT d.*,(SELECT AVG(salary) 
	   FROM employees e 
	   WHERE e.department_id = d.department_id) avg_sal
FROM departments d JOIN (SELECT department_id,AVG(salary) avg_sal
			 FROM employees
			 GROUP BY department_id
			 ORDER BY avg_sal
			 LIMIT 1
			) t1 
		   ON d.department_id=t1.department_id

		      
SELECT department_id,AVG(salary) avg_sal
FROM employees
GROUP BY department_id
HAVING	avg_sal <= ALL(
			SELECT AVG(salary)
			FROM employees
			GROUP BY department_id)

#10.查询平均工资最高的 job 信息
SELECT *
FROM jobs
WHERE job_id = (
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary)>=ALL(
					SELECT AVG(salary)
					FROM employees
					GROUP BY job_id)
		)
-- 2.
SELECT *
FROM jobs
WHERE job_id = (
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary)=(SELECT MAX(avg_sal) FROM(  
				    SELECT AVG(salary) avg_sal
				    FROM employees
				    GROUP BY job_id) t1) 
		)

#11.查询平均工资高于公司平均工资的部门有哪些?

SELECT AVG(salary) avg_sal,department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING avg_sal > (SELECT AVG(salary) FROM employees)


#12.查询出公司中所有 manager 的详细信息

SELECT * FROM employees
WHERE employee_id IN (SELECT DISTINCT manager_id
			FROM employees)

-- 相关

SELECT * 
FROM employees e
WHERE  EXISTS (   SELECT 1
		  FROM employees e1
		  WHERE e1.manager_id = e.employee_id
		)
			
			
#13.各个部门中 最高工资中最低的那个部门的 最低工资是多少?
-- （4种方法）
SELECT MIN(salary)
FROM employees e1,(SELECT MAX(salary) max_sal,e2.department_id e2_d
		FROM employees e2
		GROUP BY department_id
		ORDER BY max_sal
		LIMIT 1
		) e
WHERE e1.department_id = e.e2_d


#14.查询平均工资最高的部门的 manager 的详细信息:
#	 last_name, department_id, email, salary
-- ----------------有问题
SELECT DISTINCT e.last_name,e.department_id,e.email,e.salary
FROM employees e,(SELECT manager_id FROM employees) t1
WHERE e.employee_id = t1.manager_id
AND e.department_id = (SELECT department_id
			FROM employees
			GROUP BY department_id
			ORDER BY AVG(salary) DESC
			LIMIT 1
			)

SELECT *
FROM employees
WHERE department_id=90

#15. 查询部门的部门号，其中不包括job_id是"SH_CLERK"的部门号
-- -----------------------有问题
SELECT DISTINCT department_id
FROM employees e1
WHERE NOT EXISTS (  SELECT 1
		  FROM employees e2
		  WHERE e2.job_id = 'ST_CLERK'
		  AND e2.department_id=e1.department_id
			)
AND department_id IS NOT NULL

#16. 选择所有没有管理者的员工的last_name

SELECT last_name
FROM employees
WHERE manager_id IS NULL

SELECT last_name
FROM employees e1
WHERE NOT EXISTS(   SELECT 1
		FROM employees e2
		WHERE e1.manager_id = e2.employee_id
		)

#17．查询员工号、姓名、雇用时间、工资，其中员工的管理者为 'De Haan'

SELECT employee_id,last_name,hire_date,salary
FROM employees
WHERE manager_id IN (
		     SELECT employee_id
		     FROM employees
		     WHERE last_name = 'De Haan')

#18.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资（相关子查询）

SELECT employee_id,salary,last_name,department_id
FROM employees e1
WHERE salary > (SELECT AVG(salary)
		FROM employees e2
		WHERE e1.department_id=e2.department_id
		)

#19.查询每个部门下的部门人数大于 5 的部门名称（相关子查询）

SELECT department_name
FROM departments d
WHERE EXISTS (  SELECT e1.department_id
		FROM employees e1
		GROUP BY e1.department_id
		HAVING COUNT(*)>5
		AND e1.department_id=d.department_id
		)

#20.查询每个国家下的部门个数大于 2 的国家编号（相关子查询）

SELECT l1.country_id
FROM locations l1
WHERE 2 <(SELECT COUNT(*)
 	  FROM departments d
 	  WHERE l1.location_id=d.location_id)


SELECT country_id
FROM departments d,locations l
WHERE d.location_id = l.location_id
GROUP BY l.country_id
HAVING COUNT(1)>2



IN 通常可以改为 EXISTS
NOT IN 通常可以改为 NOT EXISTS