
# Create the Data Guard configuration

## Introduction
In this lab, we configure Oracle Data Guard using the broker.

The broker automates all the aspects of a Data Guard topology, including setting up the redo transport, coordinating switchovers and failovers, monitoring the lags, etc.

For more information about the Data Guard broker, refer to the [broker documentation](https://docs.oracle.com/en/database/oracle/oracle-database/23/dgbkr/oracle-data-guard-broker-concepts.html#GUID-723E5B73-A350-4B2E-AF3C-5EA4EFC83966).

After configuring the broker, we will check the configuration and have a basic knowledge of how to control and monitor Data Guard.

Estimated Lab Time: 5 Minutes

### Requirements
To try this lab, you must have successfully completed:
* Lab 1: Prepare the database hosts
* Lab 2: Prepare the databases

### Objectives
- Configure Data Guard

## Task 1: Configure Data Guard

You should have two Cloud Shell tabs connected to the primary and secondary hosts, adghol0 and adghol1. If you don't, follow the first steps of Lab 1 until you have both SSH connections established.

1. From a terminal (which one of the two is irrelevant for this task), connect to the primary database using the broker client command line (DGMGRL). We use the DGConnectIdentifier for that (the service named after the db_unique_name). Replace `ADGHOL0_DGCI` with the one noted down during Lab 2.

  ```
  <copy>
  dgmgrl sys/WElcome123##@ADGHOL0_DGCI
  </copy>
  ```
  For example:
  ```
  dgmgrl sys/WElcome123##@adghol0-1234.ll1234pubsubnt.ll1234vcn.oraclevcn.com:1521/adghol_53k_lhr.ll1234pubsubnt.ll1234vcn.oraclevcn.com
  ```

1. Create the configuration using the `CREATE CONFIGURATION` command. Again, replace `ADGHOL0_DGCI` with the actual connect string and `ADGHOL0_UNIQUE_NAME` with the actual db_unique_name:

  ```
  <copy>
  create configuration adghol primary database is ADGHOL0_UNIQUE_NAME connect identifier is 'ADGHOL0_DGCI';
  </copy>
  ```
  For example:
  ```
  create configuration adghol primary database is adghol_53k_lhr connect identifier is 'adghol0-1234.ll1234pubsubnt.ll1234vcn.oraclevcn.com:1521/adghol_53k_lhr.ll1234pubsubnt.ll1234vcn.oraclevcn.com';
  ```

1. Add the standby database to the configuration using the `ADD DATABASE` command. Replace `ADGHOL1_DGCI` and `ADGHOL1_UNIQUE_NAME` with the actual connect string and db_unique_name of the standby database:

  ```
  <copy>
  add database ADGHOL1_UNIQUE_NAME as connect identifier is 'ADGHOL1_DGCI';
  </copy>
  ```
  For example:
  ```
  add database adghol_p4n_lhr as connect identifier is 'adghol1-1234.ll1234pubsubnt.ll1234vcn.oraclevcn.com:1521/adghol_p4n_lhr.ll1234pubsubnt.ll1234vcn.oraclevcn.com';
  ```

  Notice that we don't specify the static service (suffixed with _DGMGRL), because, under normal operation, the broker expects the standby to be mounted, therefore the default service is available.

1. Set the `StaticConnectIdentifier` for both databases.
  Although the broker builds the default static connect identifier if it's not explicitly configured, it is still a good practice to set it to ease troubleshooting. In this lab, we need to set it to specify the FQDN of the hosts, or the DNS will not solve the remote host.

  Replace `ADGHOL0_UNIQUE_NAME`, `ADGHOL0_SCI`, `ADGHOL1_UNIQUE_NAME`, and `ADGHOL1_SCI` with the actual values:
  ```
  <copy>
  edit database ADGHOL0_UNIQUE_NAME set property StaticConnectIdentifier='ADGHOL0_SCI';

  edit database ADGHOL1_UNIQUE_NAME set property StaticConnectIdentifier='ADGHOL1_SCI';
  </copy>
  ```
  For example:
  ```
  <copy>
  edit database adghol_53k_lhr set property StaticConnectIdentifier='adghol0-1234.ll1234pubsubnt.ll1234vcn.oraclevcn.com:1521/adghol_53k_lhr_DGMGRL.ll1234pubsubnt.ll1234vcn.oraclevcn.com';

  edit database adghol_p4n_lhr set property StaticConnectIdentifier='adghol1-1234.ll1234pubsubnt.ll1234vcn.oraclevcn.com:1521/adghol_p4n_lhr_DGMGRL.ll1234pubsubnt.ll1234vcn.oraclevcn.com';
  </copy>
  ```

1. Enable the configuration. This final command will set the required parameters and execute the required commands to start the redo shipping from the primary to the standby database and start the standby recovery:

  ```
  <copy>
  enable configuration;
  </copy>
  ```

  ![Steps executed to create and enable the Data Guard configuration](images/create-configuration.png)

  The command `show configuration` should report success. 

  ```
  <copy>
  show configuration;
  </copy>
  ```
  If you see the following warning:
  ```
  Warning: ORA-16854: apply lag could not be determined
  ```
  Try using `show configuration verbose` instead, to force a refresh of the status cache.

  ![Show configuration shows a healthy status](images/show-configuration.png)

  That means that the primary can contact the standby database with the `DGConnectIdentifier`, send the redo stream with no lag, and the standby database can apply it successfully without lag.

You have successfully created the Oracle Data Guard configuration. In the next lab, we will see how to monitor and alter the configuration.

## Acknowledgements

- **Author** - Ludovico Caldara, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn
- **Last Updated By/Date** -  Ludovico Caldara, June 2024
