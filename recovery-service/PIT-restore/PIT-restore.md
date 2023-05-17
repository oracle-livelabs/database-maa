# Real-time Oracle Database protection with Autonomous Recovery Service

## Introduction

This lab shows you how to configure automatic backups for the Oracle Database with Autonomous Recovery Service as the backup destination.  After completing this workshop you should be familiar with the configuration of automatic backups for Base Database Service, real-time database protection, point-in-time recovery of a database, monitoring protection status, reporting on protection metrics, and setting alarms when metrics exceed your service level requirements.

Estimated Time: TBD minutes

### Objectives

In this lab, you will:
* Alter data in the Oracle Database
* Perform a point-in-time recovery using the SCN just prior to the data alteration

## Task 1: Perform a point-in-time restore

1. Navigate to Database node details
    ![image alt text](images/Ham_policies.png)

2. Get the public IP address of the system
    ![image alt text](images/create_policy_button.png)

3. SSH into the host using the follow commnand:
    ```
    <copy>ssh -i <private_key_file> opc@<public-ip-address> </copy>
    ```

4. Use SQLPlus:

    ```
    $ sudo su - oracle     // Changes the user to oracle.
    $ sqlplus / as sysdba  // Connects to the database.
    ```

5. Create a table with a user entry:

    ```
    SQL> create table employees(first_name varchar2(50));
    SQL> insert into employees values ('Thomas');
    SQL> commit;
    ```

6. Capture the SCN for the database after the first employee was added:
    ```
    SQL> Select CURRENT_SCN as AFTER_THOMAS from v$database;
    ```

7. Insert another employee:
    ```
    SQL> insert into employees values ('Bob');
    SQL> commit;
    ```

8. Query the employees table to see both new names:
    ```
    SQL> select * from employees;
    ```

9. Capture the SCN for the database after the second employee was added:
    ```
    SQL> Select CURRENT_SCN as AFTER_BOB from v$database;
    ```

9. Force a log switch
    ```
    SQL> alter system switch logfile;
    SQL> alter system archive log current;
    SQL> Exit
    ```

10. Force delete all the archivelogs from the FRA
    ```
    $> cd /u03/app/oracle/fast_recovery_area
    $> find . -name '*.arc' -delete
    ```

11. Restore the database using the SCN from AFTER_THOMAS in step 6.

    Restore will take about 10 minutes

12. After the restore is complete query the employee table:
    ```
    sqlplus / as sysdba
    select * from employees;
    ```


## Appendix 1: Overview of Zero Data Loss Autonomous Recovery Service

Add information about Recovery Service

## Learn More

* [Website for Zero Data Loss Autonomous Recovery Service](https://oracle.com/zrcv)
* [Blog Introducing the Oracle Database Zero Data Loss Autonomous Recovery Service](https://blogs.oracle.com/maa/post/introducing-recovery-service)
* [Documentation for Zero Data Loss Autonomous Recovery Service](https://docs.oracle.com/en/cloud/paas/recovery-service/dbrsu/)


## Acknowledgements
* **Author** - Kelly Smith, Product Manager, Backup & Recovery Solutions
* **Last Updated By/Date** - Kelly Smith, May 2023
