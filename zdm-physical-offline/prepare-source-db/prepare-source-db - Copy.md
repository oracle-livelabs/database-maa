# Prepare source database

## Introduction

Estimated Time: 15 minutes

### Objectives

In this lab

* You will check source database to identify whether it meets the prerequistes for ZDM Physical Offline Database Migration.

* You will perform necessary steps to modify source database when required so that it meets the migration prerequisites.

### Prerequisites

* All previous labs have been successfully completed.

## Task 1 : Prepare Source Database

**1. Login to source database server.**

   Login to source database server using Public IP and ssh key.

**2. Set the environment for the database.**

   Switch user to "oracle" using below command.

   sudo su - oracle

   Set the environment to connect to your database.

   Type . oraenv and press enter 
    
   Enter ORCL when asked for ORACLE\_SID and then press enter    --> Enter your DB name if that is different in case of on premise.

**3. Check whether source database is using spfile.**

   Connect to source database using sqlplus.

   Execute "show parameter spfile".

   If you get a similar output as below which means spfile is configured, if this is not the case then please configure spfile using Oracle Documents.

   ![Image showing output of spfile check](./images/spfile.png)

**4. Check the compatible parameter on source database.**

   In this livelab compatible parameter on both source and target database have already been set to 19.0.0 , so no action is required.

   However in case you have provisioned source and target database using any other method not used in this lab , then use the below procedure.

   Execute "show parameter compatible" on source and target database and ensure they are set to same value.

   If you find that compatible parameter on target database can't be modified since it is already on the maximum possible value then you can change the compatible parameter in source database.

   Please note that changing compatible parameter can't be reversed unlesss you restore the entire database backup, so plan accordingly for your production source databases.

**5. Enable database archivelog mode.**

   This migration requires source database must be running in ARCHIVELOG mode.

   However source database we have provisioned in this livelab is not running in ARCHIVELOG mode by default. 

   Please follow below document and enable ARCHIVELOG mode.

   See https://docs.oracle.com/pls/topic/lookup?ctx=en/database/oracle/zero-downtime-migration/21.3/zdmug&id=ADMIN-GUID-C12EA833-4717-430A-8919-5AEA747087B9.


**6. Configure TDE Wallet.**

   For Oracle Database 12c Release 2 and later, if the source database does not have Transparent Data Encryption (TDE) enabled, then it is mandatory that you configure the TDE wallet before migration begins. You need not encrypt the data in the source database; the data is encrypted at target using the wallet setup in the source database. The WALLET_TYPE can be AUTOLOGIN (preferred) or PASSWORD based.

   Ensure that the wallet STATUS is OPEN and WALLET\_TYPE is AUTOLOGIN (For an AUTOLOGIN wallet type), or WALLET\_TYPE is PASSWORD (For a PASSWORD based wallet type). 
   
   For a multitenant database, ensure that the wallet is open on all PDBs as well as the CDB, and the master key is set for all PDBs and the CDB.

   Let's check the status of encryption in your source database.

   Execute below sql.
   ```console
   <copy>
   SELECT * FROM v$encryption_wallet;
   </copy>
   ```
   In the source database that you configured in this lab , TDE is not setup and the below query output shows that.

   ![Image showing TDE status of source database](./images/source-tde-status.png)

   Follow the below steps to enable TDE.

   **a . Set "ENCRYPTION\_WALLET\_LOCATION" in the $ORACLE_HOME/network/admin/sqlnet.ora file.**

   Insert the below line in sqlnet.ora (Ensure to update the correct ORACLE_HOME of your source database).   
   ```text
   <copy>
   ENCRYPTION_WALLET_LOCATION=(SOURCE=(METHOD=FILE)(METHOD_DATA=(DIRECTORY=/u01/app/oracle/product/19c/dbhome_1/network/admin/)))
   </copy>
   ```
   For an Oracle RAC instance, also set "ENCRYPTION_WALLET_LOCATION" in the second Oracle RAC node (Not applicable for the source database provisioned in this lab)
   
   **b. Create and configure the keystore.**

   i. Connect to the database and create the keystore.

   Modify the below sql to update your source database ORACLE_HOME and TDE password before executing.
   ```console
   <copy>
   ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/u01/app/oracle/product/19c/dbhome_1/network/admin' identified by password;
   </copy>
   ```
   ii. Open the keystore.

   For a CDB environment (source database in this lab is CDB ),  run the following command (ensure to update password).
   ```console
   <copy>
   ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY password container = ALL;
   </copy>
   ```
   For a non-CDB environment, run the following command.
   ```console
   <copy>
   ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY password;
   </copy>
   ```
   iii. Create and activate the master encryption key.

   For a CDB environment, run the following command (ensure to update the password)
   ```console
   <copy>
   ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY password with backup container = ALL;
   </copy>
   ```
   For a non-CDB environment, run the following command.
   ```console
   <copy>
   ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY password with backup;
   </copy>
   ```
   iv. Query V$ENCRYPTION_WALLET to get the keystore status, keystore type, and keystore location.
   ```console
   <copy>
   col WRL_PARAMETER for a55
   set lines 150
   select WRL_TYPE,WRL_PARAMETER,STATUS,WALLET_TYPE from v$encryption_wallet;
   </copy>
   ```

   You will see that keystore is enabled with status OPEN and WALLET_TYPE as PASSWORD in the query output below which means configuration of password-based keystore is complete at this stage.

   ![Image showing status of password based keystore](images/tde-password.png)

   We will use an auto-login keystore in this lab and for that we need to complete additional steps as mentioned below.
   
   **c. Creation of auto-login keystore.**
   
   i. Create the auto-login keystore.

   Execute below statement after replacing ORACLE_HOME and password for your environment.

   ```console
   <copy>
   ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE '/u01/app/oracle/product/19c/dbhome_1/network/admin/' IDENTIFIED BY password;
   </copy>
   ```
   ii. Close the password-based keystore.

   Execute the below statement after replacing password to close the password-based keystore created earlier.
   ```console
   <copy>
   ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE IDENTIFIED BY password;
   </copy>
   ```
   iii. Query V$ENCRYPTION_WALLET to get the keystore status, keystore type, and keystore location.

   Execute below statement
   ```console
   <copy>
   col WRL_PARAMETER for a55
   set lines 150
   select WRL_TYPE,WRL_PARAMETER,STATUS,WALLET_TYPE from v$encryption_wallet;
   </copy>
   ```
   In the query output, verify that the TDE keystore STATUS is OPEN and WALLET_TYPE set to AUTOLOGIN, otherwise the auto-login keystore is not set up correctly.
   Sample output is shown below.
   ![Image showing auto login keystore status](./images/tde-autologin.png)

   **d. Copy the keystore files to the second Oracle RAC node.**

   This is not applicable for the source database used in this lab.

   However follow the below steps in case you have RAC source database.

   If you configured the keystore in a shared file system for Oracle RAC then no action is required.

   If you are enabling TDE for Oracle RAC database without shared access to the keystore, copy the following files to the same location on second node.

   /u01/app/oracle/product/19c/dbhome_1/network/admin/ew*

   /u01/app/oracle/product/19c/dbhome_1/network/admin/cw*

**7. Snapshot controlfile for RAC Database.**

   This is not applicable for the source database that you have provisioned in this lab, However if you have RAC source database then follow below steps.

   If the source is an Oracle RAC database, and SNAPSHOT CONTROLFILE is not on a shared location, configure SNAPSHOT CONTROLFILE to point to a shared location on all Oracle RAC nodes to avoid the ORA-00245 error during backups to Oracle Object Store.

   ```
   <copy>
   $ rman target /  
   RMAN> CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+DATA/db_name/snapcf_db_name.f';
   </copy>
   ```
**8. Controlfile auto backup.**

   Source database you have configured in this lab has controlfile autobackup on by default.

   If RMAN is not already configured to automatically back up the control file and SPFILE, then set CONFIGURE CONTROLFILE AUTOBACKUP to ON and revert the setting back to OFF after migration is complete.

   ```console
   <copy>
   RMAN> CONFIGURE CONTROLFILE AUTOBACKUP ON;
   </copy>
   ```
**9. Register database with srvctl.**

   If the source database is deployed using Oracle Grid Infrastructure and the database is not registered using SRVCTL, then you must register the database before the migration.

   This is not applicable for the source database provisioned in this lab since it is not using Grid Infrastructure.

**10. RMAN backup strategy.**

   There is no existing RMAN backup strategy for the source database that we have configured in this lab , so this can be ignored.

   However if your source database has existing RMAN backups then follow below procedure.

   To preserve the source database Recovery Time Objective (RTO) and Recovery Point Objective (RPO) during the migration, the existing RMAN backup strategy should be maintained.

   During the migration a dual backup strategy will be in place; the existing backup strategy and the strategy used by Zero Downtime Migration.

   Avoid having two RMAN backup jobs running simultaneously (the existing one and the one initiated by Zero Downtime Migration).

   If archive logs were to be deleted on the source database, and these archive logs are needed by Zero Downtime Migration to synchronize the target cloud database, then these files should be restored so that Zero Downtime Migration can continue the migration process.

   
**11. Ensure system time of source database, target database and ZDM host are in sync(Optional Step).** 

   Type "date" across source database , target database and ZDM host simultaneously and see whether they show the same time.

   It is recommended to have same time across all systems but it is not mandatory.

   Please use NTP in case you need to adjust time.

You have successfully completed source database preparation steps.

You may now **proceed to the next lab**.

## Acknowledgements
* **Author** - Amalraj Puthenchira, Cloud Data Management Modernise Specialist, EMEA Technology Cloud Engineering
* **Last Updated By/Date** - Amalraj Puthenchira, January 2023


