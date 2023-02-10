################ 单行函数 （mysql中的）################################
-- 1.内置函数
-- 2.自定义函数

-- 不同的数据库管理系统中的函数差异很大
-- sql函数移植性很差

-- 根据功能分类 1.数值 2.字符串 3.日期和时间 4.流程控制 
		-- 5.加密与解密 6.获取MySQL信息
		-- 7.聚合函数
-- 根据行数分类:-- 单行函数 一参数进一结果出
		-- 聚合函数（分组函数）多参数进一结果出




-- 单行函数，可以嵌套，可以是某一列
	-- 数值
	--	ABS(x)			绝对值
	--	SIGN(x)			正负号	
	--	PI()			Π
	--	CEIL(X),CEILING(X)	向上取整
	-- 	FLOOR(X)		向下取整
	--	LEAST(X1,X2...)		最小
	--	GREATEST(X1,X2...)	最大
	-- 	MOD(X,Y)		取余
	-- 	RAND()			0-1 随机数
	--	RAMD(X)			0-1 随机数 x为种子	
	--	ROUND(X)		四舍五入
	--	ROUND(X,Y)		四舍五入，精确y位，（y可以是负数）
	--	TRUNCATE(X,Y)		截断，y位小数
	--	SQRT(X)			开平方
	-- 	弧度转换
	--   	三角函数
	-- 	指数对数
	--	进制间转化
	
	
	-- 字符串（字符串索引是从一开始的）
	-- 日期时间
	-- 流程控制
	--   IF(V,V1,V2)
	--   IFNULL(V1,V2)
	--   CASE WHEN .. THEN .. WHEN .. THEN .. [ELSE..] END
	--   CASE .. WHEN .. THEN ..WHEN ..THEN.. [ELSE..] END
	
/*
查询部门号为 10,20, 30 的员工信息, 
若部门号为 10, 则打印其工资的 1.1 倍, 20 号部门, 
则打印其工资的 1.2 倍, 30 号部门打印其工资的 1.3 倍数。
*/
SELECT last_name,salary,
	CASE 
	WHEN department_id=10 THEN salary*1.1
	WHEN department_id=20 THEN salary*1.2
	WHEN department_id=30 THEN salary*1.3
	ELSE salary*1.4 END salary_now
FROM employees e;

SELECT last_name,salary,
	CASE department_id 
	WHEN 10 THEN salary*1.1
	WHEN 20 THEN salary*1.2
	WHEN 30 THEN salary*1.3
	ELSE salary*1.4 END salary_now
FROM employees;


	-- 加密解密
	
SELECT PASSWORD('1234') FROM DUAL; # 8.0不推荐使用(弃用)
SELECT ENCODE(' '),DECODE('')FROM DUAL # 8.0弃用

SELECT MD5('abc123'),SHA('abc123')FROM DUAL;# 不可逆的加密

	-- MySQL信息
SELECT  VERSION(),CONNECTION_ID(),
	DATABASE(),SCHEMA(),# 当前数据库
	USER(),CURRENT_USER(),
	SYSTEM_USER(),SESSION_USER(),
	CHARSET(123),# 返回字符串的变量字符集
	COLLATION('123')# 返回字符串的比较规则
FROM DUAL;
	
	
	-- 其他函数
	
SELECT FORMAT(15.1234,2),FORMAT(15.1234,-2)
# 将数字进行格式化，第二个参数表示四舍五入后的小数位数
# 第二个参数小于零，没有小数
FROM DUAL;


SELECT CONV(123,10,2)
# 进制转换
FROM DUAL;


SELECT INET_ATON('127.0.0.1'),
# 将ip地址转化为数字字符串
# 计算方式：
#    127*256的三次方+0*256的2次方+ 0*256 + 1
	INET_NTOA('2130706433')
# 将对应数字转化为ip地址
FROM DUAL;

	
SELECT BENCHMARK(10,5*3)
# 执行10次5*3，返回执行消耗的时间
FROM DUAL;

SELECT CHARSET('abcd'),CONVERT('abcd'USING'utf8mb4')
FROM DUAL
	
################### 练习 ###################
# 1.显示系统时间(注：日期+时间)

SELECT NOW(),SYSDATE(),CURRENT_TIMESTAMP(),LOCALTIME()
FROM DUAL;

# 2.查询员工号，姓名，工资，
	# 以及工资提高百分之20%后的结果（new salary）
	
SELECT employee_id,last_name,salary,salary*(1.2) "new salary"
FROM employees


# 3.将员工的姓名按首字母排序，并写出姓名的长度（length）

SELECT last_name,LENGTH(last_name)
FROM employees
ORDER BY last_name DESC

# 4.查询员工id,last_name,salary，并作为一个列输出，
	# 别名为OUT_PUT

SELECT CONCAT(employee_id,last_name,salary) OUT_PUT
FROM employees

# 5.查询公司各员工工作的年数、工作的天数，
	# 并按工作年数的降序排序

SELECT YEAR(end_date)-YEAR(start_date) AS years,
	DATEDIFF(end_date,start_date) AS days
FROM job_history
ORDER BY years


# 6.查询员工姓名，hire_date , department_id，满足以下条件：
	# 雇用时间在1997年之后，
	# department_id为80 或 90 或110
	# commission_pct不为空
	
SELECT last_name,hire_date,department_id
FROM employees e
WHERE department_id IN (80,90,110)
	AND commission_pct IS NOT NULL
	AND  YEAR(hire_date)>=1997

# 7.查询公司中入职超过10000天的员工姓名、入职时间

SELECT last_name,hire_date
FROM employees e
WHERE DATEDIFF(NOW(),hire_date)>10000

# 8.做一个查询，产生下面的结果
	#<last_name> earns <salary> monthly but wants <salary*3>

SELECT  CONCAT(last_name,' earns ',ROUND(salary,0),
		' monthly but wants ',salary*3)
		 AS "dream salary"
FROM employees 
	
	
# 9.使用case-when，按照下面的条件：
--	job 		grade
--	AD_PRES 	A
--	ST_MAN 		B
--	IT_PROG 	C
--	SA_REP 		D
--	ST_CLERK 	E

SELECT * FROM employees
LIMIT 10

SELECT last_name,job_id,
	CASE job_id
	WHEN 'AD_PRES' THEN 'A'
	WHEN 'ST_MAN' THEN 'B'
	WHEN 'IT_PROG' THEN 'C'
	WHEN 'SA_REP' THEN 'D'
	WHEN 'ST_CLERK' THEN 'E' END AS grade	
FROM employees;	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
