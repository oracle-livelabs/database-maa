# Source Database Provisioning

In this lab, you will provision a source database using Oracle Marketplace image available in Oracle Cloud Infrastructure.

Estimated Time: 30 mins
## Task 1 - Create new Virtual Cloud Network

In this task we will create a new VCN which will be used to host Source Database Compute , Target DB systema and ZDM Service Host.

1. Login to your Oracle Cloud Console.

2. Click the Navigation Menu in the upper left, navigate to Networking and then select Virtual Cloud Networks
   
     ![ss1](./images/task1navigate.png " ")
 
3. Click on "Start VCN Wizard"

     ![ss2](./images/Task1_VCNWizard.png " ")

4. In the new small window , Select the "Create VCN with Internet Connectivity" and then click on "Start VCN Wizard"

     ![ss3](./images/Task1_VCNWizard2.png " ")

5. In new window , under Basic information specify name of VCN as ZDM-VCN and select appropritate compartment.

     ![ss4](./images/Task1_VCNWizard3.png " ")

6. Under Configure VCN and Subnets , enter details as shown in image below.

     ![ss5](./images/Task1_VCNWizard4.png " ")

Once details are entered , Click on Next

7. On the next screen , Click on Create

     ![ss6](./images/Task1_VCNWizard5.png " ")

8. This will take few seconds and you will receive a screen similar to the one below after completion.

     ![ss7](./images/Task1_VCNWizard6.png " ")



## Task 2 - Provision Source Database.

1. Login to your Oracle Cloud Console.

2. Click the Navigation Menu in the upper left, navigate to Marketplace and then select All Applications.

     ![ss1](./images/Navigate.png " ")

3. Type "Oracle Database" in search bar.

     ![ss2](./images/oracledb.png " ")

4. Click on the listed "Oracle Database (Single Instance) Image

     ![ss3](./images/oracleimage.png " ")

5. Select an Oracle Database version which is latest ( You will same latest version on OL7 and OL8)
    
   We have choosen OL7 since we would like to match the target OS as close as possible.

     ![ss4](./images/dbver.png " ")

6. Ensure to select the correct compartment in your tenancy and then click on "Launch Instance"

     ![ss5](./images/launch.png " ")

7. On the Create compute instance page , Please update Name for Compute.

     ![ss6](./images/Compute1.png " ")

    You can leave the Image and Shape as Default.

     ![ss7](./images/shape.png " ")

 8. Under Networking , Make choices to reflect the below details

     ![ss8](./images/Compute3.png " ")

 9. Under Add SSH Keys

    Browse and provide the ssh key generated earlier.

    ![ss9](./images/Compute4.png " ")

10. Click on "Create" to start the compute provisioning.

    ![ss9](./images/Compute5.png " ")

11. In Few minutes , Compute instance with database will be provisioned and running as below.
    ![ss10](./images/prov_final.png)

12. Take a note of the Public IP address of the Compute Instance which will used in later labs to access the Source Database System.







## Learn More

* [Oracle Zero Downtime Migration - Product Page](http://www.oracle.com/goto/zdm)
* [Oracle Zero Downtime Migration - Product Documentation](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/)
* [Oracle Zero Downtime Migration - Logical Migration Step by Step Guide](https://www.oracle.com/a/tech/docs/oracle-zdm-logical-migration-step-by-step-guide.pdf)
* [Oracle Zero Downtime Migration - Physical Migration Step by Step Guide](https://www.oracle.com/a/tech/docs/oracle-zdm-step-by-step-guide.pdf)



## Acknowledgements
* **Author** - Amalraj Puthenchira, Cloud Data Management Modernise Specialist, EMEA Technology Cloud Engineering
* **Contributors** - LiveLabs Team, ZDM Development Team
* **Last Updated By/Date** - Ricardo Gonzalez, January 2022


[def]: ./images/task1navigate.png