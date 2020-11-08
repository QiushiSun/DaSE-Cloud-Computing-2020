## 2020Fall 云计算应用与开发 

### Lecture4 云计算背后的技术-2 Cont'd

#### Key-Value Storage 键值存储

1. 淘宝 item number $\rightarrow$ information about the item
2. 携程 flight number $\rightarrow$ information about the flight
3. Weibo id $\rightarrow$ all posts of the ID
4. API:gt(key) and put(key,value)

Remarks: value可能是xml,json,文档...

------

### NoSQL所面临的挑战

1. SQL支持不足：往往不支持join等复杂查询
2. 开源：没有统一标准，系统尚不成熟
3. 功能不够丰富：通常用于随机读写非结构化数据，缺乏丰富函数的支持
4. 文件容量通常比较大：JSON，Graph

#### NewSQL：SQL和NoSQl的结合

1. 关系型数据库

2. 遵循ACID原则

3. 满足NoSQL高可扩展性

Remarks:**ACID原则**是指[数据库管理系统](https://zh.wikipedia.org/wiki/数据库管理系统)（[DBMS](https://zh.wikipedia.org/wiki/DBMS)）在写入或更新资料的过程中，为保证[事务](https://zh.wikipedia.org/wiki/数据库事务)（transaction）是正确可靠的，所必须具备的四个特性：[原子性](https://zh.wikipedia.org/w/index.php?title=原子性&action=edit&redlink=1)（atomicity）、[一致性](https://zh.wikipedia.org/wiki/一致性_(数据库))（consistency）、[隔离性](https://zh.wikipedia.org/wiki/隔離性)（isolation）、[持久性](https://zh.wikipedia.org/w/index.php?title=持久性&action=edit&redlink=1)（durability）。(Source:wikipedia)

------

### Snowflake

