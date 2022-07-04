# How to Perform Database Failover

## Introduction
In this lab, we will be performing a switchover operation.

Oracle Data Guard helps you change the role of databases between primary and standby using either a switchover or failover operation.

A switchover is a role reversal between the primary database and one of its standby databases. A switchover guarantees no data loss and is typically done for planned maintenance of the primary system. During a switchover, the primary database transitions to a standby role, and the standby database transitions to the primary role.
When working with the OCI console, a switchover is always started from the primary database.

A failover is a role transition in which one of the standby databases is transitioned to the primary role after the primary database (all instances in the case of an Oracle RAC database) fails or has become unreachable.
A failover may or may not result in data loss depending on the protection mode in effect at the time of the failover.
When working with the OCI console, a failover is started from the standby database that will become primary.

Estimated Lab Time: 15 Minutes

Watch the video below for a quick walk through of the lab.

[](youtube:9KUo95KhnVQ)

### Objectives
- Verify the database roles in the database
- Perform a failover

### Prerequisites
- Connect to the Database
- Perform a switchover

## Task 1: Verify the database roles in the database
1. From the **first browser tab** with Cloud Shell, connect to the primary host (skip this step if you are still connected from the previous lab):
    ````
    <copy>ssh -i cloudshellkey opc@IP_ADDRESS</copy>
    ````
    Replace `cloudshellkey` with the name of your private key file, and `IP_ADDRESS` with the real public IP address.

2. You should be connected to the primary database host. You can become **oracle** with `sudo su - oracle` and connect to the instance with the command `sqlplus / as sysdba` and execute a query:

    ````
    <copy>Select name, db_unique_name, database_role from v$database;</copy>
    ````

  ![](../switchover/images/new-standby.png)

1. From the **second browser tab** with Cloud Shell, connect to the standby host (skip this step if you are still connected from the previous lab):
    ````
    <copy>ssh -i cloudshellkey opc@IP_ADDRESS</copy>
    ````
    Replace `cloudshellkey` with the name of your private key file, and `IP_ADDRESS` with the real public IP address.

2. You should be connected to the primary database host. You can become **oracle** with `sudo su - oracle` and connect to the instance with the command `sqlplus / as sysdba` and execute a query:

    ````
    <copy>Select name, db_unique_name, database_role from v$database;</copy>
    ````
  ![](../switchover/images/new-primary.png)


We can conclude from the previous outputs which database is PRIMARY and which is a PHYSICAL STANDBY.

## Task 2: Perform the role transition

1. In the OCI console, navigate to the DB System Details of the ADGHOLAD1 database and scroll down to the Databases section.

    Overview
    -> Bare Metal, VM and Exadata
    -> DB Systems

2. Select **ADGHOLAD1**
    ![](./images/failover-03.png)

3. Click on the name **DGHOL** and in the next screen scroll down immediately and click on **Data Guard Associations**

    ![](./images/failover-04.png)

4. Click on the 3 dots on the right, and click **Failover**
    ![](./images/failover-05.png)

5. This is a DBA responsibility, so the tooling asks the password. Enter the SYS password (WElcome123##) and click **OK** then the role transition starts.
    ![](./images/failover-06.png)

6. At this point, the lifecycle state will be updating and the role transition happens in the background.
    ![](./images/failover-07.png)

7. After some time the role transition finished and the state is Available again.
    ![](./images/failover-08.png)

## Task 3: Reinstate the old primary, the new standby

A failover means that the old primary, in our case the DB ADGHOLAD2, will be disabled. To use this database again as a standby database, we need to reinstate it.

1. To do so, navigate to the new primary, the database in ADGHOLAD1 via

    Overview
    -> Bare Metal, VM and Exadata
    -> DB Systems

2. And select ADGHOLAD1.
3. Then scroll down and click on DGHOL database.

4. This brings you to the Database details. Scroll down on the page and click on **Data Guard Associations**. You can see that the **Peer Role** is **Disabled Standby**.

    ![](./images/failover-10.png)

5. Click on the 3 dots on the right, and click **Reinstate**
    ![](./images/failover-11.png)

6. This is a DBA responsibility, so the tooling asks the password. Enter the SYS password (WElcome123##) and click **OK** then the reinstate starts.
    ![](./images/failover-12.png)

7. At this point, the lifecycle state will be updating and the reinstate happens in the background.
    ![](./images/failover-13.png)

8. After some time the role transition finished and the state is Available again. The **Peer Role** is **Standby** again.
    ![](./images/failover-14.png)


## Task 4: Verify the database roles in the database
1. From the **first browser tab** with Cloud Shell, reissue the verification of the role:

    ````
    <copy>Select name, db_unique_name, database_role from v$database;</copy>
    ````
  ![](../connect-db/images/connect-primary.png)

1. Do the same in the **second browser tab** :
    ````
    <copy>Select name, db_unique_name, database_role from v$database;</copy>
    ````
  ![](../connect-db/images/connect-standby.png)

  We can conclude that the Database that was PRIMARY is now PHYSICAL STANDBY, and vice versa.

You have now successfully performed a failover. You may now [proceed to the next lab](#next).


## Acknowledgements

- **Author** - Pieter Van Puymbroeck, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn, Database Product Management
- **Last Updated By/Date** -  Suraj Ramesh, September 2021
