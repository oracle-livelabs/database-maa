# Target Database Prerequsites

In this lab, you will check Target database to identify whether it meets prerequistes for Physical Offline Database Migration.

Whenever required you will do the necessary modification in Target database to meet the prerequisites.


Estimated Time: 30 mins

**<details><summary>Task 1 - Target Database Prerequisite Check</summary>**
<p>

1. Login to Target Database Server.

   Login to Source Dataabse server using Public IP and ssh key.

2. Set the environment for the database.

   Switch user to Oracle

   sudo su - oracle

   Set the environment to connect to your database.

   Type . oraenv and press enter 
    
   Enter ORCL when asked for ORACLE_SID and then press enter    --> Enter your DB name if that is different than the one used in this lab.

   
3. Check whether Target Database is using spfile.

   Run "show parameter spfile" in database.

   If you get a similar output as below which means spfile is configured, if this is not the case then please configure spfile using Oracle Docs.

   ![ss1](./images/spfile.png)

4. Ensure System time of Target Database, Source Database and ZDM host are in sync.

   Type "date" across Source Database , Target Database and ZDM host simultaneously and see whether they show the same time.

   It is recommended to have same time across all system but it is not mandatory.

   Please use NTP in case you need to adjust time.

5. Check encryption algorithm in SQLNET.ORA

   Ensure that encryption algorithm specificed in sqlnet.ora in Target Database Oracle Home is same as Source Database Home.

   This is not mandatory for Physical Offline Migration , However it is recommended.

6. Verify Time Zone version.

  The target placeholder database must have a time zone file version that is the same or higher than the source database. If that is not the case, then the time zone file should be upgraded in the target placeholder database.

  To check the current time zone version, query the V$TIMEZONE_FILE view as shown here, and upgrade the time zone file if necessary.
  ```console
  SELECT * FROM v$timezone_file;
  ```

  Sample output is shown below.
  ![ss2](./images/timezone.png)

7. Verify TDE Wallet Folder.

   Verify that the TDE wallet folder exists, and ensure that the wallet STATUS is OPEN and WALLET_TYPE is AUTOLOGIN (For an auto-login wallet type), or WALLET_TYPE is PASSWORD (For a password-based wallet). For a multitenant database, ensure that the wallet is open on all PDBs as well as the CDB, and the master key is set for all PDBs and the CDB.

   Execute the below SQL.
   ```console
   set lines 120
   col WRL_PARAMETER for a50
   select WRL_TYPE,WRL_PARAMETER,STATUS,WALLET_TYPE from v$encryption_wallet;   
   ```
   Sample output is shown below.

   ![ss3](./images/tde.png)

8. Check Disk Group Size.

   Check the size of the disk groups and usage on the target database (ASM disk groups or ACFS file systems) and make sure adequate storage is provisioned and available on the target database servers.

   In this lab you can ignone this since we have taken care of this step while proviosioning the Target Database.

9. Check connections.

   Verify that port 22 on the target servers in the Oracle Cloud Infrastructure, Exadata Cloud Service, or Exadata Cloud at Customer environment are open and not blocked by a firewall.

   We had already checked this by doing ssh from ZDM host in earlier lab.

10. Capture RMAN SHOW ALL command

    Capture output so that you can compare RMAN settings after the migration, then reset any changed RMAN configuration settings to ensure that the backup works without any issues.


</p>
</details>
Please *proceed to the next lab*.



