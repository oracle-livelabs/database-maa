# Create AWR reports on the standby database

## Introduction


Estimated Lab Time: 5 Minutes

### Requirements
To try this lab, you must have successfully completed the following labs:
* [Prepare the database hosts](../prepare-host/prepare-host.md)
* [Prepare the databases](../prepare-db/prepare-db.md)
* [Configure and Verify Data Guard](../configure-dg/configure-dg.md)

### Objectives
* Create two AWR snapshots
* Create an AWR report
* Review the report

## Task 1: Create two AWR snapshost

On the host where the standby database is running (adghol1), connect as SYSDBA and create an AWR snapshot:

  ```
  <copy>
  sqlplus / as sysdba
  </copy>
  ```

  ```
  <copy>
  select dbms_workload_repository.create_snapshot();
  </copy>
  ```

Before Oracle Database 23ai, it wasn't possible to create a snapshot on the standby without configuring a SYS$UMF topology. The process was cumbersome and error-prone. Oracle Database 23ai greatly simplify our task!

Wait 1-2 minutes and create another snapshot:

  ```
  <copy>
  select dbms_workload_repository.create_snapshot();
  </copy>
  ```

![Creation of two AWR snapshots](images/create-snapshots.png)

## Task 2: Create an AWR report

  ```
  <copy>
  @?/rdbms/admin/awrrpt
  </copy>
  ```

![First part of the report creation](images/awrrpt-1.png)

You will notice that the DBID list shows a different DBID for the standby database. This is because the new DBID is generated syntetically to distinguish the primary snapshots from the standby snapshots.

The DBID and SID are pre-selected by the reporting tool, so you only need to specify the number of days, and the snapshots to generate the report (1 and 2):

![Second part of the report creation](images/awrrpt-2.png)
![Third part of the report creation](images/awrrpt-3.png)

## Task 3: Review the report

  ```
  <copy>
  exit
  less awrrpt_1_1_2.txt
  </copy>
  ```

  ![The AWR report belongs to the standby database](images/view-report.png)
  

You have successfully created AWR reports for the standby database. This concludes the Data Guard overview workshop.

Well done!

- **Author** - Ludovico Caldara, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn
- **Last Updated By/Date** -  Ludovico Caldara, June 2024
