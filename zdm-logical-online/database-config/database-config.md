# Connect to the source database and create migration users

## Introduction
In this lab, you will connect to your source database as system database administrator, create the required database and GoldenGate users to complete the migration, bestow them with the necessary privileges, and create a sample table to track through the migration.

The purpose of creating a database user and loading it with sample data is to simulate the user and data we are looking to migrate in a practical application.

ZDM will be running on the same server as the source database for the purpose of this workshop and resource conservation.

Disclaimer: The Zero Downtime Migration service host should be a dedicated system, but it can be shared for other purposes, as it is in this lab; however, the Zero Downtime Migration service host should not have Oracle Grid Infrastructure running on it.

Estimated Time: 15 minutes

###  Objectives

In this lab, you will:
* Learn how to Connect to the Source Database and create the required migration users.

### Prerequisites
* This workshop section requires having setup a compute instance and the source database.


## Task 1: Connect to Your Database and Configure required parameters

**Disclaimer**: Throughout the workshop there will be locations where you are copying and pasting multiple lines of code at a time from the instructions into SQLPlus. However, the last line pasted will not commit until you manually press enter a second time. To avoid statement failure, please be cognizant of this and press enter twice when pasting.

1. Verify that you are user 'opc' in your instance.

2. Switch from 'opc' user to user 'oracle'.
    ```
    <copy>
    sudo su - oracle
    </copy>
    ```

3. Set the environment variables to point to the Oracle binaries. When prompted for the SID (Oracle Database System Identifier) respond to the prompt with ORCL.
    ```
    <copy>
    . oraenv
    </copy>
    ```

4. Log into SQL as system database administrator (dba).
    ```
    <copy>
    sqlplus / as sysdba
    </copy>
    ```

5. Set streams pool size parameter that will be needed for running the migration.

    Check the current status:
    ```
    <copy>
    show parameter stream;
    </copy>
    ```

    ![Stream Status Before](./images/stream-status-before.png)

    Set the parameter:
    ```
    <copy>
    alter system set streams_pool_size=2g scope=both;    
    </copy>
    ```

    Confirm the update went through:
    ```   
    <copy>
    show parameter stream;        
    </copy>
    ```

    ![Stream Status After](./images/stream-status-after.png)

    Enable database minimal supplemental logging:

    ```
    <copy>    
    alter database add supplemental log data;
    </copy>
    ```

    Enable the parameter ENABLE _ GOLDENGATE _ REPLICATION:

    ```
    <copy>    
    ALTER SYSTEM SET ENABLE_GOLDENGATE_REPLICATION=TRUE SCOPE=BOTH;
    </copy>
    ```

    Enable ARCHIVELOG mode for the database:

    ```
    <copy>    
    shutdown immediate;
    </copy>
    ```
    ```
    <copy>    
    startup mount;
    </copy>
    ```
    ```
    <copy>    
    alter database archivelog;
    </copy>
    ```
    ```
    <copy>    
    alter database open;
    </copy>
    ``` 
    ![archive log enabled](./images/archivelog.png)   


    Enable FORCE LOGGING for the database:

    ```
    <copy>    
    alter database force logging;
    </copy>
    ```

## Task 2: Creating Users for Your Database Migration

1.  Create a GoldenGate administration user, c##ggadmin, in CDB$ROOT, granting all of the permissions listed in the example. Please bear in mind that you may need to press enter twice after copying the following statement for it to fully create the users, grant the privileges and execute the required PL/SQL procedure.

    ```
    <copy>    
    create user c##ggadmin identified by WELcome##1234 default tablespace users temporary tablespace temp;
    grant connect, resource to c##ggadmin container=all;
    grant select any dictionary to c##ggadmin container=all;
    grant unlimited tablespace to c##ggadmin;
    alter user c##ggadmin quota 100M ON USERS;
    grant select any dictionary to c##ggadmin;
    grant create view to c##ggadmin container=all;
    grant execute on dbms_lock to c##ggadmin container=all;
    exec dbms_goldengate_auth.GRANT_ADMIN_PRIVILEGE('c##ggadmin',container=>'all');
    </copy>
    ```


2. Switch the session of your container database to ORCLPDB.

    ```
    <copy>
    alter session set container=ORCLPDB;
    </copy>
    ```

3. Create a GoldenGate administration user, ggadmin, in the PDB, granting all of the permissions listed in the example. Please bear in mind that you may need to press enter twice after copying the following statement for it to fully create the users, grant the privileges and execute the required PL/SQL procedure.

    ```
    <copy>    
    create user ggadmin identified by WELcome##1234 default tablespace users temporary tablespace temp;
    grant connect, resource to ggadmin;
    alter user ggadmin quota 100M ON USERS;
    grant unlimited tablespace to ggadmin;
    grant select any dictionary to ggadmin;
    grant create view to ggadmin;
    grant execute on dbms_lock to ggadmin;
    exec dbms_goldengate_auth.GRANT_ADMIN_PRIVILEGE('ggadmin');
    </copy>
    ```


4. After connecting to your container database create the user 'zdml'. If you would like you can replace `WELcome123ZZ` with a password of your choice. Write down or save the password as you will need it later.
    ```
    <copy>
    create user zdml identified by WELcome##1234;
    </copy>
    ```

5. Grant the user privileges it will need for the migration. Please bear in mind that you may need to press enter twice after copying the following statement for it to fully create the users, grant the privileges and execute the required PL/SQL procedure.

    ```
    <copy>
    GRANT CONNECT,RESOURCE,CREATE TABLE,CREATE SEQUENCE to ZDML;
    ALTER USER ZDML quota unlimited on users;
    CREATE TABLE ZDML.EMPL (col1 number, col2 varchar2(9), col3 varchar2(100), col4 timestamp);
    ALTER TABLE ZDML.EMPL ADD CONSTRAINT EMPL_i1 PRIMARY KEY (col1,col2); 
    </copy>
    ```

## Task 3: Load Sample Table
1. Connect to your database user. Enter password `WELcome##1234` at the prompt that you set for your user.
    ```
    <copy>
    connect ZDML@ORCLPDB;
    </copy>
    ```

    Password:
    ```
    <copy>
    WELcome##1234
    </copy>
    ```


2. As ZDML run the following code to create a sample table. Please bear in mind that you may need to press enter twice after copying the following statement for it to fully execute.

    ```
    <copy>
    SET ECHO OFF 
    SET HEADING OFF 
    SET FEEDBACK OFF 
    SET SERVEROUTPUT ON; 
    DECLARE 
    SCN ZDML.EMPL.COL1%TYPE; 
    RND1 ZDML.EMPL.COL2%TYPE; 
    RND2 ZDML.EMPL.COL3%TYPE; 
    RND3 ZDML.EMPL.COL4%TYPE; 
    ROWSNUM NUMBER; 
    DBNAME VARCHAR2(60); 
    i INTEGER; 
    BEGIN 
    i := 0; 
    LOOP 
    SELECT COUNT(*) INTO ROWSNUM FROM ZDML.EMPL; 
    SELECT DBMS_RANDOM.STRING('P', 9) INTO RND1 FROM DUAL; 
    SELECT DBMS_RANDOM.STRING('P', 10) INTO RND2 FROM DUAL; 
    SELECT TO_DATE(TRUNC (DBMS_RANDOM.VALUE (2451545, 5373484)), 'J') INTO RND3 FROM DUAL; 
    INSERT INTO ZDML.EMPL(col1, col2, col3, col4) VALUES (ROWSNUM, RND1, RND2, RND3); 
    COMMIT; 
    DBMS_OUTPUT.PUT_LINE('Number of rows = ' || ROWSNUM); 
    IF ( i >= 1000 ) THEN 
    EXIT; 
    END IF; 
    i := i + 1; 
    END LOOP; 
    END; 
    / 
    </copy>
    ```

3. Check for the table name 'EMPL'.

    ```
    <copy>
    select table_name from user_tables;
    </copy>
    ```

4. View the sample table.

    ```
    <copy>
    select * from EMPL;
    </copy>
    ```

5. Exit SQL.

    ```
    <copy>
    exit
    </copy>
    ```

## Task 4: Change the Source Database System Password

To perform the migration, ZDM will require several passwords, for simplicity, let's change the Oracle Source Database System Password. This will help expedite the migration process when prompted for the different components passwords.

1. Connect to your source database. 
    ```
    <copy>
    sqlplus system/Ora_DB4U@localhost:1521/orcl
    </copy>
    ```

2. Change your password to __WELcome##1234__ by copying and executing the following in SQLPLUS
   
    ```
    <copy>
    ALTER USER system IDENTIFIED BY WELcome##1234;
    </copy>
    ```

3. The password has been changed. Exit SQL.

    ```
    <copy>
    exit
    </copy>
    ```




Please *proceed to the next lab*.


## Acknowledgements
* **Author** - Zachary Talke, Solutions Engineer, NA Tech Solution Engineering
* **Author** - Ameet Kumar Nihalani, Senior Principal Support Engineer, Oracle Cloud Database Migration
* **Author** - Ricardo Gonzalez, Senior Principal Product Manager, Oracle Cloud Database Migration
* **Contributors** - LiveLabs Team, ZDM Development Team
* **Last Updated By/Date** - Ricardo Gonzalez, January 2022
