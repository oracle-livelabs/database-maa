# Use Real-Time Query and DML Redirection

## Introduction

You have a copy of your production data on the standby database, so why not use it to offload some work from the primary database? 
A standby database can be open read only while the recovery or production changes is ongoing. This feature is called **Real-Time Query**, and it's part of the Active Data Guard option.
Real-Time Query can be used to offload red-only workloads, such as reports or read-only application modules. If the transport is synchronous, the reading sessions can wait for the received redo to be applied, providing **consistent read** of all the transactions committed on the primary database.

Additionally, the standby database can be configured to automatically redirect write requests to the primary database, in an ACID-compliant way, with the changes visible only in the the privacy of the transaction started on the standby database.
This functionality allous to broaden the use cases for the physical standby, including application doing occasional writes. The feature, called **DML Redirection**, also supports DDLs and PL/SQL calls (although with some documented limitations).

Estimated Lab Time: 15 Minutes

### Requirements
To try this lab, you must have successfully completed the following labs:
* [Prepare the database hosts](../prepare-host/prepare-host.md)
* [Prepare the databases](../prepare-db/prepare-db.md)
* [Configure and Verify Data Guard](../configure-dg/configure-dg.md)
* [Create role-based services](../create-services/create-services.md)

### Objectives
* Open the standby database and enable Real-Time Query
* Enable synchronous transport and causal consistency
* Enable DML redirection

## Task 1: Open the standby database and enable Real-Time Query

```
<copy>
sqlplus / as sysdba
</copy>
```
```
<copy>
alter database open;
alter pluggable database PHOL23C open;
select name from v$active_services where con_id>=2;
exit
</copy>
```
```
<copy>
sqlplus tacuser/Welcome#Welcome#123@PHOL23C_RO.dbhol23c.misclabs.oraclevcn.com
</copy>
```
```
<copy>
desc t
select * from this_wasnt_there;
exit
</copy>
```
```
<copy>
--- tmux select-pane -t :.0
show database chol23c_r2j_lhr
---# Real Time Query:    ON
exit
</copy>
```
```
<copy>
---# tmux resize-pane -Z -t :.0
sqlplus tacuser/Welcome#Welcome#123@PHOL23C_RW.dbhol23c.misclabs.oraclevcn.com      
</copy>
```
```
<copy>
insert into t values ('Find me on the standby!');
commit;
</copy>
```
```
<copy>
--- tmux select-pane -t :.1
sqlplus tacuser/Welcome#Welcome#123@PHOL23C_RO.dbhol23c.misclabs.oraclevcn.com      
select * from t;
</copy>
```


## Task 2: Enable synchronous transport and causal consistency
```
<copy>
alter session set standby_max_data_delay=0;
select * from t;
alter session sync with primary;
exit
</copy>
```
```
<copy>
--- tmux select-pane -t :.0
---# --------------------------------------- MAX AVAILABILITY
exit
</copy>
```
```
<copy>
dgmgrl sys/Welcome#Welcome#123@hol23c0.dbhol23c.misclabs.oraclevcn.com:1521/chol23c_rxd_lhr.dbhol23c.misclabs.oraclevcn.com
</copy>
```
```
<copy>
-- show/edit all members new in 23c
show all members LogXptMode;
edit all members set property LogXptMode='SYNC';
show all members LogXptMode;
EDIT CONFIGURATION  SET PROTECTION MODE  as MaxAvailability;
</copy>
```
```
<copy>
--- tmux select-pane -t :.1
sqlplus tacuser/Welcome#Welcome#123@PHOL23C_RO.dbhol23c.misclabs.oraclevcn.com      
</copy>
```
```
<copy>
alter session set standby_max_data_delay=0;
select * from t;
alter session sync with primary;
exit
</copy>
```
--- tmux select-pane -t :.0
exit

## Task 3: Enable DML redirection
---# ----------------------------------------- DML REDIRECT
--- tmux select-pane -t :.1
```
<copy>
sqlplus tacuser/Welcome#Welcome#123@PHOL23C_RO.dbhol23c.misclabs.oraclevcn.com
</copy>
```
```
<copy>
insert into t values ('DML test');
---#	    ORA-16000: database or pluggable database open for read-only access
alter session enable ADG_REDIRECT_DML;
insert into t values ('DML test');
commit;
exit
</copy>
```




- **Author** - Ludovico Caldara, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn
- **Last Updated By/Date** -  Ludovico Caldara, December 2023
