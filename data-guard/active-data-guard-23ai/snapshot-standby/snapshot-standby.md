# Test Your Deployments with Snapshot Standby

## Introduction

A Data Guard standby database is not just there to protect your data. You can use it for maintenance (by switching over the primary workload to the secondary site while you do the maintenance on the primary site), or you can temporarily open your standby database in read/write mode to test changes on a copy of the primary database.
This capability is called **snapshot standby**.
Data Guard allows you to transition from physical standby to a snapshot standby with a single command.
The modifications made to the snapshot standby are automatically reverted by flashing back the database when it is converted back to a physical standby.
This functionality can be useful for testing:
* application deployments
* structural changes (e.g. new indexes)
* new patches or even new versions

Estimated Lab Time: 5 Minutes

### Requirements
To try this lab, you must have successfully completed the following labs:
* [Prepare the database hosts](../prepare-host/prepare-host.md)
* [Prepare the databases](../prepare-db/prepare-db.md)
* [Configure and Verify Data Guard](../configure-dg/configure-dg.md)
* [Create role-based services](../create-services/create-services.md)

### Objectives
* Convert the physical standby to a snapshot standby
* Change some data
* Convert back to physical standby

## Task 1: Convert the physical standby to a snapshot standby

Connect with **dgmgrl** and convert the standby database to a snapshot standby. Don't forget to replace ADGHOL1_UNIQUE_NAME with the actual db_unique_name of the standby database.

  ```
  <copy>
dgmgrl sys/WElcome123##@ADGHOL0_DGCI
  </copy>
  ```
  ```
  <copy>
show configuration
set time on
convert database ADGHOL1_UNIQUE_NAME to snapshot standby
  </copy>
  ```

  ![The conversion to snapshot standby succeeds](images/convert-to-snapshot-standby.png)

The conversion stops the apply process on the standby database, creates a guaranteed restore point, and opens it in read write mode.

While the database is in snapshot standby mode, it keeps receiving the redo from the primary database, keeping it protected.

After the conversion, the configuration reports the new role.

  ```
  <copy>
show configuration
  </copy>
  ```

  ![Show configuration reports "Snapshot Standby database" for the standby database](images/show-configuration-snapshot.png)


## Task 2: Open the PDB and change some data

1. Connect to the standby database:
  ```
  <copy>
  sql sys/WElcome123##@ADGHOL1_DGCI as sysdba
  </copy>
  ```

1. Open the PDB:
  ```
  <copy>
  alter pluggable database mypdb open;
  </copy>
  ```

1. Connect to the snapshot standby service:
  ```
  <copy>
  connect tacuser/WElcome123##@mypdb_snap
  </copy>
  ```

  ```
  <copy>
desc t
drop table t;
create table this_wasnt_there (a varchar2(50));
insert into this_wasnt_there values ('Let''s do some tests!');
commit;
exit
  </copy>
  ```

  ![The DDL and DML statements work on the standby database](images/modify-snapshot-standby.png)
  

## Task 3: Convert back to physical standby

  ```
  <copy>
dgmgrl sys/WElcome123##@ADGHOL0_DGCI
show configuration
set time on
convert database ADGHOL1_UNIQUE_NAME to physical standby
show configuration
  </copy>
  ```

  ![The conversion to physical standby succeeds](images/convert-to-snapshot-standby.png)

The conversion to physical standby closes the standby database, flashes it back to the previously created restore point, and start the apply process again.

- **Author** - Ludovico Caldara, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn
- **Last Updated By/Date** -  Ludovico Caldara, June 2024
