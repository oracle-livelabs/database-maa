# Provision source database

## Introduction

Estimated Time: 15 minutes

### Objectives

In this lab

* You will provision a Virtual Cloud Network in Oracle Cloud Infrastructure.
* You will provision source database using Oracle Marketplace image available in Oracle Cloud Infrastructure.

### Prerequisites

* All previous labs have been successfully completed.

## Task 1 : Create Virtual Cloud Network

   In this task you will create a new Virtual Cloud Network which will be used to host source database compute , target database system and ZDM service host.

1. Login to your Oracle Cloud Console.

2. Click the **Navigation Menu** in the upper left, navigate to **Networking** and then select **Virtual Cloud Networks**.
   
   ![Image showing navigation to VCN](./images/navigate-to-vcn.png " ")
 
3. Click on **Start VCN Wizard**.

   ![Image showing Start VCN Wizard](./images/start-vcn-wizard.png" ")

4. In the new small window , Select the **Create VCN with Internet Connectivity** and then click on **Start VCN Wizard**.

   ![Image showing VCN options for creation](./images/vcn-create-options.png " ")

5. In new window , under **Basic information** specify VCN Name as **ZDM-VCN** and select appropritate compartment.

   ![Image showing VCN Name prompt](./images/vcn-name-prompt.png)

6. Under **Configure VCN and Subnets** , enter details as shown in image below.

   ![Image showing VCN and Subnet CIDR](./images/vcn-cidr-info.png " ")

   Once details are entered , click on **Next**.

7. On the next screen , click on **Create**.

   ![Image showing VCN creation options selected](./images/vcn-summary.png " ")

8. This will take few seconds and you will receive a screen similar to the one below after completion.

   ![Image showing VCN summary after creation](./images/vcn-creation-summary.png " ")


## Task 2 : Provision Source Database

1. Login to your Oracle Cloud Console.

2. Click the **Navigation Menu** in the upper left, navigate to **Marketplace** and then select **All Applications**.

     ![Image showing navigation to Marketplace](./images/navigate-to-marketplace.png " ")

3. Type **Oracle Database** in search bar.

     ![Image showing search bar for Marketplace](./images/search-marketplace.png " ")

4. Click on the listed **Oracle Database (Single Instance)** Image.

     ![Image showing Oracle Database Marketplace Image](./images/oracle-database-image.png " ")

5. Select an Oracle Database version which is latest ( There will be one on OL7 and one on OL8).
    
   Please choose database on Oracle Linux 7 since your Target DB system will be on Oracle Linux 7 for this lab.

     ![Image showing available Marketplace Database Images](./images/db-image-options.png " ")

   Please make a note of the exact database version with Release Update since it will be required in next Lab.

6. Ensure to select the correct compartment in your tenancy and then click on **Launch Instance**.

   ![Image showing selection for compartment](./images/compartment.png)

7. On the **Create compute instance** page , Please update **Name** for compute as **ZDM-Source-DB**.

   ![Image showing Compute instance Name Prompt](./images/compute-name-prompt.png)

    You can leave the Image and Shape as default.

   ![Image showing compute mage and shape](./images/image-shape.png)

 8. Under **Networking** , please enter details as shown below.

    ![Image showing Network selection](./images/network-details.png " ")

 9. Under **Add SSH keys**.

    Browse and provide the public ssh key generated in Lab 1.

    ![Image showing SSK key details](./images/ssh-key-upload.png " ")

10. Click on **Create** to start the compute provisioning.

    ![Image showing final page for compute creation](./images/compute-creation.png " ")

11. In few minutes , compute instance with database will be provisioned and running as below.
    ![Image showing provisioned compute instance](./images/prov-final.png)

12. Take a note of the Public IP address of the compute instance which will used to login to source database system.

13. Modify the SYS user password on Source Database.

    Please note that we need to use same Source Database SYS password for the Target database provisioning (Lab 3).

    Current SYS user password (refer RACPASSWORD variable in /u01/ocidb/params.ini file) can't be used for Target database provisioning since it doesn't meet the password complexity of Target database service.

    Please follow below procedure to change SYS user password of Source Database.

    a. Establish connection to source database.
      
      Please follow below steps to establish connection to source database using SQLPLUS.

      Login to source database server using Public IP and ssh key.

      Switch user to **oracle** using below command.

      **sudo su - oracle**

      Set the environment to connect to your database.

      Type **. oraenv** and press **Enter**. 
    
      Enter **ORCL** when asked for **ORACLE\_SID** and then press **Enter** (Enter your ORACLE\_SID if that is different from ORCL).

      Type **sqlplus "/as sysdba"**  and press **Enter** to connect to source database as SYS user.

      Please find below snippet of the connection steps.

     ![Image showing sqlplus connection to source cdb](./images/source-cdb-connection.png)
     
    b. Modify the SYS password.     
     
      Execute below statement on the source database connection already established using previous step.

    ```text
     <copy>
     alter user SYS identified by Your_Password 
     </copy>
     ```
     Below is the sample output.

      ![Image showing output of sys password change command on source](./images/sys-password-change.png)
   
     Please note that you need to provide a password that meets below criteria.
      
     The password must be 9 to 30 characters and contain at least two uppercase, two lowercase, two numeric, and two special characters.
    
     The special characters must be _, #, or -.
    
     The password must not contain the user name (SYS, SYSTEM, and so on) or the word "oracle" either in forward or reversed order and regardless of casing.
    
    
You may now **proceed to the next lab**.

## Acknowledgements
* **Author** - Amalraj Puthenchira, Cloud Data Management Modernise Specialist, EMEA Technology Cloud Engineering
* **Last Updated By/Date** - Amalraj Puthenchira, March 2023

