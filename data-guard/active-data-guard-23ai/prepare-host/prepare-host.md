# Prepare the hosts for Data Guard

## Introduction
In this lab, we connect to the database hosts and do some preliminary preparation for the Data Guard configuration.

Estimated Lab Time: 15 Minutes

### Objectives
- Create a connection to the primary database host
- Prepare the primary database host
- Create a connection to the standby database host
- Prepare the standby database host
- Copy the TDE wallet and password file

## Task 1: Create the connection to the primary database host

1. Open up the menu in the left hand corner.  

2. From the menu, select **Oracle Database**, then **Oracle Base Database (VM, BM)**.

  ![Menu of OCI Console showing how to navigate to the next steps](https://oracle-livelabs.github.io/common/images/console/database-dbcs.png " ")

3. In the List Scope section on the left, enter the first part of the compartment assigned to you in the Search field, then click the compartment name.

  ![List of compartments where the correct compartment must be selected](images/select-compartment-livelabs.png)

   There are two Database Systems created for you. The system prefixed with `adghol0` is your primary database, and the system prefixed with `adghol1` is your secondary database.

1. Click the name of the primary database (`adghol0`).

  ![OCI Console showing how to navigate to the next step](images/db-systems.png)

  Scroll down on the page and click on **Nodes(1)** to find the host's **Public IP Address**. Copy the address on the clipboard and make sure to have this information noted down for later.

  ![Screenshot of OCI Console showing how to navigate to the next step](images/node0.png)

5. Open the **Cloud Shell** using the icon next to the region.

  ![Screenshot of OCI Console showing the button for the Cloud Shell](images/cloud-shell.png)

  The Cloud Shell opens after a few seconds and shows the **prompt**.

7. Find your ssh private key which has been created earlier to connect to the host where the primary database is located.

  a. If you have used Reserve Workshop on Livelabs option (Green Button), you should have used any of the method for generating SSH key pairs using [How to Generate SSH Keys](https://oracle-livelabs.github.io/common/labs/generate-ssh-key/?lab=generate-ssh-keys) .

  Now, you should have the **Public** and **Private** key pair. You must have provided the Public Key while reserving the lab and you need the repsective Private key to connect the DB Server.

  b. If you have used Run on Your Tenancy option (Brown Button), you must use the downloaded public and private keys (While creating the DB Systems) for connecting to the DB servers.

  In all the labs we use Cloud shell to connect to the DB server. You can also connect to the DB servers in any of your preferred way such as Terminal in Mac, Powershell in Windows, Putty etc.  Refer the above mentioned link [How to Connect to Servers](https://oracle-livelabs.github.io/common/labs/generate-ssh-key/?lab=generate-ssh-keys) for detailed instructions. Once you are connected to the DB server, **rest of the instructions will remain same**.

7. Using the **Upload** facility, upload the private key in the **Cloud Shell** environment.

  ![Screenshot of the cloud shell showing how to upload the keys](./images/cloud-shell-upload.png)

  ![Screenshot of the cloud shell showing how to upload the keys](./images/cloud-shell-upload-key.png)

8. Change the permission of the private key to `0600` and connect to the primary host as `opc`, using the public IP address that you have noted down earlier.
    ````
    <copy>chmod 600 cloudshellkey</copy>
    ````
    Replace `cloudshellkey` with the name of your private key file.
    ````
    <copy>ssh -i cloudshellkey opc@IP_ADDRESS</copy>
    ````
    Replace again `cloudshellkey` with the name of your private key file, and `IP_ADDRESS` with the real public IP address.

  You should be connected to the primary database host.

## Task 2: Prepare the primary database host

1. Install some packages that we will use later:

    ````
    <copy>sudo dnf install -y git</copy>
    ````

  ![Screenshot of the cloud shell showing the steps executed so far](images/prepare-host0-1.png)

1. Become the `oracle` user:

    ````
    <copy>sudo su - oracle</copy>
    ````

1. Download the helper scripts using git:

  ````
  <copy>
  git clone -b main -n --filter=tree:0 --depth=1 https://github.com/oracle-livelabs/database-maa.git
  cd database-maa
  git sparse-checkout set --no-cone data-guard/active-data-guard-23ai/prepare-host/scripts
  git checkout
  </copy>
  ````

1. Execute the preparation script. This will:
  * Set up a function for the execution of the last version of SQLcl
  * Create the static service registration entry in listener.ora
  * Create the application TNS entries in tnsnames.ora

  ```
  <copy>
  sh ~/database-maa/data-guard/active-data-guard-23ai/prepare-host/scripts/prepare.sh
  </copy>
  ```

1. Verify the content of `listener.ora` and `tnsnames.ora`

  ```
  <copy>
  cat $ORACLE_HOME/network/admin/listener.ora
  cat $ORACLE_HOME/network/admin/tnsnames.ora
  </copy>
  ```

  ![Content of listener.ora](images/listener-ora.png)

  The static service registration is required for the duplicate, and also because there is no Oracle Clusterware: Data Guard has to restart the remote instance with a SQL*Net connection when switching over.

  By default, without Oracle Clusterware, Data Guard expects a static service named `{DB_UNIQUE_NAME}_DGMGRL.{DOMAIN_NAME}`. It is possible to override this name using the Data Guard property `StaticConnectIdentifier` (we will see that over the next labs).

  For more information about static service registration, check the documentation: [Configuring Static Service Registration](https://docs.oracle.com/en/database/oracle/oracle-database/23/netag/enabling-advanced-features.html#GUID-0203C8FA-A4BE-44A5-9A25-3D1E578E879F)

## Task 3: Create a connection to the standby database host

1. Duplicate the tab in your browser. If your browser does not support tab duplication, open a new tab and connect again to the Cloud Console.

2. Repeat all the steps from **Task 1: Create the connection to the primary database host**

  This time, select the **adghol1** DB System (the standby database).

  ![OCI Console showing the existing DB Systems](images/db-systems.png)

  Scroll down on the page and click on **Nodes(1)** to get the public IP address. Copy it to the clipboard and make sure to have this information noted down.

  ![Screenshot of OCI Console showing the public IP address of the second node](images/node1.png)

5. Open the **Cloud Shell** using the icon next to the region.

  ![Screenshot of OCI Console showing the button for the Cloud Shell](images/cloud-shell.png)

  The Cloud Shell opens after a few seconds and shows the **prompt**.

7. The private key that you have uploaded in the previous step should already be there. The same key can be used to connect to the standby database host.

  Connect to the standby host as `opc`, using the public IP address that you have noted down earlier.
    ````
    <copy>ssh -i cloudshellkey opc@IP_ADDRESS2</copy>
    ````
    Replace `cloudshellkey` with the name of your private key file, and `IP_ADDRESS2` with the public IP address of the standby database host.

9. You should be connected to the standby database host.


You have now successfully created a database connection to the primary and the standby database.

## Task 4: Prepare the standby database host

1. Install some packages that we will use later:

    ````
    <copy>sudo dnf install -y git</copy>
    ````

  ![Screenshot of the cloud shell showing the steps executed so far](images/prepare-host0-1.png)

1. Become the `oracle` user:

    ````
    <copy>sudo su - oracle</copy>
    ````

1. Download the helper scripts using git:

    ````
    <copy>
    git clone -b main -n --filter=tree:0 --depth=1 https://github.com/oracle-livelabs/database-maa.git
    cd database-maa
    git sparse-checkout set --no-cone data-guard/active-data-guard-23ai/prepare-host/scripts
    git checkout
    </copy>
    ````
     
1. Execute the preparation script. This will:
  * Set up a function for the execution of the last version of SQLcl
  * Create the static service registration entry in listener.ora
  * Create the application TNS entries in tnsnames.ora
   
  ```
  <copy>
  sh ~/database-maa/data-guard/active-data-guard-23ai/prepare-host/scripts/prepare.sh
  </copy>
  ```
  
1. Verify the content of `listener.ora` and `tnsnames.ora`

  ```
  <copy>
  cat $ORACLE_HOME/network/admin/listener.ora
  cat $ORACLE_HOME/network/admin/tnsnames.ora
  </copy>
  ```

## Task 5: copy the Transparent Data Encryption (TDE) wallet and password file

Oracle Data Guard requires the same Transparent Data Encryption (TDE) master keys in the primary and standby database wallets. The quickest way to achieve that is to copy the entire wallet from the primary to the standby database.

Similarly, the default Data Guard authentication mechanism is to use the password file. The password files must match to ensure that there are no authentication problems.

1. On the primary host (adghol0), copy the keys in a location accessible from the user opc:
  
  ```
  <copy>
  cd /opt/oracle/dcs/commonstore/wallets/$ORACLE_UNQNAME/tde
  tar cvf /tmp/wallet.tar cwallet.sso ewallet.p12
  cp $ORACLE_HOME/dbs/orapwadghol /tmp
  chmod 644 /tmp/orapwadghol
  </copy>
  ```
  
1. Temporarily go back to the Cloud Shell environment by exiting the shell twice:
  
  ```
  exit
  exit
  ```
  
1. Copy the wallet and password file from one node to the other, then delete them.
  
  In the following command, replace IP_ADDRESS0 and IP_ADDRESS1 with the public IP addresses of the two hosts you noted down earlier.
  
  ```
  <copy>
  scp -i cloudshellkey opc@IP_ADDRESS0:/tmp/wallet.tar /tmp
  scp -i cloudshellkey opc@IP_ADDRESS0:/tmp/orapwadghol /tmp
  scp -i cloudshellkey /tmp/wallet.tar opc@IP_ADDRESS1:/tmp
  scp -i cloudshellkey /tmp/orapwadghol opc@IP_ADDRESS1:/tmp
  rm /tmp/wallet.tar
  rm /tmp/orapwadghol
  </copy>
  ```
  
  ![Steps executed to copy the wallet on the second host](images/wallet-copy-1.png)
  
1. Connect back to the first host and remove the wallet and password file from the temporary location:
  
  ```
  <copy>
  ssh -i cloudshellkey opc@IP_ADDRESS0
  sudo su - oracle
  rm /tmp/wallet.tar
  rm /tmp/orapwadghol
  </copy>
  ```

1. On the standby host (adghol1), copy the files to the correct locations and permissions (as `oracle`), then remove the temporary files as `opc`:
  
  ```
  <copy>
  cd /opt/oracle/dcs/commonstore/wallets/$ORACLE_UNQNAME/tde
  tar xvf /tmp/wallet.tar
  cp /tmp/orapwadghol $ORACLE_HOME/dbs
  chmod 600 $ORACLE_HOME/dbs/orapwadghol
  exit
  rm /tmp/wallet.tar
  rm /tmp/orapwadghol
  sudo su - oracle
  </copy>
  ```

  ![Steps executed to copy the wallet on the second host](images/wallet-copy-2.png)

You have successfully prepared the two hosts with everything required to start configuring Data Guard.

## Acknowledgements

- **Author** - Ludovico Caldara, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn
- **Last Updated By/Date** -  Ludovico Caldara, June 2024
