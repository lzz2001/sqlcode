############### DDL ##########################################

#######     创建和管理表

创建库 --> 确认字段 --> 创建表 --> 插入数据

系统架构层次来看，从大到小
	数据库服务器 --> 数据库 --> 数据表 --> 行与列
	
	
命名规则：
	数据库名 表名不超过30个字符
	变量名 最多29个字符
	
	26大写，小写 0-9 _
	
	标识符与系统字冲突，使用着重号【尽量避免使用】
	
	保持字段名与类型的一致性

创建和管理数据库：(需要权限)
-- 1.
CREATE DATABASE database1; # 使用默认字符集

-- 2.
CREATE DATABASE database2 CHARACTER SET 'utf8mb4';
			   # 指明字符集
-- 3.
CREATE DATABASE IF NOT EXISTS database3 CHARACTER SET 'utf8mb4';;
		# 存在该库，不会再创建，不覆盖
		# 不存在，可以成功创建
查看数据库

SHOW VARIABLES LIKE 'character_%'
SHOW VARIABLES LIKE 'character_%'\g
SHOW DATABASES;
SHOW CREATE DATABASE database1;

使用/管理 数据库

USE database1;

SHOW TABLES;	# 查看数据库中有什么表
SHOW TABLE FROM database1;

SELECT DATABASE() FROM DUAL # 查看当前使用数据库


修改数据库，【通常不使用】
ALTER DATABASE database1 CHARACTER SET 'utf8' # 修改字符集

数据库不能改名，可视化工具中的改名是创建新表，复制

删除库
DROP DATABASE database1;
DROP DATABASE IF EXISTS database1;

USE dbtest1;
##################   建表	[需要权限]
-- 1.
CREATE TABLE IF NOT EXISTS myemp1(
id INTEGER,# -2^31 ~ 2^31-1
emp_name VARCHAR(15),# 字符串必须指明长度
hire_data DATE
) # 没有指明字符集，默认使用所在数据库的字符集

DESC myemp1;

SHOW CREATE TABLE myemp1;

CREATE TABLE `myemp1` (
  `id` INT DEFAULT NULL,
  `emp_name` VARCHAR(15) DEFAULT NULL,
  `hire_data` DATE DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_0900_ai_ci

SELECT * FROM #查看数据

-- 2.基于当前数据库已经存在的表- - 建立新表（同时导入数据）
CREATE TABLE myemp2
AS
SELECT employee_id,last_name,salary
FROM employees

CREATE TABLE 表名 AS
SELECT ....（任何查询语句）[别名]

创建employees_copy 对employees 的复制，包括表数据

CREATE TABLE employees_copy
AS
SELECT * FROM employees;

创建employees_blank 对employees 的复制，不包括表数据

CREATE TABLE employees_blank
AS
SELECT * FROM employees LIMIT 0
-- WHERE 1 = 2 #或者过滤



########################## 管理表
USE dbtest1
DESC TABLE myemp1
DESC myemp1

修改表

-- 添加一个字段
ALTER TABLE myemp1
ADD salary DOUBLE(10,2)

ALTER TABLE myemp1
ADD phone_num VARCHAR(20) FIRST;

ALTER TABLE myemp1
ADD email VARCHAR(20) AFTER phone_num



修改一个字段: 数据类型，长度，默认值

ALTER TABLE myemp1
MODIFY email VARCHAR(25) DEFAULT 'aaa'

重命名一个字段

ALTER TABLE myemp1
CHANGE month_sal salary  VARCHAR(14)

ALTER TABLE myemp1
CHANGE salary month_sal VARCHAR(15)

删除一个字段

ALTER TABLE myemp1 
DROP COLUMN email

重命名表

RENAME TABLE myemp11
TO myemp1

ALTER TABLE myemp1
RENAME TO myemp11

删除表(删表不能撤销，无法回滚)【有备份，日志文件可以恢复】
 
DROP TABLE IF EXISTS employees;


清空表
-- 删除表中数据，保留表结构

TRUNCATE TABLE employees;




##################################### 阿里

TRUNCATE TABLE 比 DELETE FROM 速度快，使用的
系统资源和日志资源少， TRUNCATE 无事务，且不触发
TRIGGER 又可能造成事故，不建议开发时使用


字段名称——修改代价太大 全小写

表中必备 id BIGINT UNSIGNED,gmt_creat DATETIME,
         gmt_modified DATETIME

表名 业务名称，加，表的作用
库名与应用名一致
合适的字符存储长度，节省空间，节约索引存储，提升检索速度


########## 8.0 DDL原子化
CREATE DATABASE mytest;
USE mytest;

CREATE TABLE book1(
book_id INT ,
book_name VARCHAR(255)
);

SHOW TABLES;
DROP TABLE book1,book2;

执行完 	5.7删除book1
	8.0 不删除book1
-- ----------------------------------练习

#1. 创建数据库test01_office,指明字符集为utf8。
#	并在此数据库下执行下述操作
CREATE DATABASE IF NOT EXISTS test01_office 
CHARACTER SET 'utf8';

USE test01_office;



#2. 创建表dept01
/*
字段 类型
id INT(7)
NAME VARCHAR(25)
*/

CREATE TABLE IF NOT EXISTS dept01(
id INT(7),
NAME VARCHAR(25)
);



#3. 将表departments中的数据插入新表dept02中

CREATE TABLE dept02
AS
SELECT *
FROM atguigudb.`departments`


#4. 创建表emp01
/*
字段 类型
id INT(7)
first_name VARCHAR (25)
last_name VARCHAR(25)
dept_id INT(7)
*/
CREATE TABLE emp01(
id INT(7),
first_name VARCHAR(25),
last_name VARCHAR(25),
dept_id INT(7)
)



#5. 将列last_name的长度增加到50
DESC emp01

ALTER TABLE emp01
MODIFY last_name VARCHAR(50)


#6. 根据表employees创建emp02

CREATE TABLE emp02
AS
SELECT *
FROM atguigudb.employees

SHOW TABLES;
#7. 删除表emp01

DROP TABLE IF EXISTS emp01

#8. 将表emp02重命名为emp01

RENAME TABLE emp02
TO emp01

ALTER TABLE emp01
RENAME TO emp02
#9.在表dept02和emp01中添加新列test_column，并检查所作的操作

ALTER TABLE emp01
ADD COLUMN test_column INT

ALTER TABLE dept02
ADD  test_column INT FIRST


#10.直接删除表emp01中的列 department_id
DESC emp01

ALTER TABLE emp01
DROP department_id

######################### 练习二
# 1、创建数据库 test02_market
CREATE DATABASE test02_market
USE test02_market
# 2、创建数据表 customers
CREATE TABLE customers(
c_num INT,
c_name VARCHAR(50),
c_contact VARCHAR(50),
c_city VARCHAR(50),
c_birth DATE
);
# 3、将 c_contact 字段移动到 c_birth 字段后面
ALTER TABLE customers
MODIFY c_contact VARCHAR(50) AFTER c_birth

# 4、将 c_name 字段数据类型改为 varchar(70)

ALTER TABLE customers
MODIFY c_name VARCHAR(70)

ALTER TABLE customers
MODIFY c_birth DATE

# 5、将c_contact字段改名为c_phone

ALTER TABLE customers
CHANGE c_contact c_phone VARCHAR(50)

# 6、增加c_gender字段到c_name后面，
	# 数据类型为char(1)

ALTER TABLE customers
ADD c_gender CHAR(1) AFTER c_name

# 7、将表名改为customers_info

RENAME TABLE customers
TO customers_info

# 8、删除字段c_city

ALTER TABLE customers_info
DROP COLUMN c_city

######################### 练习三
# 1、创建数据库test03_company



# 2、创建表offices
字段名 		数据类型
officeCode 	INT
city 		VARCHAR(30)
address 	VARCHAR(50)
country 	VARCHAR(50)
postalCode 	VARCHAR(25)

# 3、创建表employees
empNum 		INT
lastName 	VARCHAR(50)
firstName 	VARCHAR(50)
mobile 		VARCHAR(25)
CODE 		INT
jobTitle 	VARCHAR(50)
birth		DATE
note 		VARCHAR(255)
sex 		VARCHAR(5)

# 4、将表employees的mobile字段修改到code字段后面
# 5、将表employees的birth字段改名为birthday
# 6、修改sex字段，数据类型为char(1)
# 7、删除字段note
# 8、增加字段名favoriate_activity，数据类型为varchar(100)

# 9、将表employees的名称修改为 employees_info