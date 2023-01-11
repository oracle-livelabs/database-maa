# Database Migration

In this lab, you will prepare a response file for Database Migration , Evaluate a Database Migration and finally perform the actual Database Migration.


Estimated Time: 30 mins

**<details><summary>Task 1 - Prepare Response File </summary>**
<p>

**1. Login to ZDM Service Host.**

   Login to ZDM Service Host using Public IP and ssh key.

**2. Switch user to zdmuser.**

   Switch user to "zdmuser" using below command.

   sudo su - zdmuser
      
**3. Prepare a response file.**

   Below is sample response file which you can use for ZDM Physical Offline Migration.

   Please note that this response file uses Oracle Object Storage to keep the Source Database Backup and the Target Database is Oracle Base Database(specified as VMDB).

   

   ```console
   TGT_DB_UNIQUE_NAME=ORCL_T
   MIGRATION_METHOD=OFFLINE_PHYSICAL
   DATA_TRANSFER_MEDIUM=OSS
   HOST=https://swiftobjectstorage.uk-london-1.oraclecloud.com/v1/xxxxxxxxx
   OPC_CONTAINER=ZDM-Physical
   PLATFORM_TYPE=VMDB
   SHUTDOWN_SRC=TRUE
   ```
   Please note that we have updated values for all parameters except for HOST which is specific for your environment. 

   Use below method to prepare HOST value.

   Use the below format.

   https://swiftobjectstorage.<region_name>.oraclecloud.com/v1/<objectstorage_namespace>

   Replace "region_name" and "objectstorage_namespace" with your corresponding values.

   "objectstorage_namespace" values for your environment  was collected in Lab 8 Task 1.

   Save the response file as physical_offline.rsp file under /home/zdmuser.

</p>
</details>

**<details><summary>Task 2 - Start a Migration Evaluation </summary>**
<p>

**1. Login to ZDM Service Host.**

   Login to ZDM service host and switch the user to "zdmuser".

**2. Check the status of ZDM service.**

   export ZDM_HOME=/home/zdmuser/zdmhome

   $ZDM_HOME/bin/zdmservice status

   if the "running" shows as false then use below command to start ZDM.

   $ZDM_HOME/bin/zdmservice start

**3. Prepare command for Physical Offline Migration Evaluation.**

   Use the below sample command for ZDM Database Migration Evaluation and update it as per your environment.

   ```console
   $ZDM_HOME/bin/zdmcli migrate database  -sourcesid ORCL  -sourcenode zdm-source-db  -srcauth zdmauth  -srcarg1 user:opc  -srcarg2 identity_file:/home/zdmuser/mykey.key  -srcarg3 sudo_location:/bin/sudo  -targetnode zdm-target-db  -backupuser "oracleidentitycloudservice/xxxxxx.xxxxx@oracle.com"  -rsp /home/zdmuser/physical_offline.rsp  -tgtauth zdmauth  -tgtarg1 user:opc  -tgtarg2 identity_file:/home/zdmuser/mykey.key  -tgtarg3 sudo_location:/usr/bin/sudo -eval
   ```
   Below is a brief description of the flags used in above command.

   -backupuser             -->  Oracle Cloud tenancy user for which we have generated Auth Token in earlier Lab.

   -srcargg2 identity_file -->  location of private ssh key file which can be used to login to Source Database Server.

   -tgtarg2 identity_file  -->  location of private ssh key file which can be used to login to Target Database Server.

   -sourcenode             --> Host Name of Source Database server.

   -targetnode             --> Host Name of Target Database Server.

   -rsp                    --> Location of response file for migration.

**4. Perform Database Migration Evaluation.**

   Once you have updated the evaluation command then proceed to execute the command as below.

   ![ss1](./images/eval_start.png)

   Please provide the SYS password of Source Database and Auth token when asked.

   Also note down the Migration Job ID which is 3 in this case.

**5. Monitor the Database Migration Evaluation.**

   Check the status of Database Migration Evaluation using below command.

   $ZDM_HOME/bin/zdmcli query job -jobid 3

   here 3 is the jobid.

   You will receive a similar ouput as below.

   ![ss2](./images/eval_status.png)

   Continue to execute the status command until all phases have been completed with status "PRECHECK_PASSED" as shown below.

   ![ss3](./images/eval_final.png)

</p>
</details>

**<details><summary>Task 3 - Start Database Migration </summary>**
<p>


**1. Create HR01.EMP table in Source Database.**

   We will create a user called "HR01" and a table called "EMP" under PDB called ORCLPDB in the Source Database.

   This is to enable us to perform a quick check on the success of Database Migration.

   a. Login to Source Database Server.

   Login to Source Database using Public IP and ssh key.

   b. Login to ORCLPDB.

   Login to CDB using sqlplus and then switch to ORCLPDB using below command.

   alter session set container=ORCLPDB;

   Execute below statements
   ```console
   create user hr01 identified by "password";
   grant resource , connect to hr01;
   alter user hr01 quota unlimited on users;
   create table hr01.emp(ename varchar2(20),eno number);
   insert into hr01.emp values('Alpha',1);
   insert into hr01.emp values('Beta',2);
   commit;
   ```

   c. Verify the data in HR01.EMP table.

   Execute below statement when you are in ORCLPDB.
   ```console
   select * from hr01.emp;
   ```

   You will receive the below output.

   ![ss1](./images/source_select.png)

**2. Verify HR01.EMP table in Target Database.**

   We know that there is no HR01.EMP table in Target Database , However let's verify it.

   a. Connect to Target Database Server.

   Connect to Target Database Server using Public IP and ssh key.

   b. Connect to ORCL_PDB1.

   Connect to CDB using sqlplus and switch to ORCL_PDB1 using below command.

   alter session set container=ORCL_PDB1;

   c. Verify existence of HR01.EMP table.

   ```console
   select * from hr01.emp;
   ```

   You will receive an output similar to the one below indicating that HR01.EMP table doesn't exist in Target Database which is expected.

   ![ss2](./images/target_sel_before_migration.png)

**3. Start the Database Migration**

   We are now good to start the Database Migration.

   We can use the same command used for Database Migration Evaluation except that "-eval" flag is not required.

   **a. Login to ZDM Service Host.**

   Login to ZDM Service Host using Public IP and ssh key.

   **b. Switch user to zdmuser.**

   Switch user to "zdmuser" using below command.

   sudo su - zdmuser
   
   **c. Execute Database Migration as below.**

   ![ss3](./images/mig_start.png)

   Please provide the SYS password of Source Database and Auth token when asked.

   Also note down the Migration Job ID which is 4 in this case.
   
   **d. Monitor the Database Migration using below command.**

   $ZDM_HOME/bin/zdmcli query job -jobid 4

   You can see the JOB_TYPE is MIGRATE instead of EVAL for the Database Migration Evaluation.
      
   Continue to monitor the status until all phases have been completed with "COMPLETED" status as shown below.

**<details><summary>Task 3 - Start Database Migration </summary>**
<p>



Please [proceed to the next lab](#next).



