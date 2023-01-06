# Source Database Configuration

In this lab, you will configure source database for Physical Offline Migration.


Estimated Time: 30 mins

**<details><summary>Task 1 - Configure Source Database </summary>**
<p>

1. Login to Source Database Server.

   Login to Source Dataabse server using Public IP and ssh key.

2. Set the environment for the database.

   Switch user to Oracle

   sudo su - oracle

   Set the environment to connect to your database.

   Type . oraenv and press enter 
    
   Enter ORCL when asked for ORACLE_SID and then press enter    --> Enter your DB name if that is different in case of on premise.

   
3. Check whether Source Database is using spfile.

   Run "show parameter spfile" in database.

   If you get a similar output as below which means spfile is configured, if this is not the case then please configure spfile using Oracle Docs.

   ![ss1](./images/spfile.png)

4. Ensure System time of Source Database, Target Database and ZDM host are in sync.

   Type "date" across Source Database , Target Database and ZDM host simultaneously and see whether they show the same time.

   It is recommended to have same time across all system but it is not mandatory.

   Please use NTP in case you need to adjust time.

5. Check the compatible parameter on Source Database.

   Execute "show parameter compatible" on Source and Target Database and ensure they are set to same value.

   If you find that compatible parameter on Target Database can't be modified since it is already on the maximum possible value then you can change the compatoible parameter in source database.

   Please note that changing compatible parameter can't be reversed unlesss you restore the entire database backup, so plan accordingly.

6. Enable Database Archivelog mode.

   Source Database must be running in ARCHIVELOG mode.

   See https://docs.oracle.com/pls/topic/lookup?ctx=en/database/oracle/zero-downtime-migration/21.3/zdmug&id=ADMIN-GUID-C12EA833-4717-430A-8919-5AEA747087B9 if you need help.

7. Configure TDE Wallet.

   For Oracle Database 12c Release 2 and later, if the source database does not have Transparent Data Encryption (TDE) enabled, then it is mandatory that you configure the TDE wallet before migration begins. You need not encrypt the data in the source database; the data is encrypted at target using the wallet setup in the source database. The WALLET_TYPE can be AUTOLOGIN (preferred) or PASSWORD based.

   Ensure that the wallet STATUS is OPEN and WALLET_TYPE is AUTOLOGIN (For an AUTOLOGIN wallet type), or WALLET_TYPE is PASSWORD (For a PASSWORD based wallet type). For a multitenant database, ensure that the wallet is open on all PDBs as well as the CDB, and the master key is set for all PDBs and the CDB.

   1. Let's check the status of encryption in our Source Database.

   Execute below sql.

   SELECT * FROM v$encryption_wallet;

   In the source database that you configured in the lab , TDE is not setup and the below query output shows that.

   ![ss2](./images/tde.png)

   Follow the below steps to enable TDE.

   2. Set ENCRYPTION_WALLET_LOCATION in the $ORACLE_HOME/network/admin/sqlnet.ora file.

      Insert the below line in sqlnet.ora (Ensure to update the correct ORACLE_HOME for you)

      ENCRYPTION_WALLET_LOCATION=(SOURCE=(METHOD=FILE)(METHOD_DATA=(DIRECTORY=/u01/app/oracle/product/19c/dbhome_1/network/admin/)))

      For an Oracle RAC instance, also set ENCRYPTION_WALLET_LOCATION in the second Oracle RAC node.
   
   3. Create and configure the keystore.

   a. Connect to the database and create the keystore.

   Modify the sql to update your ORACLE_HOME before executing.
   ```console
   $ sqlplus "/as sysdba"
   SQL> ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/u01/app/oracle/product/19c/dbhome_1/network/admin'
   identified by password;
   ```
   b. Open the keystore.

   For a CDB environment (Source Database in this lab is CDB ), run the following command.

   ```console
   SQL> ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY password container = ALL;
      keystore altered.
```
   For a non-CDB environment, run the following command.
   ```console
   SQL> ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY password;
   keystore altered.
```
   c. Create and activate the master encryption key.


      

5. 

   

   Click the Navigation Menu in the upper left, navigate to Compute and then select Instances.

   ![ss](./images/nav.png)

2. Select Compartment.

   Select the appropriate compart on the left side of the console.

   ![ss1](./images/comp.png)

3. Click on "Create Instance"

   ![ss2](./images/Start.png)

4. Enter Name for Compute

   Enter zdm-host as Name for Compute and select appropriate compartment if it is not already done.

   ![ss3](./images/host.png)

5. Leave the Placement section as it is.

6. Select correct image

   Under Image and Shape , click on Change image

   ![ss4](./images/image1.png)

   Select Oracle Linux 7.9 and click on "Select Image"

   ![ss5](./images/image2.png)

7. Select VCN and Subnet

   Under Networking , Select ZDM-VCN as VCN and Public Subnet-ZDM-VCN as Subnet.

   ![ss6](./images/network.png)

8. Upload SSH Keys

   Under Add SSH Keys , upload the public ssh key generated earlier.

   ![ss7](./images/ssh.png)

9. Specify custom boot volume

   Under boot volume , select "Specify a custom boot volume size" and specify 150.

   ![ss8](./images/boot.png)
10. Click on Create to start the provisioning of Compute.

    In less than few minutes ZDM compute host will be provisioned.

</p>
</details>

**<details><summary>Task 2 - Configure ZDM Service </summary>**
<p>

1. Login to ZDM host using the Public IP and ssh key file.

![ss1](./images/ip.png)

2. Expand the root FS

   Execute below command as opc and press y and Enter when asked.

   sudo /usr/libexec/oci-growfs

   You will see an output similar to the one below.

![ss2](./images/fs.png)

3. Check the existence of required packages for ZDM.

   ZDM software requires below packages to be installed.

   glibc-devel

   expect

   unzip

   libaio

   oraclelinux-developer-release-el7

   Execute the below command to identify already installed packages.

   yum list installed glibc-devel expect unzip libaio oraclelinux-developer-release-e17

   You will receive an output similar to the one below which shows glibc=devel, libaio and expect are alraady installed.

   ![ss3](./images/pkg_preinstalled.png)

4. Install missing packages

   We have seen that expect package is missing as per previous step output.

   Install the missing packakges using commands below.

   sudo yum install -y expect

   Sample output is shown below.

![ss4](./images/expect.png)

5. Create User, Group and Directories required for ZDM.

   Switch to root user.

   sudo su -

   Execute below commands.

   groupadd zdm
   useradd -g zdm zdmuser
   mkdir -p /home/zdmuser/zdminstall
   mkdir /home/zdmuser/zdmhome
   mkdir /home/zdmuser/zdmbase
   chown -R zdmuser:zdm /home/zdmuser
6. Download ZDM software 

   Download the ZDM software from below URL.

   https://www.oracle.com/database/technologies/rac/zdm-downloads.html

7. Upload ZDM software to ZDM host.

   Upload the software to /tmp in ZDM host.

   Ensure that all users can read the .zip file.

8. Unzip the ZDM software

   Switch user to "zdmuser"

   sudo su - zdmuser
   
   Unzip the ZDM software under /tmp directory.

   notedown the path of unzipped folder.

   It will be /tmp/zdm21.3 for ZDM 21.3

9. Install ZDM software

   Change directory to ZDM unzipped location

   cd /tmp/zdm21.3
   
   Execute the below command to install ZDM software.

   ./zdminstall.sh setup oraclehome=/home/zdmuser/zdmhome oraclebase=/home/zdmuser/zdmbase ziploc=/tmp/zdm21.3/zdm_home.zip -zdm

   This will take couple of minutes.

   You will see output as below when it has completed ZDM service setup.

   ![ss5](./images/zdmservice.png)

10. Start ZDM service

    Navigate to ZDM Home 

    cd /home/zdmuser/zdmhome/bin

    Execute below command to start ZDM.

    ./zdmservice start

    You will receive similar output as below once ZDM has been successfully started.

    ![ss6](./images/service_start.png)

11. Check ZDM service status.

    Execute below command to see the ZDM servive status.

    ./zdmservice status

    Sample output is given below.

    ![ss7](./images/service_status.png)

</p>
</details>

**<details><summary>Task 3 - Configure connectivity from ZDM host to Source and Target DB sytem </summary>**
<p>

1. Add Source and Target Database Details

   We have to first collect Source and Target Private IP and FQDN from the console.

   a. Navigate to Source Database Compute instance.

   ![ss1](./images/nav_compute.png)

   Click on the ZDM-Source-DB compute host.

   Note down the private IP and FQDN under Primary VNIC section.

   ![ss2](./images/VNIC.png)

   b. Navigate to Target Database System as below.

   ![ss3](./images/nav_target_db.png)

   Click on ZDM-Target-DB

   Click on Nodes under Resources section and note down the private IP and FQDN.

   ![ss4](./images/Target_IP.png)
   
   c. Edit /etc/hosts in ZDM host to add Source and Target Database System IP and FQDN details collected in previous steps.

   Sample output after editing is shown below.

   ![ss5](./images/zdm_etc.png)

2. Copy the SSH private key to ZDM host

   Copy the ssh private key generated in earlier step to ZDM host under zdmuer home.

   Change the permission of private key as below.

   chmod 600 mykey.key

3. Verify SSH connectivity from ZDM to Source and Target DB system.

   Execute the below command to test the ssh connectivity.

   ssh -i <key_file_name> opc@zdm-source-db

   ssh -i <key_file_name> opc@zdm-target-db

   You will be able to login to Source and Target if the connectivity is sucessful as shown below.

   ![ss6](./images/ssh_login.png)

</p>
</details>
Please *proceed to the next lab*.



