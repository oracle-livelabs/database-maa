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

   In this task we will create a new Virtual Cloud Network which will be used to host source database compute , target database system and ZDM service host.

1. Login to your Oracle Cloud Console.

2. Click the **Navigation Menu** in the upper left, navigate to **Networking** and then select **Virtual Cloud Networks**.
   
   ![Image showing navigation to VCN](./images/navigate-to-vcn.png " ")
 
3. Click on **Start VCN Wizard**.

   ![Image showing Start VCN Wizard](./images/start-vcn-wizard.png" ")

4. In the new small window , Select the **Create VCN with Internet Connectivity** and then click on **Start VCN Wizard**.

   ![Image showing VCN options for creation](./images/vcn-create-options.png " ")

5. In new window , under **Basic information** specify name of VCN as **ZDM-VCN** and select appropritate compartment.

   ![Image showing VCN Name prompt](./images/vcn-name-prompt.png)

6. Under **Configure VCN** , enter details as shown in image below.

   ![Image showing VCN CIDR](./images/vcn-cidr-info.png " ")
   
7. Under **Configure public subnet** , enter details as shown in image below.

   ![Image showing public subnet CIDR](./images/public-subnet-cidr.png " ")

8. Under **Configure private subnet** , enter details as shown in image below.

   ![Image showing private subnet CIDR](./images/private-subnet-cidr.png " ")

   Once details are entered , click on **Next**.

9. On the next screen , click on **Create**.

   ![Image showing VCN creation options selected](./images/vcn-summary.png " ")

10. This will take few seconds and you will receive a screen similar to the one below after completion.

   ![Image showing VCN summary after creation](./images/vcn-creation-summary.png " ")


## Task 2 : Provision Source Database

Please note that you will be provisioning source database in a Public subnet for this livelab , however it is recommended to keep your actual databases in a private subnet for better security.

1. Login to your Oracle Cloud Console.

2. Click the **Navigation Menu** in the upper left, navigate to **Marketplace** and then select **All Applications**.

     ![Image showing navigation to Marketplace](./images/navigate-to-marketplace.png " ")

3. Type **Oracle Database** in search bar.

     ![Image showing search bar for Marketplace](./images/search-marketplace.png " ")

4. Click on the listed **Oracle Database (Single Instance)** Image.

     ![Image showing Oracle Database Marketplace Image](./images/oracle-database-image.png " ")

5. Select an Oracle Database version which is latest ( There will be one on OL7 and one on OL8).
    
   We have choosen latest database version on OL7(Oracle Linux 7)  since our Target DB system will be on Oracle Linux 7.

     ![Image showing available Marketplace Database Images](./images/db-image-options.png " ")

6. Ensure to select the correct compartment in your tenancy and then click on **Launch Instance**.

   ![Image showing selection for compartment and option to Launch instance](./images/launch-instance.png)

7. On the **Create compute instance** page , Please update **Name** for compute as **zdm-source-db**.

   ![Image showing Compute instance Name Prompt](./images/compute-name-prompt.png)

    You can leave the Placement and Security section to default values as shown below.

   ![Image showing Placement and Security](./images/palcement-security.png)

    You can also leave the Image and Shape as default.

   ![Image showing compute mage and shape](./images/image-shape.png)

 8. Under **Networking** , make choices to reflect the below details.

    ![Image showing Network selection](./images/network-details.png " ")

 9. Under **Add SSH keys**.

    Browse and provide the public ssh key generated earlier.

    ![Image showing SSK key details](./images/ssh-key-upload.png " ")

10. Leave the Boot volume section to default values.

    ![Image showing Boot Volume details](./images/boot-volume.png " ")

10. Click on **Create** to start the compute provisioning.

    ![Image showing final page for compute creation](./images/compute-creation.png " ")

11. In few minutes , compute instance with database will be provisioned and running as below.

    ![Image showing provisioned compute instance](./images/compute-after-prov.png)

12. Take a note of the Public IP address of the compute instance which will be used to login to source database system.

13. Collect the value of SYS password.

    Login to the source database server using the Public IP and private ssh key.

    Please refer the value of RACPASSWORD variable in file /u01/ocidb/params.ini for SYS,SYSTEM,PDBADMIN and SYSMAN password.

    
    
You may now **proceed to the next lab**.

## Acknowledgements
* **Author** - Amalraj Puthenchira, Cloud Data Management Modernise Specialist, EMEA Technology Cloud Engineering
* **Last Updated By/Date** - Amalraj Puthenchira, April 2023

