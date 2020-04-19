# Lesson 29 MySQL replication

## Домашнее задание

Развернуть базу из дампа и настроить репликацию

В материалах приложены ссылки на вагрант для репликации
и дамп базы bet.dmp
базу развернуть на мастере
и настроить чтобы реплицировались таблицы
| bookmaker |
| competition |
| market |
| odds |
| outcome

\* Настроить GTID репликацию

варианты которые принимаются к сдаче
\- рабочий вагрантафайл
\- скрины или логи SHOW TABLES
\* конфиги
\* пример в логе изменения строки и появления строки на реплике

## Решение

 Vagrantfile с Ansible ролью, который устанавливает percona mysql server, конфигурирует восстанавливает базу  bet из  dump, настраивает GTID-репликацию, фильрацию реплициуемых таблиц

 - [Vagrantfile](Vagrantfile);
 - [Ansible](ansible/roles);

##  Проверка

Версия mysql:

```
[root@cloud16 vagrant]# mysql --version
mysql  Ver 14.14 Distrib 5.7.29-32, for Linux (x86_64) using  6.2
```

  Вывод команды `SHOW MASTER STATUS\G` на **master**:

```
mysql> SHOW MASTER STATUS\G
*************************** 1. row ***************************
             File: mysql-bin.000003
         Position: 194
     Binlog_Do_DB:
 Binlog_Ignore_DB:
Executed_Gtid_Set: bd2ce2ca-663e-11ea-9be6-5254008afee6:1-40
1 row in set (0.00 sec)

```

  Вывод команды `SHOW SLAVE STATUS\G` на **slave** (видно, что работает GTID-репликация, игноруются заданные таблицы):

```
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 192.168.11.120
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000003
          Read_Master_Log_Pos: 194
               Relay_Log_File: cloud16-relay-bin.000005
                Relay_Log_Pos: 407
        Relay_Master_Log_File: mysql-bin.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table: bet.events_on_demand,bet.v_same_event
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 194
              Relay_Log_Space: 656
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 1
                  Master_UUID: bd2ce2ca-663e-11ea-9be6-5254008afee6
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set: bd2ce2ca-663e-11ea-9be6-5254008afee6:1-40
            Executed_Gtid_Set: bd2ce2ca-663e-11ea-9be6-5254008afee6:1-40,
ff507568-663e-11ea-a478-5254008afee6:1-2
                Auto_Position: 1
         Replicate_Rewrite_DB:
                 Channel_Name:
           Master_TLS_Version:
1 row in set (0.00 sec)

mysql>

```

Проверяем что репликация работает:

1. Список таблиц  в базе **bet**. Проверяем командой `show tables;` на **master**:

   ```
   mysql> use bet;
   Database changed
   mysql> show tables;
   +------------------+
   | Tables_in_bet    |
   +------------------+
   | bookmaker        |
   | competition      |
   | events_on_demand |
   | market           |
   | odds             |
   | outcome          |
   | v_same_event     |
   +------------------+
   7 rows in set (0.00 sec)
   ```

2. Список таблиц  в базе **bet**. Проверяем командой `show tables;` на **slave**:

   ```
   mysql> use bet;
   Database changed
   mysql> show tables;
   +---------------+
   | Tables_in_bet |
   +---------------+
   | bookmaker     |
   | competition   |
   | market        |
   | odds          |
   | outcome       |
   +---------------+
   5 rows in set (0.00 sec)
   ```

   На  slave не хватает таблиц не добавленных и исключения.

3. Содержимое таблицы bookmaker. Проверяем вывод командой  `SELECT * FROM bookmaker;` на **master**:

```
mysql> use bet;
Database changed
mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
4 rows in set (0.00 sec)
```

4. Содержимое таблицы bookmaker. Проверяем вывод командой  `SELECT * FROM bookmaker;` на **slave**:

```
mysql> use bet;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
4 rows in set (0.00 sec)
```

5. Добавляем новую запись в таблицу bookmaker командой ` INSERT INTO bookmaker (id,bookmaker_name) VALUES(1,'2020xbet');` на **master** и на **slave** проверяем  содержимое таблицы командой `SELECT * FROM bookmaker;`:

   ```
   mysql> SELECT * FROM bookmaker;
   +----+----------------+
   | id | bookmaker_name |
   +----+----------------+
   |  1 | 2020xbet       |
   |  4 | betway         |
   |  5 | bwin           |
   |  6 | ladbrokes      |
   |  3 | unibet         |
   +----+----------------+
   5 rows in set (0.00 sec)
   ```

   на slave появилась новая запись

6. Проверяем приём изменений на **slave** в логе командой ```mysqlbinlog /var/lib/mysql/mysql-bin.000002``` :

```
[root@cloud16 vagrant]# mysqlbinlog /var/lib/mysql/mysql-bin.000002
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#200315  0:58:58 server id 2  end_log_pos 123 CRC32 0x0dd8dfe0 	Start: binlog v 4, server v 5.7.29-32-log created 200315  0:58:58 at startup
ROLLBACK/*!*/;
BINLOG '
olNtXg8CAAAAdwAAAHsAAAAAAAQANS43LjI5LTMyLWxvZwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAACiU21eEzgNAAgAEgAEBAQEEgAAXwAEGggAAAAICAgCAAAACgoKKioAEjQA
AeDf2A0=
'/*!*/;
# at 123
#200315  0:58:58 server id 2  end_log_pos 154 CRC32 0x68a4c013 	Previous-GTIDs
# [empty]
# at 154
#200315  0:58:58 server id 2  end_log_pos 219 CRC32 0x0fe02afb 	GTID	last_committed=0	sequence_number=1	rbr_only=no
SET @@SESSION.GTID_NEXT= 'ff507568-663e-11ea-a478-5254008afee6:1'/*!*/;
# at 219
#200315  0:58:58 server id 2  end_log_pos 398 CRC32 0x0df45061 	Query	thread_id=2	exec_time=0	error_code=0
SET TIMESTAMP=1584223138/*!*/;
SET @@session.pseudo_thread_id=2/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1436549152/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C latin1 *//*!*/;
SET @@session.character_set_client=8,@@session.collation_connection=8,@@session.collation_server=8/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' AS '*0086EAE4683EAF794D30A157014D52E029D60F31'
/*!*/;
```