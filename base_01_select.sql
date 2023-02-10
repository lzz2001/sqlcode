SELECT * FROM employees;

-- 引入外部sql文件
-- source 文件名
SELECT * FROM employees;

# 列的别名 alias (别名)
-- 1.AS 2.空格 3. ""(只能使用双引号ANSI)
SELECT employee_id AS id, last_name _name,salary "earn money"
FROM employees;

-- insert into 表名 VALUES('')     字符串是单引号

# 去除重复行
-- 查询一共有几个部门id
SELECT DISTINCT department_id
FROM employees;

# 空值参与运算

-- 空值: null
-- 	 不等同于 0 ''  'null'

-- 参与运算: 结果为 null
SELECT employee_id, salary "月工资",salary *(1+commission_pct) "年工资"
FROM employees;
-- ifnull 可以替换null
SELECT employee_id, salary "月工资",salary * (1 + IFNULL(commission_pct,0))* 12 "年工资"
FROM employees;


# 着重号 `` (1前面的符号),表名或者字段名与关键字重复，将其用着重号引用
SELECT * FROM `order`;


# 查询常数 
SELECT '尚硅谷',123,employee_id
FROM employees;

# 显示表结构
-- 显示表中相关详细信息
DESCRIBE employees;

DESC employees;

# 过滤数据 where

-- 查询九十号员工的部门信息
SELECT * 
FROM employees
WHERE department_id = 90;

-- mysql 不区分字符串大小写 ''

# 练习


# 1.查询员工12个月的工资总和，并起别名为ANNUAL SALARY

SELECT salary * 12 "ANNUAL SALARY"
FROM employees;

SELECT salary * (1 + IFNULL(commission_pct,0)) * 12 "ANNUAL SALARY"
FROM employees;

# 2.查询employees表中去除重复的job_id以后的数据

SELECT DISTINCT job_id 
FROM employees;

# 3.查询工资大于12000的员工姓名和工资

SELECT last_name ,salary
FROM employees
WHERE salary > 12000

# 4.查询员工号为176的员工的姓名和部门号

SELECT last_name, department_id
FROM employees
WHERE employee_id =176;

# 5.显示表 departments 的结构，并查询其中的全部数据

DESC departments;
DESCRIBE departments;

SELECT department_id, department_name, manager_id, location_id
FROM departments;


