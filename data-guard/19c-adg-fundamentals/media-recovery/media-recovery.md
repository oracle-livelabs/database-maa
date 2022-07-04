#Performing Automatic Block Media Recovery

## Introduction
In this lab, we will see how Active Data Guard Automatic Block media recovery works.

Block corruptions are a common source of database outages. A database block is
corrupt when its content has changed from what Oracle Database expects to find. If
not prevented or repaired, block corruption can bring down the database and possibly
result in the loss of key business data.

Data Guard maintains a copy of your data in a standby database that is continuously updated with changes from the primary database. Data Guard validates all changes before it applies to the standby database, preventing physical corruptions that occur in the storage layer from causing data loss and downtime. The primary database automatically attempts to repair the corrupted block in real time by fetching a good version of the same block from an Active Data Guard physical standby database. This process works in both ways.

In this lab we will introduce a block corruption in the database and see Active Data Guard repairing it.

Estimated Lab Time: 40 Minutes

### Objectives
- Setup your environment
- Corrupt the datafile
- Access the table

### Prerequisites
- Connect to the Database


## Task 1: Set the environment

First download the 3 sql scripts we will need in this Lab.

[01-abmr.sql](./scripts/01-abmr.sql)

[02-abmr.sql](./scripts/02-abmr.sql)

[03-abmr.sql](./scripts/03-abmr.sql)


Also find your ssh keys which are created earlier to connect to the hosts where the primary and standby database are located.

We need 4 sessions

1. 2 sessions to the primary as the oracle user
2. 2 sessions to the standby as the oracle user

The first session will be used to perform the actions in the database, the second session per environment is used to put a tail on the alert log.

1. On the first session of the primary, set the environment and log on to the database

### **Option 1:** MAC or Windows CYGWIN Emulator
1.  Go to ***Overview Bare Metal, VM and Exadata DB Systems*** and select the First Database system ***ADGHOLAD1***
2.  On the DB System homepage, Scroll down  to ***Nodes(1)*** find the Public IP for the Virutal Machine.
3.  Open up a terminal (MAC) or cygwin emulator as the opc user.  Enter yes when prompted.

    ````
    ssh -i ~/.ssh/<sshkeyname> opc@<Your Compute Instance Public IP Address>
    ````
    ![](./images/em-mac-linux-ssh-login.png " ")


### **Option 2:** Windows using Putty
On Windows, you can use PuTTY as an SSH client. PuTTY enables Windows users to connect to remote systems over the internet using SSH and Telnet. PuTTY supports SSH and it  provides secure shell, and it encrypts the information before it's transferred.

1.  Download and install PuTTY. [http://www.putty.org](http://www.putty.org)
2.  Run the PuTTY program. On your computer, go to **All Programs > PuTTY > PuTTY**
3. Go to ***Overview >> Bare Metal, VM and Exadata DB Systems*** and select the First Database system ***ADGHOLAD1***
4.   On the DB System homepage, Scroll downd to ***Nodes(1)*** find the Public IP  for your Virtual Machine.
5. Select or enter the following information:
    - Category: _Session_
    - IP address: _Your service instance’s public IP address_
    - Port: _22_
    - Connection type: _SSH_

    ![](images/7c9e4d803ae849daa227b6684705964c.jpg " ")

### Create all the sessions accordingly
 In the terminal, connect to the Database. We use the SYS user for this and we can login with ***sqlplus / as sysdba***


````
    [opc@vmadgholad1 ~]$ sudo su - oracle
    [oracle@vmadgholad1 ~]$ . oraenv
    ORACLE_SID = [DGHOL] ?
    The Oracle base remains unchanged with value /u01/app/oracle
    [oracle@vmadgholad1 ~]$ sqlplus / as sysdba

    SQL*Plus: Release 19.0.0.0.0 - Production on Sun Feb 28 09:39:05 2021
    Version 19.9.0.0.0

    Copyright (c) 1982, 2020, Oracle.  All rights reserved.


    Connected to:
    Oracle Database 19c EE Extreme Perf Release 19.0.0.0.0 - Production
    Version 19.9.0.0.0

    SQL>
````

Then alter your session to connect to the pdb.

````
    SQL> <copy>alter session set container=mypdb;</copy>

    Session altered.

    SQL>
````

2. On the second session, set the environment and put a tail -f on the  Database alert log.

    > **Note**: in the tail command, change the directory name "dghol_fra1sw" to reflect your database unique name.

    ````
    ssh -i ~/.ssh/sshkeyname opc@<<Public IP Address>>
    [opc@vmadgholad1 ~]$ sudo su - oracle
    Last login: Sun Feb 28 09:36:30 UTC 2021
    [oracle@vmadgholad1 ~]$ . oraenv
    ORACLE_SID = [DGHOL] ?
    The Oracle base has been set to /u01/app/oracle
    [oracle@vmadgholad1 ~]$ tail -f $ORACLE_BASE/diag/rdbms/dghol_fra1sw/DGHOL/trace/alert_DGHOL.log
    ````

Repeat these steps on the standby consoles.

## Task 2: Setup the environment

1. In the SQL Plus console from the primary database, run the 01-abmr.sql script.
    You can open this script and copy/paste this or copy it over to the host, just as you prefer.

Another option instead of copy/paste is to use wget on the command line from the host.
To do this, open a new SSH connection to the host as the opc user.
Next ***sudo su - oracle*** to switch to the Oracle user and then issue the following wget commands:

````
<copy>wget https://oracle.github.io/learning-library/data-management-library/database/data-guard/19c-adg-fundamentals/media-recovery/scripts/01-abmr.sql
wget https://oracle.github.io/learning-library/data-management-library/database/data-guard/19c-adg-fundamentals/media-recovery/scripts/02-abmr.sql
wget https://oracle.github.io/learning-library/data-management-library/database/data-guard/19c-adg-fundamentals/media-recovery/scripts/03-abmr.sql</copy>

````

2. This script creates a tablespace, adds a table in it and inserts a row. This will also return the rowID. Take a note of this number as you will need it in step 2, the step that will introduce corruption.

    ````
    SQL> <copy>show con_name</copy>

    CON_NAME
    ------------------------------
    MYPDB
    ````
    ````
    SQL> <copy>@01-abmr.sql</copy>
    ````
    ````
    SQL> <copy>set feed on;</copy>
    ````
    ````
    SQL> <copy>Col owner format a20;</copy>
    ````
    ````
    SQL> <copy>var rid varchar2(25);</copy>
    ````
    ````
    SQL> <copy>col segment_name format a20;</copy>
    ````
    ````
    SQL> <copy>drop tablespace corruptiontest including contents and datafiles;
    drop tablespace corruptiontest including contents and datafiles</copy>
    *
    ERROR at line 1:
    ORA-00959: tablespace 'CORRUPTIONTEST' does not exist
    ````

    ````
    SQL> <copy>create tablespace corruptiontest datafile '/home/oracle/corruptiontest01.dbf' size 1m;</copy>

    Tablespace created.
    ````

    ````
    SQL> <copy>create table will_be_corrupted(myfield varchar2(50)) tablespace corruptiontest;</copy>

    Table created.
    ````

    ````
    SQL> <copy>insert into will_be_corrupted(myfield) values ('This will have a problem') returning rowid into :rid;</copy>

    1 row created.
    ````

    ````
    SQL> <copy>print</copy>

    RID
    --------------------------------------------------------------------------------------------------------------------------------
    AAASGFAANAAAAAPAAA
    ````

    ````
    SQL> <copy>Commit;</copy>

    Commit complete.
    ````

    ````
    SQL> <copy>Alter system checkpoint;</copy>

    System altered.
    ````

    ````
    SQL> <copy>select * from will_be_corrupted;</copy>

    MYFIELD
    --------------------------------------------------
    This will have a problem

    1 row selected.
    ````

    ````
    SQL> <copy>--select owner, segment_name,tablespace_name,file_id,block_id from dba_extents where segment_name='WILL_BE_CORRUPTED'; -- will be segment id</copy>
    ````

    ````
    SQL> <copy>select dbms_rowid.ROWID_BLOCK_NUMBER(ROWID, 'SMALLFILE') FROM will_be_corrupted where myfield='This will have a problem';</copy>

    DBMS_ROWID.ROWID_BLOCK_NUMBER(ROWID,'SMALLFILE')
    ------------------------------------------------
                            15

    1 row selected.

    SQL>
    ````

In this example, you will need to remember the number 15.

## Task 3: Corrupt the datafile
1. In the same session, execute script 02-abmr.sql.
    This script will ask for a number. This is the number from the first step and we will use this to corrupt the datafile which the first script has created.

    ````
    SQL> <copy>@02-abmr.sql</copy>
    ````
    ````
    SQL> <copy>host dd conv=notrunc bs=1 count=2 if=/dev/zero of=/home/oracle/corruptiontest01.dbf seek=$((&block_id*8192+16))</copy>
    Enter value for block_id: 15
    2+0 records in
    2+0 records out
    2 bytes (2 B) copied, 0.000608575 s, 3.3 kB/s

    SQL>
    ````

At this point, we have a corrupt datafile, but the database is not aware of it yet.


## Task 4: Access the table

By accessing the table, Oracle will need to read the data. This demo database is not active, so it will be necessary to flush the caches before we access the table. That way, the data must be read from disk. This data is corrupt and without any error returned to the user, Active Data Guard will repair the corrupt block before returning the query result.

1. Use the script 03-abmr.sql for this.

    Check the Database alert log closely while executing this step.

    In the sqlplus window we will see this

    ````
    SQL> <copy>@03-abmr.sql</copy>
    ````
    ````
    SQL> <copy>alter system flush buffer_cache;</copy>

    System altered.
    ````

    ````
    SQL> <copy>select * from will_be_corrupted;</copy>

    MYFIELD
    --------------------------------------------------
    This will have a problem

    1 row selected.

    SQL>
    ````

    and in alert log from the primary database we notice that the automated block media recovery took place.

    ````
    ...
    2021-02-28T09:51:48.021351+00:00
    MYPDB(3):ALTER SYSTEM: Flushing buffer cache inst=0 container=3 global
    MYPDB(3):Hex dump of (file 13, block 15) in trace file /u01/app/oracle/diag/rdbms/dghol_fra1sw/DGHOL/trace/DGHOL_ora_4300.trc
    MYPDB(3):
    MYPDB(3):Corrupt block relative dba: 0x0340000f (file 13, block 15)
    MYPDB(3):Bad check value found during multiblock buffer read
    MYPDB(3):Data in bad block:
    MYPDB(3): type: 6 format: 2 rdba: 0x0340000f
    MYPDB(3): last change scn: 0x0000.0000.003896dd seq: 0x1 flg: 0x16
    MYPDB(3): spare3: 0x0
    MYPDB(3): consistency value in tail: 0x96dd0601
    MYPDB(3): check value in block header: 0x0
    MYPDB(3): computed block checksum: 0x9127
    MYPDB(3):
    MYPDB(3):Reading datafile '/home/oracle/corruptiontest01.dbf' for corrupt data at rdba: 0x0340000f (file 13, block 15)
    MYPDB(3):Reread (file 13, block 15) found same corrupt data (no logical check)
    MYPDB(3):Starting background process ABMR
    2021-02-28T09:51:48.090006+00:00
    Corrupt Block Found
            TIME STAMP (GMT) = 02/28/2021 09:51:47
            CONT = 3, TSN = 6, TSNAME = CORRUPTIONTEST
            RFN = 13, BLK = 15, RDBA = 54525967
            OBJN = 74117, OBJD = 74117, OBJECT = WILL_BE_CORRUPTED, SUBOBJECT =
            SEGMENT OWNER = SYS, SEGMENT TYPE = Table Segment
    2021-02-28T09:51:48.113521+00:00
    ABMR started with pid=80, OS id=13327
    2021-02-28T09:51:48.114720+00:00
    Automatic block media recovery service is active.
    2021-02-28T09:51:48.114946+00:00
    MYPDB(3):Automatic block media recovery requested for (file# 13, block# 15)
    2021-02-28T09:51:55.535547+00:00
    Automatic block media recovery successful for (file# 13, block# 15)
    2021-02-28T09:51:55.536073+00:00
    MYPDB(3):Automatic block media recovery successful for (file# 13, block# 15)
    2021-02-28T09:52:28.831408+00:00
    MYPDB(3):Resize operation completed for file# 10, old size 430080K, new size 440320K
    ...
    ````

## Task 5: Cleanup

To clean this excercise, just drop the tablespace.
1. In the sqlplus window, use this command:

    ````
    SQL> <copy>drop tablespace corruptiontest including contents and datafiles;</copy>

    Tablespace dropped.

    SQL>
    ````

You have now seen Active Data Guard Automatic Block media recovery working. You may now [proceed to the next lab](#next).


## Acknowledgements

- **Author** - Pieter Van Puymbroeck, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn, Database Product Management
- **Last Updated By/Date** -  Suraj Ramesh, September 2021
