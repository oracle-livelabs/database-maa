# Lab 7 : Create Object Storage Bucket and Auth Token.

## Introduction

Estimated Time: 10 minutes

### Objectives

In this lab

* You will create an object storage bucket .

* You will create an Auth token for authentication.

### Prerequisites

This lab assumes you have :

* Oracle Cloud Account

* All previous labs have been successfully completed.

<details><summary>Task 1 : Create Object Storage Bucket </summary>
<p>

1. Login to Oracle Cloud Console.

2. Navigate to Object Storage.

   Click the Navigation Menu in the upper left, navigate to Storage and then select Buckets.

   ![Image showing navigation to object storage bucket](./images/navigation_to_oss.png)

      
3. Select the Compartment.

   Select appropriate compartment on the left side.

   ![Image showing compartment selection](./images/compartment.png)

4. Create Bucket.

   Click on "Create Bucket"

   ![Image showing create bucket option](./images/create_bucket.png)

   Enter Bucket Name as "ZDM-Physical"

   Leave all the defaults and click on "Create".

   ![Image showing bucket name and create option](./images/create_bucket_final.png)

5. Collect the Object Storage NameSpace.

   Check the Namespace details under the Object Storage Bucket.

   ![Image showing object storage namespace](./images/namespace.png)

</p>
</details> 

<details><summary>Task 2 : Create Auth Token </summary>
<p>

We need an Auth token for the Oracle Cloud Tenancy user which will be used by ZDM to read and write from Object Storage Bucket.

1. Login to Oracle Cloud Console.
   
2. Navigate to User Profile.

   Click the Profile on the upper right corner of Oracle Cloud Console and then select username which is logged in as below.

   ![Image showing navigation to user profile](./images/user_profile.png)

3. Navigate to Resource.

   Navigate to Resource on the Left and click on Auth Tokens.

   ![Image showing Auth Token under resources](./images/resources_auth_token.png)

4. Create Auth Token.

   Click on Generate Token , provide a description for Token and click on Generate Token as below.

   ![Image showing description for auth token](./images/authtoken_description.png)

5. Copy the generated Token.

   Copy the generated token since it is required later for migration.

</p>
</details>

You may please [proceed to the next lab](#next).

## Acknowledgements
* **Author** - Amalraj Puthenchira, Cloud Data Management Modernise Specialist, EMEA Technology Cloud Engineering
* **Last Updated By/Date** - Amalraj Puthenchira, January 2023


