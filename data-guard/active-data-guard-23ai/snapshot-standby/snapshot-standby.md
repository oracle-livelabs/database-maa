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
* [Configure Data Guard](../configure-dg/configure-dg.md)
* [Verify the Data Guard configuration](../verify-dg/verify-dg.md)
* [Create role-based services](../create-services/create-services.md)

### Objectives
* Convert the physical standby to a snapshot standby
* Change some data
* Convert back to physical standby

## Task 1: Convert the physical standby to a snapshot standby

1. From a terminal (**the host is irrelevant**), connect with `dgmgrl` and convert the standby database to a snapshot standby.

    ```
    <copy>
    dgmgrl sys/WElcome123##@adghol0_dgci
    </copy>
    ```
    **Don't forget to replace `ADGHOL1_UNIQUE_NAME` with the actual `db_unique_name` of the standby database.**
    ```
    <copy>
    show configuration
    convert database ADGHOL1_UNIQUE_NAME to snapshot standby
    </copy>
    ```

    ![The conversion to snapshot standby succeeds](images/convert-to-snapshot-standby.png)

    Note, we don't use SQLcl for the conversion, because the command `CONVERT DATABASE` isn't yet integrated in SQLcl.
    The conversion stops the apply process on the standby database, creates a guaranteed restore point, and opens it in read write mode.

    While the database is in snapshot standby mode, it keeps receiving the redo from the primary database, keeping it protected.

2. After the conversion, the configuration reports the new role.

    ```
    <copy>
    show configuration
    exit
    </copy>
    ```

    ![Show configuration reports "Snapshot Standby database" for the standby database](images/show-configuration-snapshot.png)


## Task 2: Open the PDB, connect to the snapshot standby service, and change some data

1. Connect to the standby database.
    ```
    <copy>
    sql sys/WElcome123##@adghol1_dgci as sysdba
    </copy>
    ```

2. Open the PDB:
    ```
    <copy>
    alter pluggable database mypdb open;
    </copy>
    ```

3. Connect to the snapshot standby service. The service is started by the startup trigger only when the PDB is in a snapshot standby role.
    ```
    <copy>
    connect tacuser/WElcome123##@mypdb_snap
    </copy>
    ```
    The user `tacuser` has been created during the lab *Transparent Application Continuity*. If you don't have tried it, you can copy the instructions to create the user from there.
    ```
    <copy>
    create table this_wasnt_there (a varchar2(50));
    insert into this_wasnt_there values ('Let''s do some tests!');
    commit;
    exit
    </copy>
    ```

    ![The DDL and DML statements work on the standby database](images/modify-snapshot-standby.png)
  

## Task 3: Convert back to physical standby

1. Connect to either the primary or the standby database with `dgmgrl` and convert the standby database back to the physical standby role. **Again, replace `ADGHOL1_UNIQUE_NAME` with the correct name**.
    ```
    <copy>
    dgmgrl sys/WElcome123##@adghol0_dgci
    show configuration
    convert database ADGHOL1_UNIQUE_NAME to physical standby
    show configuration verbose
    exit
    </copy>
    ```

    ![The conversion to physical standby succeeds](images/convert-to-snapshot-standby.png)

    The conversion to physical standby closes the standby database, flashes it back to the previously created restore point, and start the apply process again.
    If the `show configuration verbose` reports a warning, try to run it again, as the standby might take some seconds to start receiveing redo from the primary.

You have successfully tested a snapshot standby database.

- **Author** - Ludovico Caldara, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn
- **Last Updated By/Date** -  Ludovico Caldara, July 2024
