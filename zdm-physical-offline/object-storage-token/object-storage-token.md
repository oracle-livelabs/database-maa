# Creation of Object Storage Bucket and Auth Token.

In this lab, you will create an object storage bucket and also a Auth token for authentication.


Estimated Time: 10 minutes

**<details><summary>Task 1 - Create Object Storage Bucket </summary>**
<p>

1. Login to Oracle Cloud Console.

2. Navigate to Object Storage.

   Click the Navigation Menu in the upper left, navigate to Storage and then select Buckets.

   ![ss1](./images/nav.png)

      
3. Select the Compartment.

   Select appropriate compartment on the left side.

   ![ss2](./images/Compartment.png)

4. Create Bucket.

   Click on "Create Bucket"

   ![ss3](./images/create.png)

   Enter Bucket Name as "ZDM-Physical"

   Leave all the defaults and click on "Create".

   ![ss4](./images/create2.png)

5. Collect the Object Storage NameSpace.

   Check the Namespace details under the Object Storage Bucket.

   ![ss5](./images/namespace.png)

</p>
</details> 

**<details><summary>Task 2 - Create Auth Token </summary>**
<p>

We need an Auth token for the Oracle Cloud Tenancy user which will be used by ZDM to read and write from Object Storage.

1. Login to Oracle Cloud Console.
   
2. Navigate to User Profile.

   Click the Profile on the upper right corner of Oracle Cloud Console and then select username which is logged in as below.

   ![ss1](./images/profile.png)

3. Navigate to Resource.

   Navigate to Resource on the Left and click on Auth Tokens.

   ![ss2](./images/resources.png)

4. Create Auth Token.

   Click on Generate Token , provide a description for Token and click on Generate Token as below.

   ![ss3](./images/authtoken2.png)

5. Copy the generated Token.

   Copy the generated token since it is required later for migration.

</p>
</details>

Please [proceed to the next lab](#next).



