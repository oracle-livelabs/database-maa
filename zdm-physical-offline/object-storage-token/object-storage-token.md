# Database Migration

In this lab, you will create an object storage bucket and also create a token for authentication.


Estimated Time: 30 mins

**<details><summary>Task 1 - Create Object Storage Bucket </summary>**
<p>

1. Login to Oracle Cloud Console.

   Login to ZDM Service Host using Public IP and ssh key.

2. Navigate to Object Storage

   Click the Navigation Menu in the upper left, navigate to Storage and then select Buckets.

   ![ss1](./images/nav.png)

      
3. Select the Compartment.

   Select appropriate compartment on the left side.

   ![ss2](./images/Compartment.png)

4. Create Bucket

   click on "Create Bucket"

   ![ss3](./images/create.png)

   Enter Bucket Name as "ZDM-Physical"

   Leave all the defaults and click on "Create"

   ![ss4](./images/create2.png)

</p>
</details> 

**<details><summary>Task 2 - Create Auth Toaken </summary>**
<p>

We need an Auth token for the Oracle Cloud Tenancy user which will be used by ZDM to read and write from Object Storage.

1. Login to Oracle Cloud Console.

   Login to ZDM Service Host using Public IP and ssh key.

2. Navigate to User Profile.

    Click the Profile on the upper right corner of Oracle Cloud Consile and then select username which is logged in as below.

    ![ss1](./images/profile.png)

3. Navigate to Resource

   Navigate to Resource on the Left and click on Auth Tokens.

   ![ss2](./images/resources.png)

4. Create Auth Token.

   Click on Generate Token , Provide a Description for Token and Click on Generate Token as below.

   ![ss3](./images/authtoken2.png)

5. Copy the Generated Token.

   copy the generated token since it is required later in this lab.

</p>
</details>
Please *proceed to the next lab*.



