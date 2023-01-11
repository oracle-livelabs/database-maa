# Lab 2 : Provision source database

## Introduction

Estimated Time: 30 mins

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
   
![Pic showing navigation to VCN](./images/navigate_to_vcn.png " ")
 
3. Click on "Start VCN Wizard"

![Pic showing Start VCN Wizard](./images/start_vcn_wizard.png " ")

4. In the new small window , Select the "Create VCN with Internet Connectivity" and then click on "Start VCN Wizard"

     ![Pic showing VCN options for creation](./images/vcn_create_options.png " ")

5. In new window , under Basic information specify name of VCN as ZDM-VCN and select appropritate compartment.

     ![Pic showing VCN Name prompt](./images/vcn_name_prompt.png" ")

6. Under Configure VCN and Subnets , enter details as shown in image below.

     ![Pic showing VCN and Subnet CIDR](./images/vcn_cidr_info.png " ")

Once details are entered , Click on Next

7. On the next screen , Click on Create

     ![Image showing VCN creation options selected](./images/vcn_summary.png " ")

8. This will take few seconds and you will receive a screen similar to the one below after completion.

     ![ss7](./images/vcn_creation_summary.png " ")

</details>

<details><summary>Task 2 : Provision source database </summary>

1. Login to your Oracle Cloud Console.

2. Click the Navigation Menu in the upper left, navigate to Marketplace and then select All Applications.

     ![ss1](./images/Navigate.png " ")

3. Type "Oracle Database" in search bar.

     ![ss2](./images/oracledb.png " ")

4. Click on the listed "Oracle Database (Single Instance) Image

     ![ss3](./images/oracleimage.png " ")

5. Select an Oracle Database version which is latest ( There will be one on OL7 and one on OL8)
    
   We have choosen OL7 since our Target Database DB systems have Oracle Linux 7.

     ![ss4](./images/dbver.png " ")

6. Ensure to select the correct compartment in your tenancy and then click on "Launch Instance"

     ![ss5](./images/launch.png " ")

7. On the Create compute instance page , Please update Name for Compute as ZDM-Source-DB.

     ![ss6](./images/Compute1.png " ")

    You can leave the Image and Shape as Default.

     ![ss7](./images/shape.png " ")

 8. Under Networking , Make choices to reflect the below details

     ![ss8](./images/Compute3.png " ")

 9. Under Add SSH Keys

    Browse and provide the public ssh key generated earlier.

    ![ss9](./images/Compute4.png " ")

10. Click on "Create" to start the compute provisioning.

    ![ss9](./images/Compute5.png " ")

11. In few minutes , Compute instance with database will be provisioned and running as below.
    ![ss10](./images/prov_final.png)

12. Take a note of the Public IP address of the Compute Instance which will used in later labs to access the Source Database System.

</details>

<details><summary>Acknowledgements</summary>
* **Author** - Amalraj Puthenchira, Cloud Data Management Modernise Specialist, EMEA Technology Cloud Engineering
* **Last Updated By/Date** - Amalraj Puthenchira, January 2023
</details>

