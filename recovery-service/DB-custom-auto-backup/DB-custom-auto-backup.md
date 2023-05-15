# Real-time Oracle Database protection with Autonomous Recovery Service

## Introduction

This lab shows you how to customize automatic backups for the Oracle Database with Autonomous Recovery Service as the backup destination.  The initial default backup configuration to Autonomous Recovery Service was completed to save time during the lab.

Estimated Time: 5 minutes

### Objectives

In this lab, you will:
* Create a custom protection policy
* Customize Automatic Backups for Base Database Service and enable real-time protection

## Task 1: Create a custom Protection Policy

1. Navigate to Database Backups
    ![Image alt text](images/Ham_database_DBBackups.png)

2. Select Protection Policies from the left menu
    ![Image alt text](images/Recovery_Service_Protection_Policy_menu.png)

3. Click the Create protection policy button
    ![Image alt text](images/create_protection_policy_button.png)

4. Enter the following information to create a protection policy
    * Name: Any name you would like to use to identify the policy
    * Compartment:  The compartment being used
    * Backup retention period (in days): Enter the number of days to retain the backup

5. Click the Create button
    ![image alt text](images/create_button.png)

## Task 2: Customize the Automatic Backup configuration for Base Database Service

1. Navigate to Base Database Service
    ![Image alt text](images/Ham_Base_Database.png)

2. Click on your database system name

3. Click on your database name under the Databases section

4. In the button bar at the top click the Configure automatic backups button
    ![image alt text](images/Config_auto_backups_button.png)

5. You can customize the automatic backups for this database
    * Backup scheduling (UTC): Select a time window to run backups from the drop-down menu
    * Backup Destination: Keep the selection for Autonomous Recovery Service from the drop-down menu
    * Protection policy: Select the custom protection policy created in the previous lab
    * Select the Real-time data protection box
    * Deletion options after database termination: Select how to manage backups after the database is terminated

6. Click the Save changes button

## Task 3: Monitor the database update

1. The update task will appear under Resources | Work requests in the lower left of the database details page. 
     Note: it may take 10-20 seconds to appear.
    ![image alt txt](images/Update_database.png)

2. The update will complete in approximately 5 minutes and the state will show Succeeded.
    ![image alt text](images/Update_database_completed.png)

## Learn More

* [Back Up a Database Using the Console](https://docs.oracle.com/en/cloud/paas/bm-and-vm-dbs-cloud/dbbackupoci/index.html)


## Acknowledgements
* **Author** - Kelly Smith, Product Manager, Backup & Recovery Solutions
* **Last Updated By/Date** - Kelly Smith, May 2023
