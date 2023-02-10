# 运算符
-- + - * / DIV % MOD 

SELECT 5.0+1
# 算术运算符 ###########################################
-- 字符串加整形,将字符串转化为数值
-- 若字符串为字母 abc 则看作为0 
-- null 参与运算结果为null
-- 分母为 0 时 结果为null
-- ÷ 不是整除
-- 余数 与被除数的符号相同


SELECT 100 + '1'

SELECT 100 / 0

######### 比较运算符 ###########################################
-- =    <=>与null进行比较   <> !=   <   >   <=   >=   
-- IS NULL
-- IS NOT NULL
-- least()------------------------最小  参数最少是两个
-- greatest()---------------------最大  参数最少是两个
-- between X and Y----------------[X，Y]之间，X要小于Y  连续值的查找
-- ISNULL-------------------------函数
-- IN-----------------------------非连续型离散数据的查找
-- NOT IN
-- LIKE---------------------------模糊匹配
-- regexp-------------------------正则表达式运算符
-- rlike--------------------------正则表达式运算符

-- LENGTH()-----------------------长度函数


SELECT 1='1' -- 数字与字符串相比，字符串隐式转换后再与之比较
# DUAL 伪表
FROM DUAL

-- 字符串与字符串相比，不会隐式转换  使用ANSI进行比较
-- 任何值与null相比 结果都为null
SELECT 1>NULL


SELECT 1 <=> NULL

-- ISNULL() / IS NOT NULL /IS NULL <=>

SELECT last_name, salary, commission_pct
FROM employees 
WHERE ISNULL(commission_pct);


SELECT last_name, salary, commission_pct
FROM employees 
WHERE NOT commission_pct <=> NULL

SELECT LEAST(salary, salary) FROM employees;

-- 查询工资不是6000 7000 8000
SELECT last_name,salary
FROM employees
WHERE salary NOT IN (6000,7000,8000)

-- last_name 中包含字母a 的人
-- % 代表不确定个数的不确定的字符
-- _ 代表一个不确定字符

-- 转义字符 \_ \% \\ 
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';

-- 设置转义字符
SELECT last_name 
FROM employees
WHERE last_name LIKE '_$_a%' ESCAPE '$' # 自定义 $ 为转义字符

-- 正则表达式

SELECT 'abcabc' REGEXP '^s','abct' REGEXP 't$'
FROM DUAL;

######################## 逻辑运算符 #######################

-- NOT !	AND &&		OR || 		XOR异或
-- AND 优先级大于 OR

SELECT last_name,salary
FROM employees
WHERE commission_pct  IS NOT NULL

######################### 位运算符 ######################## 

-- &按位与 |按位或 
-- ^按位异或 ~按位取反 
-- >>右移 <<左移

####################### 练习 ##############################
# 1.选择工资不在5000到12000的员工的姓名和工资

SELECT last_name,salary
FROM employees
WHERE salary NOT BETWEEN 5000 AND 12000;

# 2.选择在20或50号部门工作的员工姓名和部门号

SELECT last_name, department_id
FROM employees
WHERE department_id IN (20,50)

DESC employees;
# 3.选择公司中没有管理者的员工姓名及job_id

SELECT last_name, job_id,manager_id
FROM employees
WHERE manager_id IS NULL

SELECT DISTINCT manager_id
FROM employees;

# 4.选择公司中有奖金的员工姓名，工资和奖金级别

SELECT last_name,salary,commission_pct
FROM employees
WHERE commission_pct IS NOT NULL


# 5.选择员工姓名的第三个字母是a的员工姓名

SELECT last_name 
FROM employees
WHERE last_name LIKE '__a%';

# 6.选择姓名中有字母a和k的员工姓名

SELECT last_name
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%k%';

# 7.显示出表 employees 表中 first_name 以 'e'结尾的员工信息

SELECT * 
FROM employees
WHERE first_name LIKE '%e';

SELECT *
FROM employees
WHERE first_name REGEXP 'e$';

# 8.显示出表 employees 部门编号在 80-100 之间的姓名、工种

SELECT last_name,job_id,department_id
FROM employees
WHERE department_id BETWEEN 80 AND 100

# 9.显示出表 employees 的 manager_id 是 100,101,110 的员工姓名、
#	工资、管理者id

SELECT last_name,salary,manager_id
FROM employees
WHERE manager_id IN (100,101,110)