# Migrate your database

## Introduction
In this lab on your host instance, you will learn how to perform a logical online migration to Autonomous Database with ZDM.

Estimated Time: 30 minutes

### Objectives

In this lab, you will:
* Perform a migration on evaluation mode to troubleshoot any connectivity or setup issue
* Learn how to monitor an ongoing migration job
* Migrate your Database

### Prerequisites
* This workshop section requires having completed all he previous sections.


## Task 1: Run a Migration on Evaluation Mode

1. The migrate zdmcli command performs a migration and consists of several parameters. Let's review one by one to undertand them better.

    ```
    /u01/app/zdmhome/bin/zdmcli migrate database -rsp /path/zdmresponsefile.rsp -sourcesid ORACLE_SID -sourcenode source_host_name -srcauth authentication_plugin_name -srcarg1 user:source_database_server_login_user_name -srcarg2 identity_file:ZDM_installed_user_private_key_file_location  -srcarg3 sudo_location:/sudo_location -eval -skipadvisor
    ```

    Let's review one by one the different parameters that are part of this command:

    ```
    -rsp /path/zdmresponsefile.rsp
    ```
    The __-rsp__ option specifies the migration response file path

    ```
    -sourcesid ORACLE_SID
    ```
    The __-sourcesid__ option specifies the ORACLE_SID of the source database. This option is used here instead of -source given that the source database is a single instance database with no Grid Infrastructure deployment.

    ```
    -sourcenode source_host_name
    ```
    The __-sourcenode__ option specifices the Source Database Host Name

    ```
    -srcauth authentication_plugin_name
    ```
    The __-srcauth__ option specifies the Authentication Plugin to be used, the default plugin is zdmauth.


    ```
    -srcarg1 user:source_database_server_login_user_name
    ```
    The __-srcarg1 user:__ option specifies the Source Database Server Login user name

    ```
    -srcarg2 identity_file:ZDM_installed_user_private_key_file_location
    ```
    The __-srcarg2 identity_file__ option specifies the ZDM installed user private key file location

    ```
    -srcarg3 sudo_location:/sudo_location
    ```
    The __-srcarg3 sudo_location__ option specifies the path for the sudo location

    ```
    -eval -skipadvisor
    ```
    Finally, the __-eval__ flag specifies that this is an Evaluation mode migration, hence ZDM will not be actually performing the migration but just a validation to verify everything is in order. The __-skipadvisor__ flag specifies that ZDM can skip the Pre-Migration advisor phase, which will not be required for the purposes of this workshop.

2. Let's now proceed to perform a migration on Evaluation mode. Providing all the steps have been followed, the following zdmcli migrate database command and corresponding options, parameters and flags should work without requiring any modification. As the zdmuser, execute the following in your Cloud Shell: 

    ```
    <copy>
    /u01/app/zdmhome/bin/zdmcli migrate database -rsp /home/zdmuser/livelab/zdm_logical_online.rsp -sourcesid orcl -sourcenode workshop -srcauth zdmauth -srcarg1 user:opc -srcarg2 identity_file:/home/zdmuser/.ssh/id_rsa -srcarg3 sudo_location:/usr/bin/sudo -eval -skipadvisor
    </copy>
    ```

3. You will be prompted for different passwords for different components. As you remember, for the purpose of this lab and for your convenience, we set all the passwords to __WELcome##1234__, please copy this an enter it for every prompt, except for the Token prompt, for the Token prompt please enter the Token you created and saved before:

    ```
    <copy>
    WELcome##1234
    </copy>
    ```

4. ZDM will then proceed to create a migration job id that should look as follows:

    ![Screenshot of Oracle Cloud Infrastructure Cloud Shell with ZDMCLI Migrate Database command output](./images/zdm-job-id.png " ")


## Task 2: Evaluate a Migration Job

1. To evaluate the migration job, we will use the __/u01/app/zdmhome/bin/zdmcli query job -jobid idnumber__ command. Copy the command from below and replace idnumber with the assigned Job ID provided by ZDM on your migration, then, press Enter.

    ```
    <copy>
    /u01/app/zdmhome/bin/zdmcli query job -jobid idnumber
    </copy>
    ```

2. You might need to execute the command several times until the evaluation is completed. Upon succesful completion of your migration in evaluation mode, you should see an output like the following:

    ![Screenshot of Oracle Cloud Infrastructure Cloud Shell with ZDMCLI Query Job output](./images/zdm-job-eval-done.png " ")

## Task 3: Migrate your Database

1. You are now ready to migrate your database, to so, you will execute the same command as before, minus the __-eval__ flag. Copy the command from below, paste it on your Cloud Shell and press enter.

    ```
    <copy>
    /u01/app/zdmhome/bin/zdmcli migrate database -rsp /home/zdmuser/livelab/zdm_logical_online.rsp -sourcesid orcl -sourcenode workshop -srcauth zdmauth -srcarg1 user:opc -srcarg2 identity_file:/home/zdmuser/.ssh/id_rsa -srcarg3 sudo_location:/usr/bin/sudo -skipadvisor
    </copy>
    ```

2. Again, you will be prompted for different passwords for different components. Please copy the password above an enter it for every prompt, except for the Token prompt, for the Token prompt please enter the Token you created and saved before:

    ```
    <copy>
    WELcome##1234
    </copy>
    ```    

3. You will now evaluate the migration job until completion, using the command provided above. Remember to replace idnumber with the assigned Job ID provided by ZDM on your migration, then, press Enter. You will have to use this command several times to actively monitor your migration.

    ```
    <copy>
    /u01/app/zdmhome/bin/zdmcli query job -jobid idnumber
    </copy>
    ```
    ![Screenshot of Oracle Cloud Infrastructure Cloud Shell with ZDMCLI Query Job output pending](./images/zdm-job-pending.png " ")

    ![Screenshot of Oracle Cloud Infrastructure Cloud Shell with ZDMCLI Query Job output completed](./images/zdm-job-completed.png " ")

4. Congratulations, your database has now been migrated using Oracle Zero Downtime Migration Logical Online workflow. Let's go to the Target Autonomous Database and check its contents.

5.  In your Oracle Cloud Infrastructure Dashboard: select the navigation menu, Oracle Database, Autonomous Database.
    ![Screenshot of Oracle Cloud Infrastructure Oracle Database Menu with Autonomous Database Option](./images/menu-auton.png)

6. Select the target database.
    ![Screenshot of Oracle Cloud Infrastructure Autonomous Databases available in current compartment](./images/select-auton.png)

7. In the database menu go to __Tools__, __Open Database Actions__.
    ![Screenshot of selected Datatabase Tools with Database Action selected](./images/db-action.png)

8. A new tab will open requesting for credentials. Fill in ADMIN for the username and the password will be `WELcome##1234`.

9. Select SQL
    ![Screenshot of Database Actions Window with SQL option highlighted](./images/select-sql.png)


10. Copy the query below and paste it on the Worksheet: 

    ```
    <copy>
    SELECT * FROM ZDML.EMPL;
    </copy>
    ```

11. This query will show us the contents of the table EMPL. If you remember, in Lab 3, we connected to the source database and ran a script that created the EMPL table and filled it with 1000 records. If the migration was succesful, the table and the same records will show here. Select 'Run Script'.
    ![Screenshot of Database Actions with Run Script option highlighted](./images/run-query.png)

12. The result now shows on the __Query Result__ pane below.
    ![Screenshot of Database Actions with Query Result Highlighted](./images/query-result.png)


## Summary

Congratulations, you have finished the Zero Downtime Logical Online Migration to Oracle Autonomous Database LiveLab.
You have learned about Oracle Zero Downtime Migration (ZDM), its features and functionality and how to migrate, step-by-step, a database to the Oracle Cloud.

__Learn More About Zero Downtime Migration (ZDM)__

* [Oracle Zero Downtime Migration - Product Page](http://www.oracle.com/goto/zdm)
* [Oracle Zero Downtime Migration - Product Documentation](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/)
* [Oracle Zero Downtime Migration - Logical Migration Step by Step Guide](https://www.oracle.com/a/tech/docs/oracle-zdm-logical-migration-step-by-step-guide.pdf)
* [Oracle Zero Downtime Migration - Physical Migration Step by Step Guide](https://www.oracle.com/a/tech/docs/oracle-zdm-step-by-step-guide.pdf)



## Acknowledgements
* **Author** - Ricardo Gonzalez, Senior Principal Product Manager, Oracle Cloud Database Migration
* **Contributors** - LiveLabs Team, ZDM Development Team
* **Last Updated By/Date** - Ricardo Gonzalez, January 2022
