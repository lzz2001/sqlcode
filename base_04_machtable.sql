################### 多表查询 #################################################################
DESC employees;
DESC departments;
DESC locations;

# 查询员工名为 Abel 的人 在哪个城市工作

SELECT department_id
FROM employees
WHERE last_name = 'Abel';

SELECT location_id
FROM departments
WHERE department_id = 80;

SELECT city
FROM locations
WHERE location_id = 2500;

-- 能不能做一张大表？
-- -- 能
-- 为什么不是用一张大表？
--    浪费存储空间，有大量的null数据，大量冗余数据
--    加载到内存费空间，io次数多浪费时间
--    多人工作时可以查询多张表

# 错误实现：每个员工与每个部门都匹配了一次
#省略连接条件 	交叉连接	（笛卡尔积）

-- select employee_id,departments,department_name
-- from employees,departments;

# 正确
SELECT employee_id,department_name
FROM employees,departments
WHERE employees.`department_id` = departments.`department_id`;

-- 重名的字段需要指明所属表
SELECT employee_id,department_name,employees.department_id
FROM employees,departments
WHERE employees.`department_id` = departments.`department_id`;

-- 多表查询时，【优化】最好每一个字段都指明所属表

-- 多使用 表的别名  和  字段别名 -> 简短打字
-- 表起了别名之后，select ， where中只能用别名
	--  否则报错******
SELECT employee_id,department_name,employees.department_id
FROM employees AS emp,departments AS dep
WHERE employees.`department_id` = departments.`department_id`;


# n个表连接是需要，至少n-1个连接条件
SELECT
FROM employees e,departments d,locations l
WHERE 

/*
演绎式：
1.提出问题
2.解决问题
。。。

归纳式： 总->分

*/

-- 多表查询的分类
-- 1.等值连接 和 非等值连接
-- 2.自连接   和 非自连接
-- 3.内连接   和 外连接

########## 等值连接和非等值连接  #############################################
DESC job_grades;
SELECT * 
FROM job_grades;

SELECT e.last_name,e.salary,j.`grade_level`
FROM employees e,job_grades j
WHERE e.`salary` BETWEEN j.`lowest_sal`AND j.`highest_sal`;

########### 自连接 ##############################################################
-- 查询员工姓名及其管理者的姓名
SELECT e1.`employee_id`,e1.`last_name`,e2.`employee_id`,e2.`last_name`
FROM employees e1,employees e2
WHERE e1.`manager_id`=e2.`employee_id`

########## 内连接 ###############################################################
-- 以上都是内连接
-- 把满足where条件的数据显示，不满足的不显示
--    -------------交集


########## 外连接 ###############################################################
-- 分类
-- 	1.左外连接    
--	2.右外连接
-- 	3.满外连接

-- 查询 所有(外连接) 员工的 last_name,department_name

-- sql92语法  sql-2
--      左外
SELECT e1.`employee_id`,e1.`last_name`,e2.`employee_id`,e2.`last_name`
FROM employees e1,employees e2
WHERE e1.`manager_id`=e2.`employee_id`

SELECT e.employee_id,d.department_name,e.department_id
FROM employees AS e,departments AS d    	-- 左表长，左外连接
WHERE e.`department_id` = d.`department_id`;	-- 短表，后加(+)
						-- mysql 不支持92




## sql99语法  sql-3 

# 使用 JOIN .. ON 的方式实现多表查询
SELECT e1.`employee_id`,e1.`last_name`,e2.`employee_id`,e2.`last_name`
FROM employees e1,employees e2
WHERE e1.`manager_id`=e2.`employee_id`

-- 内连接
SELECT e.last_name,d.department_name,l.city
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id

-- 外连接
-- 左外连接
SELECT last_name,department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id
-- 右外连接
SELECT last_name,department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id

-- 满外连接---mysql 不支持full
SELECT last_name,department_name
FROM employees e FULL OUTER JOIN departments d
ON e.department_id = d.department_id

-- union 联合 （会去重，效率降低）
-- union all 联合，，不去重 （能用union all 就不用union）

--  实现满外连接   


################################## 七种 join ##################################
-- 1.内连接，
-- 2.左外连接，
-- 3.右外连接，


-- 4.左外连接除去内连接部分 2-1
SELECT last_name,department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IS NULL

-- 5.右外连接除去内连接部分 3-1
SELECT last_name,department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IS NULL

-- 6.满外连接  2+5 3+4
SELECT last_name,department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id
UNION ALL
SELECT last_name,department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE last_name IS NULL


-- 7.满外除去内连接 4+5
SELECT last_name,department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IS NULL
UNION ALL
SELECT last_name,department_name
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE last_name IS NULL;


################# SQL99 语法新特性 ####################################################

-- 自然连接
SELECT employee_id,department_name
FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`
   AND e.`manager_id` = d.`manager_id`

SELECT employee_id,department_name
FROM employees e NATURAL JOIN departments d;


-- USING的使用

SELECT employee_id,department_name
FROM employees e,departments d
WHERE e.`department_id`=d.`department_id`

SELECT employee_id,department_name
FROM employees e JOIN departments d
USING department_id  #连接条件


############ 练习一    ##################################################################
# 1.显示 所有 员工的姓名，部门号和部门名称。
SELECT e.`last_name`,e.`department_id`,d.`department_name`
FROM employees e LEFT OUTER JOIN departments d
ON e.`department_id`=d.`department_id`


# 2.查询90号部门员工的job_id和90号部门的location_id

DESC locations;  #location_id
DESC employees;  #job_id department_id
DESC departments;#department_id location_id

SELECT e.job_id,d.`location_id`
FROM employees e LEFT JOIN departments d
ON e.`department_id`=d.`department_id`
WHERE e.department_id = 90


# 3.选择  所有(*)  有奖金的员工的 last_name , department_name , 
	# location_id , city
SELECT e.`last_name`,d.`department_name`,
	d.`location_id`,l.city
FROM employees e 
LEFT JOIN departments d
ON e.`department_id`=d.`department_id`
LEFT JOIN locations l
ON d.`location_id`=l.location_id
WHERE e.`commission_pct`IS NOT NULL	



# 4.选择city在Toronto工作的员工的 last_name , 
	# job_id , department_id , department_name

SELECT e.`last_name`,e.`job_id`,e.`department_id`,d.`department_name`
FROM employees e 
JOIN departments d
ON e.`department_id`=d.`department_id`
JOIN locations l
ON d.`location_id` = l.location_id	
WHERE l.city = 'Toronto'
	
# 5.查询员工所在的部门名称、部门地址、姓名、工作、工资，
#	其中员工所在部门的部门名称为’Executive’
DESC jobs;


SELECT e.`department_id`,l.`city`,l.`street_address`,e.`last_name`,e.`salary`,j.`job_title`
FROM employees e
RIGHT JOIN departments d
ON e.`department_id`=d.`department_id`
LEFT JOIN locations l
ON d.`location_id`=l.location_id
JOIN jobs j
ON e.`job_id` = j.job_id
WHERE d.`department_name`='Executive';

# 6.选择指定员工的姓名，员工号，
#   以及他的管理者的姓名和员工号，
	#结果类似于下面的格式
	#		employees Emp   # manager Mgr#
	#		kochhar 101       king 100

SELECT e1.`last_name`AS employees,e1.`employee_id`AS Emp,
	e2.`last_name`AS manager,e2.`employee_id`AS Mgr
FROM employees e1
LEFT JOIN employees e2
ON e1.`manager_id`=e2.`employee_id`
WHERE e1.`last_name`='kochhar'

	
# 7.查询哪些部门没有员工
SELECT d.department_name
FROM employees e 
RIGHT JOIN departments d
ON e.department_id = d.department_id
WHERE last_name IS NULL

# 8. 查询哪个城市没有部门
SELECT l.city
FROM departments d
RIGHT JOIN locations l
ON d.location_id=l.location_id
WHERE d.department_id IS NULL


# 9. 查询部门名为 Sales 或 IT 的员工信息
DESC employees;
SELECT e.employee_id,e.`first_name`,e.`last_name`,e.`email`,
	e.`phone_number`,e.`hire_date`,e.`job_id`,e.`salary`,
	e.`commission_pct`,e.`manager_id`,e.`department_id`
FROM employees e
JOIN departments d
ON e.`department_id`=d.`department_id`
WHERE d.`department_name` IN ('Sales','IT');






################## 练习二     ############################################################################
#1.所有有门派的人员信息
（ A、B两表共有）


#2.列出所有用户，并显示其机构信息
（A的全集）


#3.列出所有门派
（B的全集）


#4.所有不入门派的人员
（A的独有）


#5.所有没人入的门派
（B的独有）



#6.列出所有人员和机构的对照关系
(AB全有)


#MySQL Full Join的实现 因为MySQL不支持FULL JOIN,下面是替代方法
#left join + union(可去除重复数据)+ right join


#7.列出所有没入派的人员和没人入的门派
（A的独有+B的独有）