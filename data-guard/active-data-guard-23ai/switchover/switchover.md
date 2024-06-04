# Perform a switchover

## Introduction
This lab is not required for the subsequent labs and it leaves the situation unaltered. Therefore, you can skip it if you want to concentrate on the next labs.

In this lab, we will execute a switchover to swap the roles between the primary and the standby databases.

The switchover operation will terminate the work on the current primary database, flush all the redo to the standby database, which will perform a final, complete recover before opening as the new primary database. When the new primary database successfully opens, the former primary is restarted as a physical standby database, keeping the new primary database protected.

The broker automates all the aspects of a Data Guard topology, including setting up the redo transport, coordinating switchovers and failovers, monitoring the lags, etc.

For more information about the switchover operation, refer to the [Switchover and Failover Operations documentation](https://docs.oracle.com/en/database/oracle/oracle-database/23/dgbkr/using-data-guard-broker-to-manage-switchovers-failovers.html#GUID-44E7A982-7CD4-4A51-B00E-62C0698C5CD6)

Estimated Lab Time: 5 Minutes

### Requirements
To try this lab, you must have successfully completed:
* Lab 1: Prepare the database hosts
* Lab 2: Prepare the databases
* Lab 3: Configure and Verify Data Guard

### Objectives
- Run the validation command
- Execute the Switchover
- Switch back to the first node

## Task 1: Run the validation command

1. Connect to the Data Guard broker using the primary's DGConnectIdentifier. Don't forget to change the command with the actual connect identifier:

  ```
  <copy>
dgmgrl sys/WElcome123##@ADGHOL0_DGCI
  </copy>
  ```

2. Validate the readiness of the standby database with the `VALIDATE DATABASE STRICT ALL` command. Again, change ADGHOL1_UNIQUE_NAME with the actual db_unique_name. It should show **Ready for Switchover: Yes**

  ```
  <copy>
show configuration
validate database ADGHOL1_UNIQUE_NAME strict all
  </copy>
  ```

  ![Successful validation of the standby database](images/validate.png)

## Task 2: Execute the Switchover

1. Execute the switchover to the standby database:

  ```
  <copy>
set time on
switchover to ADGHOL1_UNIQUE_NAME
  </copy>
  ```

  ![Successful execution of the switchover command](images/switchover.png)

1. The `show configuration` command should show the new situation (the primary database is now the one running on `adghol1`):

  ```
  <copy>
show configuration
  </copy>
  ```

  ![New configuration ofter the switchover](images/show-configuration.png)


## Task 3: Switch back to the first node

1. Move the primary role back to the database on host `adghol0` so that the next labs will work properly.

  ```
  <copy>
validate database ADGHOL0_UNIQUE_NAME strict all
switchover to ADGHOL0_UNIQUE_NAME
  </copy>
  ```

  ![Successful validation of the standby database](images/validate2.png)
  ![Successful execution of the switchover command](images/switchover2.png)


You have successfully tested a switchover operation.

## Acknowledgements

- **Author** - Ludovico Caldara, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn
- **Last Updated By/Date** -  Ludovico Caldara, June 2024

  
