# Real-time Oracle Database protection with Autonomous Recovery Service

## Introduction

This lab shows you how to configure automatic backups for the Oracle Database with Autonomous Recovery Service as the backup destination.  

Estimated Time: 10 minutes

### Objectives

In this lab, you will:
* Configure Automatic Backups for Base Database Service with real-time protection enabled
* Monitor for backup completion

## Task 1: Configure Automatic Backups for Base Database Service

1. Navigate to Base Database Service
    ![Image alt text](images/Ham_Base_Database.png)

2. Click on your database system name

3. Click on your database name under the Databases section

4. In the button bar at the top click the Configure automatic backups button
    ![image alt text](images/Config_auto_backups_button.png)

5. Enter the following information to Configure automatic backups
    * Select the Enable automatic backups box
    * Backup scheduling (UTC): Select a time window to run backups from the drop-down menu
    * Backup Destination: Select Autonomous Recovery Service from the drop-down menu
    * Protection policy: Select the custom protection policy create in the previous lab
    * Select the Real-time data protection box
    * Deletion options after database termination: Select how to manage backups after the database is terminated

6. Click the Save changes button

## Learn More

* [Back Up a Database Using the Console](https://docs.oracle.com/en/cloud/paas/bm-and-vm-dbs-cloud/dbbackupoci/index.html)


## Acknowledgements
* **Author** - Kelly Smith, Product Manager, Backup & Recovery Solutions
* **Last Updated By/Date** - Kelly Smith, May 2023
