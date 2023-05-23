# Real-time Oracle Database protection with Autonomous Recovery Service

## Introduction

This lab shows you how to recover from malicious behavior.  Note that the configured automatic backups for the Oracle Database with Autonomous Recovery Service as the backup destination with real-time protection.  This means that database transactions are being protected as they occur on the database, so you can easily go back to the point just before the malicious behavior to recover the database without having to worry about when the last backup happened.

Estimated Time: TBD minutes

### Objectives

In this lab, you will:
* Alter data in the Oracle Database
* Perform a point-in-time recovery using the SCN just prior to the data alteration

## Task 1: Create a table and insert data

1. Navigate to Database node details
    ![image alt text](images/Ham_policies.png)

2. Get the public IP address of the system
    ![image alt text](images/create_policy_button.png)

3. SSH into the host using the follow commnand:
    ```
    <copy>ssh -i <private_key_file> opc@<public-ip-address> </copy>
    ```

4. Change user to Oracle:
    ```
    $ <copy>sudo su - oracle</copy>  
    ```
5. Connect to the database:
    ```
    $ <copy>sqlplus / as sysdba</copy> 
    ```

6. Create a table for customers:
    ```
    SQL> <copy>create table customer(first_name varchar2(50));</copy>
    ```
7. Insert new customers:
    ```
    SQL> <copy>INSERT INTO customer (first_name) 
            WITH names AS (
                SELECT 'Andrew' FROM dual UNION ALL
                SELECT 'Bob' FROM dual UNION ALL
                SELECT 'Mike' FROM dual
            )
            SELECT * FROM names;</copy>
    ```

5. Query to see the customer names:
    ```
    SQL> <copy>select * from customer;</copy>
    ```

6. Capture the SCN for the database before being malicious:
    ```
    SQL> <copy>Select CURRENT_SCN as BEFORE_DELETE from v$database;</copy>
    ```

## Task 2: Be malicious and destroy data!

1. Drop the table
    ```
    SQL> <copy>drop table customer;</copy>
    ```
    ```
    SQL> <copy>commit;</copy>
    ```

2. Query the customer table to see that it is gone:
    ```
    SQL> <copy>select * from customer;</copy>
    ```

3. Force a database shutdown
    ```
    SQL> <copy>SHUTDOWN ABORT</copy>
    SQL> <copy>exit</copy>
    ```

5. Force delete all the logs, backups, controlfiles and datafiles from the disk
    ```
    $ cd /u03/app/oracle/
    $ <copy>find . \( -name "*.log" -o -name "*.arc" -o -name "*.bkp" -o -name "*.ctl" \) -delete</copy>
    $ cd /u02/app/oracle/oradata
    $ <copy>find . \( -name "*.ctl" -o -name "*.dbf" \) -delete</copy>
    ```

## Task 3: Recover the database to the point before the malicious behavior

1. Restore the database using the SCN from BEFORE_DELETE in step 6 above.
    Restore is under work request
    Restore will take about 10 minutes

2. After the restore is complete query the customer table:
    ```
    sqlplus / as sysdba
    select * from customer;
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
