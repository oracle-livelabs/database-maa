
# Create and verify the Data Guard configuration

## Introduction
In this lab, we configure Oracle Data Guard using the broker.

The broker automates all the aspects of a Data Guard topology, including setting up the redo transport, coordinating switchovers and failovers, monitoring the lags, etc.

For more information about the Data Guard broker, refer to the [broker documentation](https://docs.oracle.com/en/database/oracle/oracle-database/23/dgbkr/oracle-data-guard-broker-concepts.html#GUID-723E5B73-A350-4B2E-AF3C-5EA4EFC83966).

After configuring the broker, we will check the configuration and have a basic knowledge of how to control and monitor Data Guard.

Estimated Lab Time: 10 Minutes

### Requirements
To try this lab, you must have successfully completed:
* Lab 1: Prepare the database hosts
* Lab 2: Prepare the databases

### Objectives
- Configure Data Guard
- Run the validation commands
- Stop and start the redo transport and the apply process
- Review the Data Guard configuration and processes
- Control Data Guard with PL/SQL

## Task 1: Configure Data Guard

You should have two Cloud Shell tabs connected to the primary and secondary hosts, adghol0 and adghol1. If you don't, follow the first steps of Lab 1 until you have both SSH connections established.

1. From a terminal (which one of the two is irrelevant for this task), connect to the primary database using the broker client command-line (DGMGRL). We use the DGConnectIdentifier for that (the service named after the db_unique_name). Replace `ADGHOL0_DGCI` with the one noted down during Lab 2.

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

  Notice that we don't specify the static service (suffixed with _DGMGRL), because under normal operation, the broker expect the standby to be mounted, therefore the default service is available.

1. (Optional): set the `StaticConnectIdentifier` for both databases.
  Although the broker builds the default static connect identifier if it's not explicitly configured, it is still a good practice to set it to ease troubleshooting.

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
  enable configuration;
  </copy>
  ```

  ![Show configuration shows a healthy status](images/show-configuration.png)

  That means that the primary can contact the standby database with the `DGConnectIdentifier`, send the redo stream with no lag, and the standby database can apply it successfully without lag.

## Task 2: Run the validation commands (optional)

Oracle Data Guard broker provides several commands to check the health of the Data Guard configuration. You can run them to get familiar with the output:

1. The command `show configuration verbose` gives the configuration status and additionally shows all the configuration-level properties:

  ```
  <copy>show configuration verbose;</copy>
  ```

  ![Show configuration verbose shows a healthy status](images/show-configuration-verbose.png)

1. The command `validate static connect identifier for all` checks that the static connect identifiers of all members are reachable by all members.

  ```
  <copy>validate static connect identifier for all;</copy>
  ```

1. Similarly, the command `validate network configuration for all` checks the network configuration is healthy.

  ```
  <copy>validate network configuration for all;</copy>
  ```

  ![Output of validate static connect identifier and validate network configuration](images/validate-static-network.png)

1. The command `validate database` shows the database readiness for switchover and failover. With the `verbose` keyword, it gives additional detail regarding the different checks performed during the validation.

  The output will be different from primary and standby database.

  Replace the db_unique_name as usual:

  ```
  <copy>validate database verbose ADGHOL0_UNIQUE_NAME;</copy>
  ```

  ![Output of VALIDATE DATABASE executed on the primary](images/validate-primary.png)

  ```
  <copy>validate database verbose ADGHOL1_UNIQUE_NAME;</copy>
  ```

  ![Output of VALIDATE DATABASE on the standby database, part 1](images/validate-standby-1.png)
  ![Output of VALIDATE DATABASE on the standby database, part 2](images/validate-standby-2.png)

1. The command `validate database ... strict all` makes a stricter validation, reporting `Ready for Switchover: No` in case any of the checks fail, regardless if they are strictly required for a switchover or not.

  ```
  <copy>validate database ADGHOL1_UNIQUE_NAME strict all;</copy>
  ```

  ![Output of VALIDATE DATABASE STRICT ALL](images/validate-strict.png)

  In this case, you can see that the configuration is not ready for the switchover. The output shows that the Flashback logging is not enabled on the standby database. This won't prevent the switchover from working, but might give unexpected problems later, for example, the inability to reinstate the new primary in case of failover.

  Don't worry, we will fix that later.

1. The command `validate database ... spfile` shows the differences between the initialization parameters of the primary database and those of the standby database. Only the parameters that are relevant to Data Guard are shown.

  ```
  <copy>validate database ADGHOL1_UNIQUE_NAME spfile;</copy>
  ```

  ![Output of VALIDATE DATABASE SPFILE](images/validate-spfile.png)

1. The command `validate dgconnectidentifier` verifies that a specific connect identifier is correctly reachable from all members of the configuration, and that it's possible to connect to it using the same username and password used to start the broker command-line session. That is useful when diagnosing connectivity or authentication problems (ORA-01017), especially before executing a role transition.

  Change the DGConnectIdentifier with the appropriate one.
  ```
  <copy>validate dgconnectidentifier ADGHOL0_DGCI;</copy>
  ```

  ```
  <copy>validate dgconnectidentifier ADGHOL1_DGCI;</copy>
  ```

## Task 3: Stop and start the redo transport and the apply process (optional)

When operating Oracle Data Guard, you will need to stop and start the recovery, pause the redo log shipping, etc.

The following examples show how to do it.

1. Stop the apply process on the standby database. Replace `ADGHOL1_UNIQUE_NAME` with the actual standby database db_unique_name.

  ```
<copy>edit database ADGHOL1_UNIQUE_NAME set state=apply-off;</copy>
  ```

1. Restart the apply process.

  ```
<copy>edit database ADGHOL1_UNIQUE_NAME set state=apply-on;</copy>
  ```

1. Stop the redo transport from the primary to the standby database(s). Speficy the primary db_unique_name this time.

  ```
<copy>edit database ADGHOL0_UNIQUE_NAME set state=transport-off;</copy>
  ```

1. Restart the transport process.

  ```
<copy>edit database ADGHOL0_UNIQUE_NAME set state=transport-on;</copy>
  ```

1. When you have multiple standby databases, you might want to stop the transport to a specific standby database instead of stopping the whole transport from the primary. In that case, you can do that by changing the property `LogShipping` on the standby database:

  ```
<copy>edit database ADGHOL1_UNIQUE_NAME set property logshipping=off;</copy>
  ```

  That will only alter the corresponding log_archive_dest on the source database shipping to the specified standby database.

1. Restart the log shipping to the standby database.
  ```
<copy>edit database ADGHOL1_UNIQUE_NAME set property logshipping=on;</copy>
  ```

  ![Stop and start the apply and the transport processes](images/stop-start-apply.png)

## Task 4: Review the Data Guard configuration and processes

Oracle Data Guard exposes many fixed views that help observing and monitoring the Data Guard configuration. It is important to get familiar with them.

1. Connect with SQLcl to the primary database using its DGConnectIdentifier.

   ```
   <copy>
   sql sys/Welcome#Welcome#123@ADGHOL0_DGCI as sysdba
   </copy>
   ```

  ![Execution of SQLcl](images/sqlcl-connection.png)

   For example:
   ```
   <copy>
   sql sys/Welcome#Welcome#123@hol23c0.dbhol23c.misclabs.oraclevcn.com:1521/chol23c_rxd_lhr.dbhol23c.misclabs.oraclevcn.com as sysdba
   </copy>
   ```

   The function `sql` created during Lab 1 should download and run the latest version of SQLcl.

2. Change the date formats, and query `v$dataguard_config`:
   ```
   <copy>
alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';
alter session set nls_timestamp_format='YYYY-MM-DD HH24:MI:SS';
select * from v$dataguard_config;
   </copy>
   ```

  ![Content of the v$dataguard_config view](images/v-dataguard-config-primary.png)

  The view `v$dataguard_config` contains the member of the configuration. The content is the same on the primary and standby databases, and it's helpful to understand the topology at a glance.

1. Query the broker properties from `v$dg_broker_property`:

   ```
   <copy>
select member, dataguard_role, property, substr(value,1,20), scope, valid_role from v$dg_broker_property;
   </copy>
   ```

  ![Content of the v$dg_broker_property view](images/v-dg-broker-property.png)

   This view is new in 23c, and is practical to get any configuration property from a SQL*Net connection, without the need to use `dgmgrl` for that.

1. Query the view `v$dataguard_process`:

   ```
   <copy>
select name, role, action, client_role, group#, sequence#, block#, block_count, dest_id  from v$dataguard_process;
   </copy>
   ```

  ![Content of the v$dataguard_process view on the primary](images/v-dataguard-process-primary.png)

  The view `v$dataguard_process` contains information about the background processes related to Data Guard. For the primary database, you will see, among others:
  * LGWR - the logwriter process
  * TMON - the redo transport monitor process
  * TT0* - there are multiple processes with this name, notably the async ORL multi,  responsible for sending the data asynchronously to the standby database.
  * ARC* - the archiver processes

  Where it applies, these processes will show information about which thread, group, sequence, and block are reading, writing, or sending.

1. Connect to the standby database and select from the same views:

   ```
   <copy>
connect sys/Welcome#Welcome#123@ADGHOL1_DGCI as sysdba
   </copy>
   ```

   ```
   <copy>
select * from v$dataguard_config;
   </copy>
   ```

2. On the standby database you can query the view `v$dataguard_stats` that contains information about the transport and apply lags.

   ```
   <copy>
select source_db_unique_name, name, value, time_computed, datum_time from v$dataguard_stats;
   </copy>
   ```
  The column `VALUE` contains a value different from `+00 00:00:00` for the transport or apply lag if there is a lag, but `DATUM_TIME` is extremely important to detect if the standby database is actively receiving data from the primary database. If it does, `DATUM_TIME` will be no more than 1 second older than the current date. Otherwise, you will see `DATUM_TIME` matching the timestamp of the last information received from the primary.

  If you query it again, you will see the `DATUM_TIME` increasing.
   ```
   <copy>
select source_db_unique_name, name, value, time_computed, datum_time from v$dataguard_stats;
   </copy>
   ```

  ![Content of the v$dataguard_stats view on the standby](images/v-dataguard-stats.png)

1. Finally, query the view `v$dataguard_process` on the standby to get information about the standby processes:

   ```
   <copy>
select name, role, action, client_role, group#, sequence#, block#, block_count, dest_id  from v$dataguard_process;
   </copy>
   ```

  ![Content of the v$dataguard_process view on the standby](images/v-dataguard-process-standby.png)

  As you can see, there are more processes related to Data Guard on the standby database. Notably:
  * RFS  - the processes receiving the redo from the primary
  * MRP0 - the process coordinating the recovery processes
  * PR0* - the recovery processes (logmerger, appliers)


## Task 5: Control Data Guard with PL/SQL

During the validation in Task 2 we have seen that we must enable flashback on the standby database. Remember?

1. While connected to the standby database, try to enable flashback logging. This will fail because the recovery is in progress.

   ```
   <copy>
select flashback_on from v$database;
alter database flashback on;
   </copy>
   ```

  ![Trying to enable flashback logging fails with ORA-01153 while the recovery is in progress.](images/enable-flashback-failure.png)

2. We need to stop the recovery. Starting with 23c, we can also use the new procedures in the `DBMS_DG` package:

   ```
   <copy>
set serveroutput on
DECLARE
  severity BINARY_INTEGER;
  retcode  BINARY_INTEGER;
BEGIN
  retcode := DBMS_DG.SET_STATE_APPLY_OFF ( member_name => 'chol23c_r2j_lhr', severity => severity);
  dbms_output.put_line('retcode: '||to_char(retcode)||'  severity: '||to_char(severity));
END;
/
   </copy>
   ```

alter database flashback on;
select flashback_on from v$database;
select name, role, action, action_dur, client_role, sequence#, block#, dest_id  from v$dataguard_process;
DECLARE
  severity BINARY_INTEGER;
  retcode  BINARY_INTEGER;
BEGIN
  retcode := DBMS_DG.SET_STATE_APPLY_ON ( member_name => 'chol23c_r2j_lhr', severity => severity);
  dbms_output.put_line('retcode: '||to_char(retcode)||'  severity: '||to_char(severity));
END;
/
--- tmux resize-pane -Z -t :.0
