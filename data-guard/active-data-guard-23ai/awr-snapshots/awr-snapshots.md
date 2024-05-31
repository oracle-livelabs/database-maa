# Create AWR reports on the standby database

## Introduction


Estimated Lab Time: 2 Minutes

### Requirements
To try this lab, you must have successfully completed the following labs:
* [Prepare the database hosts](../prepare-host/prepare-host.md)
* [Prepare the databases](../prepare-db/prepare-db.md)
* [Configure and Verify Data Guard](../configure-dg/configure-dg.md)
* [Create role-based services](../create-services/create-services.md)

### Objectives
* Create two AWR snapshots
* Create an AWR report

## Task 1: Create two AWR snapshost

In a window, connect with **dgmgrl** and convert the standby database to a snapshot standby. Don't forget to replace ADGHOL1_UNIQUE_NAME with the actual db_unique_name of the standby database.

  ```
  <copy>
  </copy>
  ```

## Task 2: Create an AWR report

1. Connect to the snapshot standby service:
  ```
  <copy>
sql tacuser/WElcome123##@mypdb_snap
  </copy>
  ```

  ![The DDL and DML statements work on the standby database](images/modify-snapshot-standby.png)
  

You have successfully created AWR reports for the standby database. This concludes the Data Guard overview workshop.

- **Author** - Ludovico Caldara, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn
- **Last Updated By/Date** -  Ludovico Caldara, December 2023
