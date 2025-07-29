# Customize automatic backups for the Base Database

## Introduction

This lab shows you how to customize automatic backups for the Oracle Database with Autonomous Recovery Service as the backup destination.  The initial default backup configuration to Autonomous Recovery Service was completed to save time during the lab.

Estimated Time: 10 minutes

### Objectives

In this lab, you will:
* Create a custom protection policy
* Customize Automatic Backups for Base Database Service with real-time protection

## Task 1: Create a custom Protection Policy

1. Navigate to Database Backups
    ![OCI menu to Database Backups](images/ham_database_dbbackups.png)

2. Select the compartment provided in your Login Info
    ![OCI drop down selection for compartments](images/select_compartment.png)

3. Select Protection Policies from the left menu
    ![OCI menu showing protection policies](images/recovery_service_protection_policy_menu.png)

4. Click the Create protection policy button
    ![Button to create a protection policy](images/create_protection_policy_button.png)

5. Enter the following information to create a protection policy
    * Name: Any name you would like to use to identify the policy
    * Compartment:  The compartment being used
    * Backup retention period (in days): Enter the number of days to retain the backup
    * Enable retention lock: Locks the retention of the backups so no one can reduce backup retention time. (Scheduled lock time must be 14 days in the future)

6. Click the Create button
    ![Button to complete the policy creation](images/create_button.png)

## Task 2: Customize the Automatic Backup configuration for Base Database Service

1. Navigate to Base Database Service
    ![OCI menu to Base Database Service](images/ham_basedb2.png)

2. Click on your database system under Display name

3. Click on the Databases tab
    ![Menu tab to list databases](images/tab_basedb_databases.png)

4. Click on your database name

5. Under the Actions drop-down menu select Configure automatic backups
    ![Drop-down selection to configure automatic backups](images/config_auto_backups_button.png)

6. You can customize the automatic backups for this database
    * Backup Destination: Keep the selection for Autonomous Recovery Service from the drop-down menu
    * Protection policy: Select the custom protection policy created in the previous lab
    * Be sure the selection for **Real-time data protection is checked**
    * Deletion options after database termination: Select how to manage backups after the database is terminated
    * Backup scheduling (UTC): Select a time window to run backups from the drop-down menu

7. Click the Save changes button

## Task 3: Monitor the database update

1. The update task will appear under the Work requests tab in the top right of the database details page. 
    > **Note:** it may take 10-20 seconds to appear.
    ![Status dialog for work requests](images/update_database.png)

2. The update will complete in approximately 5 minutes and the state will show Succeeded.  You can proceed to the next task while this update is being completed.  The database icon on the left will turn green when the work is completed.
    ![Status dialog showing completed database update](images/update_database_completed.png)

## Task 4: Review the Backup information on the database page

* Under the Backup section above review the information available for the database backup.
    * Health - The health will change state if there are issues with the backups for the database.  Issue details will be displayed by hoovering over the 'i'.
    * Data loss exposure - This is the amount of time since the database was protected by a backup.  Since real-time protection is enabled this value will be 0 seconds since the database is under constant protection.
    * Last failed backup - shows any backup that has failed for the entire protection window defined in the policy
    * Next scheduled backup - shows when the time window for the next backup
    * Space used for recovery - shows the amount of space used for backup of this database, which is also the amount of space used for billing
    * Backup destination - links to the details of the Autonomous Recovery Service
    * Real-time data protection - shows if the database is being protected in real-time
    * Protection policy - shows the name of the protection policy being used for this database

## Learn More

* [Creating a Protection Policy](https://docs.oracle.com/en-us/iaas/recovery-service/doc/create-protection-policy.html#GUID-C73E254E-2019-4EDA-88E0-F0BA68082A65)
* [Back Up a Database Using the Console](https://docs.oracle.com/en/cloud/paas/bm-and-vm-dbs-cloud/dbbackupoci/index.html)
* [Documentation for Zero Data Loss Autonomous Recovery Service](https://docs.oracle.com/en/cloud/paas/recovery-service/dbrsu/)


## Acknowledgements
* **Author** - Kelly Smith, Product Manager, Backup & Recovery Solutions
* **Last Updated By/Date** - Kelly Smith, July 2025
