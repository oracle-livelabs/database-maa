# Perform Point-in-time restores

## Introduction

This lab shows you how to recover from malicious behavior.  Notice that the automatic backups configured for this Oracle Database with Autonomous Recovery Service as the backup destination uses real-time protection.  This means that database transactions are being protected as they occur on the database, so you can easily go back to the point just before the malicious behavior to recover the database without having to worry about when the last backup happened.

Estimated Time: 15 minutes

### Objectives

In this lab, you will:
* Connect to the Oracle Database
* Create data in the Oracle Database
* Maliciously destroy Oracle Database data
* Perform a point-in-time recovery using the SCN just prior to the malicious activity

## Task 1: Get the details for your database node

1. Navigate to Oracle Base Database Service
    ![OCI menu to Base Database Service](images/ham_basedb.png)

2. Click on your database system under Display name

3. Click the Nodes tab
    ![Nodes tab selection](images/basedb_tab_nodes.png)

4. Copy the Public IP address
    ![Table showing all the node details](images/basedb_public_ip.png)


## Task 2: Connect to the database, create a table and insert data

1. Open OCI Cloud Shell by clicking the drop-down in the top right
    ![Launch point location for Cloud Shell](images/cloud_shell_button.png)
    
2. Click Close if a prompt appears regarding processor type.

3. Type N to exit out of the Cloud Shell tutorial.

4. Download and unzip this [SSH key](https://objectstorage.us-ashburn-1.oraclecloud.com/p/pFCXNoopaTHpNpK2n1eyvnzzVi4bcDGN5wCf7ZJA-Le-BwUnsibXb1SQT-VdPF9x/n/c4u04/b/events/o/id_rsa_livelabs.zip)

5. Upload the SSH private key by clicking the gear in the top right of the cloud shell
    ![Launch point location for cloud shell upload](images/cloud_shell_upload.png)

6. Change the permissions on the uploaded key file
    ```
    <copy>chmod 600 <private_key_file> </copy>
    ```

7. SSH into the host using the follow command:
    ```
    <copy>ssh -i <private_key_file> opc@<public-ip-address> </copy>
    ```

8. Change user to Oracle:
    ```
    $ <copy>sudo su - oracle</copy>  
    ```
9. Connect to the database:
    ```
    $ <copy>sqlplus / as sysdba</copy> 
    ```

10. Create a table for customers:
    ```
    SQL> <copy>create table customer(first_name varchar2(50));</copy>
    ```
11. Insert new customers:
    ```
    SQL> <copy>INSERT INTO customer (first_name) 
            WITH names AS (
                SELECT 'Andrew' FROM dual UNION ALL
                SELECT 'Bob' FROM dual UNION ALL
                SELECT 'Mike' FROM dual
            )
            SELECT * FROM names;</copy>
    ```
    ```
    SQL> <copy>commit;</copy>
    ```

12. Query to see the customer names:
    ```
    SQL> <copy>select * from customer;</copy>
    ```
    
13. Capture the SCN for the database before being malicious.  
* Note: This SCN will be used later in the lab.
    ```
    SQL> <copy>Select CURRENT_SCN as BEFORE_DELETE from v$database;</copy>
    ```

## Task 3: Be malicious and destroy data!

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

4. Force delete all the logs, backups, controlfiles and datafiles from the disk
    ```
    $ <copy>cd /u03/app/oracle/</copy>
    ```
    ```
    $ <copy>find . \( -name "*.log" -o -name "*.arc" -o -name "*.bkp" -o -name "*.ctl" \) -delete</copy>
    ```
    ```
    $ <copy>cd /u02/app/oracle/oradata</copy>
    ```
    ```
    $ <copy>find . \( -name "*.ctl" -o -name "*.dbf" \) -delete</copy>
    ```

## Task 4: Recover the database to the point before the malicious behavior

1. Navigate to Oracle Base Database Service
    ![OCI menu for Base Database Service](images/ham_basedb.png)

2. Click on your database system under Display name

3. Click on the Databases tab
    ![Button to list databases](images/tab_basedb_databases.png)

3. Click on your database name

4. Under the Actions drop-down menu select Restore
    ![Drop-down selection to restore](images/basedb_actions_restore.png)

5. Select Restore to SCN in the Restore Database dialog
    ![Restore to SCN dialog](images/basedb_restore_dialog.png)

6. Enter the SCN captured from BEFORE_DELETE in Task 2, Step 13 above

7. Click Restore

8. The restore will take approximately 10 minutes and you can track progress under the Work requests at the bottom left
    ![Work request table](images/work_request_restore.png)

9. You can continue to the next lab and return after the restore is complete.  After the restore is complete query the customer table:
    ```
    <copy>sqlplus / as sysdba</copy>
    ```
    ```
    <copy>select * from customer;</copy>
    ```


## Learn More

* [Recovering a Database](https://docs.oracle.com/en-us/iaas/recovery-service/doc/recovering-database.html#GUID-6E88692E-FCFA-4CFE-844C-00A79E8D079B)
* [Documentation for Zero Data Loss Autonomous Recovery Service](https://docs.oracle.com/en/cloud/paas/recovery-service/dbrsu/)


## Acknowledgements
* **Author** - Kelly Smith, Product Manager, Backup & Recovery Solutions
* **Last Updated By/Date** - Kelly Smith, July 2025
