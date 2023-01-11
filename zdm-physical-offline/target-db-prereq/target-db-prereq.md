# Target Database Prerequisites

In this lab, you will check Target database to identify whether it meets prerequistes for ZDM Physical Offline Database Migration.

Whenever required you will be provided with steps or guidance to make necessary modification in Target Database to meet the prerequisites.


Estimated Time: 30 mins

**1. Login to Target Database Server.**

   Login to Target Database server using Public IP and ssh key.

**2. Set the environment for the database.**

   Switch user to "oracle" using below command.

   sudo su - oracle

   Set the environment to connect to your database.

   Type . oraenv and press enter 
    
   Enter ORCL when asked for ORACLE_SID and then press enter    --> Enter your DB name if that is different than the one used in this lab.

   
**3. Check whether Target Database is using spfile.**

   Run "show parameter spfile" in database.

   If you get a similar output as below which means spfile is configured, if this is not the case then please configure spfile using Oracle Docs.

   ![ss1](./images/spfile.png)

**4. Verify Time Zone version.**

   The target placeholder database must have a time zone file version that is the same or higher than the source database. 
   
   If that is not the case, then the time zone file should be upgraded in the target placeholder database.

   To check the current time zone version, query the V$TIMEZONE_FILE view as shown here, and upgrade the time zone file if necessary.
   ```console
   SELECT * FROM v$timezone_file;
   ```   
   Sample output is shown below.
   
   ![ss2](./images/timezone.png)

**5. Verify TDE Wallet Folder.**

   All Oracle PaaS Databases in OCI have TDE enabled by default including the one that we have used in this lab.

   However , if You used any IaaS database as Target Database then use the below procedure to check TDE status.

   Verify that the TDE wallet folder exists, and ensure that the wallet STATUS is OPEN and WALLET_TYPE is AUTOLOGIN (For an auto-login wallet type), or WALLET_TYPE is PASSWORD (For a password-based wallet). For a multitenant database, ensure that the wallet is open on all PDBs as well as the CDB, and the master key is set for all PDBs and the CDB.

   Execute the below SQL.
   ```console
   set lines 120
   col WRL_PARAMETER for a50
   select WRL_TYPE,WRL_PARAMETER,STATUS,WALLET_TYPE from v$encryption_wallet;   
   ```
   Sample output is shown below.

   ![ss3](./images/tde.png)

**6. Check Disk Group Size.**

   Check the size of the disk groups and usage on the target database (ASM disk groups or ACFS file systems) and make sure adequate storage is provisioned and available on the target database servers.

  You can ignone this step in this lab since the size of Source Database configured is less than 10 GB and we have allocated the minimum of 256 GB for Target Database.

**7. Check connections.**

   Verify that port 22 on the target servers in the Oracle Cloud Infrastructure, Exadata Cloud Service, or Exadata Cloud at Customer environment are open and not blocked by a firewall.

   We had already checked this by doing ssh from ZDM host in earlier lab (ZDM Host Provisioning and Configuration)

**8. Capture RMAN SHOW ALL command.**

   Capture "SHOW ALL" RMAN output so that you can compare RMAN settings after the migration, then reset any changed RMAN configuration settings to ensure that the backup works without any issues.

**9. Ensure System time of Target Database, Source Database and ZDM host are in sync (Optional Step).**

   Type "date" across Source Database , Target Database and ZDM host simultaneously and see whether they show the same time.

   It is recommended to have same time across all system but it is not mandatory.

   Please use NTP in case you need to adjust time.

**10. Check encryption algorithm in SQLNET.ORA (Optional Step).**

   Ensure that encryption algorithm specificed in sqlnet.ora in Target Database Oracle Home is same as Source Database Home.

   This is not mandatory for ZDM Physical Offline Migration , However it is recommended.

Please [proceed to the next lab](#next).



