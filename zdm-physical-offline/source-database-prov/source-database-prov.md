# Lab 2 : Provision source database

## Introduction

Estimated Time: 15 minutes

### Objectives

In this lab

* You will provision a Virtual Cloud Network.
* You will provision source database using Oracle Marketplace image available in Oracle Cloud Infrastructure.

### Prerequisites

This lab assumes you have :

* Oracle Cloud Account

* All previous labs have been successfully completed.

<details><summary>Task 1 : Create Virtual Cloud Network </summary>

In this task we will create a new Virtual Cloud Network which will be used to host Source Database Compute , Target Database System and ZDM Service Host.

1. Login to your Oracle Cloud Console.

2. Click the Navigation Menu in the upper left, navigate to Networking and then select Virtual Cloud Networks
   
   ![Image showing navigation to VCN](./images/navigate_to_vcn.png " ")
 
3. Click on "Start VCN Wizard"

   ![Image showing Start VCN Wizard](./images/start_vcn_wizard.png " ")

4. In the new small window , Select the "Create VCN with Internet Connectivity" and then click on "Start VCN Wizard"

   ![Image showing VCN options for creation](./images/vcn_create_options.png " ")

5. In new window , under Basic information specify name of VCN as ZDM-VCN and select appropritate compartment.

   ![Image showing VCN Name prompt](./images/vcn_name_prompt.png)

6. Under Configure VCN and Subnets , enter details as shown in image below.

   ![Image showing VCN and Subnet CIDR](./images/vcn_cidr_info.png " ")

Once details are entered , Click on Next

7. On the next screen , Click on Create

   ![Image showing VCN creation options selected](./images/vcn_summary.png " ")

8. This will take few seconds and you will receive a screen similar to the one below after completion.

   ![Image showing VCN summary after creation](./images/vcn_creation_summary.png " ")

</details>

<details><summary>Task 2 : Provision source database </summary>

1. Login to your Oracle Cloud Console.

2. Click the Navigation Menu in the upper left, navigate to Marketplace and then select All Applications.

     ![Image showing navigation to Marketplace](./images/navigate_2_marketplace.png " ")

3. Type "Oracle Database" in search bar.

     ![Image showing search bar for Marketplace](./images/search_marketplace.png " ")

4. Click on the listed "Oracle Database (Single Instance) Image

     ![Image showing Oracle Database Marketplace Image](./images/oracle_database_image.png " ")

5. Select an Oracle Database version which is latest ( There will be one on OL7 and one on OL8)
    
   We have choosen OL7 since our Target Database DB systems have Oracle Linux 7.

     ![Image showing available Marketplace Database Images](./images/db_image_options.png " ")

6. Ensure to select the correct compartment in your tenancy and then click on "Launch Instance"

   ![Image showing selection for compartment](./images/compartment.png)

7. On the Create compute instance page , Please update Name for Compute as ZDM-Source-DB.

   ![Image showing Compute instance Name Prompt](./images/compute_name_prompt.png)

    You can leave the Image and Shape as Default.

   ![Image showing compute mage and shape](./images/image_shape.png)

 8. Under Networking , Make choices to reflect the below details

    ![Image showing Network selection](./images/network_details.png " ")

 9. Under Add SSH Keys

    Browse and provide the public ssh key generated earlier.

    ![Image showing SSK key details](./images/ssh_key_upload.png " ")

10. Click on "Create" to start the compute provisioning.

    ![Image showing final page for compute creation](./images/compute_creation.png " ")

11. In few minutes , Compute instance with database will be provisioned and running as below.
    ![Image showing provisioned compute instance](./images/prov_final.png)

12. Take a note of the Public IP address of the Compute Instance which will used in later labs to access the Source Database System.

</details>

You may now **proceed to the next lab**.

## Acknowledgements
* **Author** - Amalraj Puthenchira, Cloud Data Management Modernise Specialist, EMEA Technology Cloud Engineering
* **Last Updated By/Date** - Amalraj Puthenchira, January 2023

