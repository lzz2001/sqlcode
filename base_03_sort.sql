################### 排序 ##############
-- 默认顺序，先后添加的顺序
-- 使用order by 查询到的数据进行排序
-- 默认从低到高  升序ascend asc 降序descent desc

SELECT employee_id,last_name,salary
FROM employees
ORDER BY salary DESC;

-- 列的别名进行排序（只能在order by 中使用）
-- where 条件过滤不能过滤  别名
SELECT employee_id, salary * 12 annual_sal
FROM employees
ORDER BY annual_sal;

-- 逻辑上
-- from -> where -> select -> order by ->limit

-- 指定第二排序 -- 多级排序   
-- 第一次排序的关键字如果值相同才进入第二次排序
SELECT employee_id,salary,department_id
FROM employees
ORDER BY department_id DESC,salary ASC;






################### 分页 ##############

-- 为了查看方便，省流量

-- 每页显示20条，此时显示第一页
SELECT employee_id,last_name
FROM employees
LIMIT 0,20;

-- 显示第二页

SELECT employee_id,last_name
FROM employees
LIMIT 20,20;

-- 页数 页面记录条数
LIMIT (页数-1)*页面记录条数,页面记录条数;

-- 与where 	order by	limit 生命顺序

SELECT employee_id,last_name,salary
FROM employees
WHERE salary > 6000
ORDER BY salary DESC
LIMIT 0,10;

#表里有107条数据，只想显示第32，33条

SELECT *
FROM employees
LIMIT 31,2

# 8.0 的新特性

SELECT *
FROM employees
LIMIT 2 OFFSET 31;



################### 练习 ##############
#1. 查询员工的姓名和部门号和年薪，
	#按年薪降序,按姓名升序显示

SELECT last_name,department_id,salary*12*(1+IFNULL(commission_pct,0)) AS "annul salary"
FROM employees
ORDER BY "annul salary" DESC ,last_name ASC;


#2. 选择工资不在 8000 到 17000 的员工的姓名和工资，
	#按工资降序，显示第21到40位置的数据

SELECT last_name,salary
FROM employees
WHERE salary NOT BETWEEN 8000 AND 17000
ORDER BY salary DESC
LIMIT 20,20;

#3. 查询邮箱中包含 e 的员工信息，
	#并先按邮箱的字节数降序，
	#再按部门号升序
	
SELECT email,department_id
FROM employees
-- where email like '%e%'
WHERE email REGEXP '[e]'
ORDER BY LENGTH(email) DESC,department_id ASC;