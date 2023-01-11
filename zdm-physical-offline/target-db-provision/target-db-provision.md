# Lab 3 : Provision target database

## Introduction

You must create a placeholder target database before beginning a migration to the target environment. 

The placeholder target database is overwritten during migration, but it retains the overall configuration.

For this release of Zero Downtime Migration , only Grid Infrastructure-based database services are supported as targets. For example, an LVM-based instance or an instance created in compute node without Grid Infrastructure are not supported targets.

For Exadata Cloud Service and Exadata Cloud at Customer targets, the placeholder database must be created using Control Plane, not Grid Infrastructure Database Services before database migration begins.

Estimated Time: 15 minutes

### Objectives

In this lab

* You will collect some information from source database which is necessary for target database provisioning.

* You will prepare a Database Software Image for target database.

* You will provision an Oracle Base Database VM to use as the Target Database System.

### Prerequisites

This lab assumes you have :

* Oracle Cloud Account

* All previous labs have been successfully completed.

<details><summary>Task 1 : Collect Source Database details </summary>


**1. Login to the Source Database system using the Public IP.**

   Username to login : opc 

   Use the private key generated earlier.

**2. Check the Operating System version of the Source Database.**

   Execute the below command after login in as opc.
   
   cat /etc/os-release

   Please use similar commnads in case above command doesn't work for you ( in case you have selected different Source Database System than the one specified in Lab 2)

   You will get a output similar to the one below.

   ![Image showing output of command to check OS version ](./images/os_version.png)

   Please note that Physical Offline Migration will work only for source databases with Linux based Operating System.

**3. Set the Database environment to connect to your database.**

   Switch user to Oracle using below command.

   sudo su - oracle

   Set the environment to connect to your database using below command.

   Type . oraenv and press enter 
    
   Enter ORCL when asked for ORACLE_SID and then press enter    --> Enter your DB name if that is different in case of on premise.

**4.  Check the database version of the Source Database.**

   In this livelab we have used Oracle Marketplace image for which you know the version that you have selected.

   However , In case you would like to know the database version with latest patches then please use the below command
    
   Execute 'opatch lsinventory' command as Oracle user.

   check for the output to determine the exact database version.

**5.  Check the Database Edition of the Source Database.**

   In this livelab we have used Oracle Marketplace image for Source Database which uses Oracle Database Enterprise Edition.

   However in case you would like know the Database Edition for your on premise Database then refer the below steps.

   Execute the below query after connecting to database using sqlplus.
   ```console
   select banner from v$version;
   ```
   You will receive an output similar to the one below which will have the Database Edition.

   ![Image showing Database Edition of Source database](./images/database_edition.png)

**6. Check Database characterset.**
   
   Run the below query to identify the database character set and national characterset.
   ```console
   select PARAMETER,VALUE from nls_database_parameters where parameter like '%NLS%CHARACTERSET';
   ```
   In your ouput NLS_CHARACTERSET is the database characterser and NLS_NCHAR_CHARACTERSET is the National Characterset.

   Sample output is shown below.

   ![ss3](./images/database_edition.png)

**7. Check enryption algorithm under sqlnet.ora.**

   Check the sqlnet.ora to identify any encryption algorithm mentioned.

**8. Generate patch inventory ouput.**

execute "opatch lsinventory" as oracle user in Source Database Server.

**9. Download inventory output to the Local Desktop.**

We will require this file in Task 2.

</details>

<details><summary>Task 2 : Prepare Database Software Image for Target Database</summary>

1. Navigate to Oracle Base Database.

   Click the Navigation Menu in the upper left, navigate to Oracle Database and then select Oracle Base Database.

   ![Image showing navigation to Oracle Base Database](./images/navigate_to_database.png)

2. Click on Database Software Images.

   Select the appropriate compartment and then click on "Database software images" under Resources.

   ![Image showing compartment selection ](./images/compartment.png)

3. Click "Create Database software image".

   Enter Display Name as "DBImage-Source-DB" as below.

   ![Image showing Database Software Image Name ](./images/database_image_name.png)

4. Configure Database Software Image.

   Select database version as "19c"   (Same as the Major Version of your Source Database)

   Select PSU as 19.16.0.0 ( In case you have selected different version for Source Database in Lab 2 ,then select that version )

   Upload Oracle Home Patch inventory ouput generated in Task 1 as below.

   ![Image ](./images/db_version_info.png)

5. Create Database Software Image.

   Click on "Create Database software image" to create DB Image.

   This will take some time , please proceed to next Lab.

</details>

<details><summary>Task 3 : Provision Target Database </summary>
<p>

**1. Navigate to Oracle Base Database in Oracle Console.**

   Click the Navigation Menu in the upper left, navigate to Oracle Database and then select "Oracle Base Database (VM. BM)" as shown below.

   ![ss1](./images/navigate_to_database.png)

**2. Click on the "Create DB System".**
    
   ![Image showing Create DB system option](./images/createdb.png)

**3. Provide Name of the DB System and select compartment.**

   Provide DB System name as "zdm-target-db" and ensure you have selected correct compartment for the DB system.
    
   ![Image showing the updated DB system name](./images/db_system_name.png)

**4.  Modify the shape of the DB System.**

   When you create the database from the console, ensure that your chosen shape can accommodate the source database, plus any future sizing requirements. A good guideline is to use a shape similar to or larger in size than source database.

   For this lab we will use AMD Flex with 1 OCPU.

   Click on the Change Shape and reduce the number of OCPU per node to 1 as below.

   ![Image showing the option to reduce the OCPU](./images/ocpu.png)

   Click on Select a Shape , your final selection will appear as below.

   ![Image showing final selection of DB System Shape](./images/shape.png)

**5. Configure storage.**

   Leave this section as the default.

**6. Configure Database Edition.**

   Under Configure the DB system , ensure to select "Enterprise Edition" which is the same edition as our Source DB system.

   ![Image showing the selection for Database Edition](./images/edition.png)

   
**7. Upload SSH Keys.**
   
   Under Add SSH Keys , upload the SSH Public key generated earlier.

   ![Image showing option to upload SSH key](./images/ssh.png)

**8. Select the appropriate License Type.**

   Select appropriate License Type applicable for you.

**9. Specify the Network Information.**

   Select ZDM-VCN as VCN and Public Subnet-ZDM-VCN as Client Subnet.

   Provide zdm-target-db as Hostname Prefix.

   ![Image showing the Network select for DB system](./images/network.png)

**10. Click Next**

   Click Next to go to the next page.

**11. Provide Database Name.**

   If the target database is Exadata Cloud Service or Exadata Cloud at Customer, then the database DB_NAME should be the same as the source database DB_NAME.

   If the target database is Oracle Cloud Infrastructure, then the database DB_NAME can be the same as or different from the source database DB_NAME.

   Our Target Database is Oracle Base Database and we can specify a same or different name for DB_NAME. 

   We will keep the same DB_NAME as Source Database for this lab.

   Provide "Database name" as "ORCL" and "Database unique name suffix" as "T"

   ![Image showing the Database Name entered](./images/dbname.png)

**12. Select Database Image.**

   Click on the Change Database Image and select "Custom Database Software Images " as below.

   ![Image showing selection of Database Software Image](./images/custom.png)

   Select the appropriate compartment and Select DB Image created in earlier lab as below.

   ![Image showing custom software images created earlier](./images/dbimage.png)

**13. Provide SYS password.**

   Enter SYS password which is same as the SYS password of the Source Database.

   ![Image showing the provision to enter SYS password](./images/sys.png)

**14. Select database workload type.**

   In this lab , leave it to the default.

**15. Disable Database Backups.**

   Uncheck the "Enable automatic bakcups" box to disable Database backups.

   We don't need automatic backups until we complete the database migration.

   ![Image showing the option to disable database backups](./images/backup.png)

**16. Select Database Charactetset.**

   Click on show advanced options.

   Ensure that you have selected same database and national characterset as the source database.

   In this Lab Source database has below Database and National Characterset.

   Database Characterset : AL32UTF8

   National Characterset : AL16UTF16

   Sample output is shown below.

   ![Image showing the database characterset selected](./images/charset.png)

**17. Start DB System Provisioning**

   Click on the Create DB System to initiate the DB system provisioning.

   ![Image showing the option to start the provisioning](./images/prov-final.png)

   This step is going to take an hour , however you can proceed to next lab while DB System is being provisioned.

</details>
</p>

Please [proceed to the next lab](#next).

## Acknowledgements
* **Author** - Amalraj Puthenchira, Cloud Data Management Modernise Specialist, EMEA Technology Cloud Engineering
* **Last Updated By/Date** - Amalraj Puthenchira, January 2023


