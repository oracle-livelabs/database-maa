# Prepare the hosts for Data Guard

## Introduction
In this lab, we connect to the database hosts and do some preliminary preparation for the Data Guard configuration.

Estimated Lab Time: 15 Minutes

[Oracle Active Data Guard 23ai](videohub:1_6e3wxgt0)

### Objectives
- Prepare the connection to the database hosts
- Prepare the primary database host
- Prepare the standby database host
- Copy the TDE wallet and password file

## Task 1: Prepare the connection to the database hosts

1. Open up the menu in the left-hand corner.  

2. From the menu, select **Oracle Database**, then **Oracle Base Database Service**.

   ![Menu of OCI Console showing how to navigate to the next steps](images/oci-menu-basedb.png " ")

3. In the Applied Filters section on the top, enter the first part of the compartment assigned to you in the Search field, then click the compartment name.
    ![List of compartments where the correct compartment must be selected](images/select-compartment-livelabs.png)
    
   There are two Database Systems created for you. The system prefixed with `adghol0` is the primary database, and the system prefixed with `adghol1` is the secondary database that will become the standby database.
   
4. Click the name of the primary database (`adghol0`).
    ![OCI Console showing how to navigate to the next step](images/db-systems.png)
5. Scroll down on the page and click on **Nodes(1)** to find the host's **Public IP Address**.
    **Copy the address on the clipboard and make sure to have this information noted down for later.**
    ![Screenshot of OCI Console showing how to navigate to the next step](images/node0.png)

6. Navigate back to the **Oracle Base Database Service** 
    ![Menu of OCI Console showing how to navigate to the next steps](images/oci-menu-basedb.png " ")

7. click the name of the secondary database (`adghol1`).
    ![OCI Console showing how to navigate to the next step](images/db-systems.png)

8. Scroll down on the page and click on **Nodes(1)** to find the host's **Public IP Address**.
    **Copy the address on the clipboard and make sure to have this information noted down for later.**
    ![Screenshot of OCI Console showing how to navigate to the next step](images/node1.png)

9. Open the **Cloud Shell** using the icon next to the region.
    ![Screenshot of OCI Console showing the button for the Cloud Shell](images/cloud-shell.png)
  The Cloud Shell opens and shows the **prompt**.
  You can maximize it for a better experience. You can enter `N` if it asks to run a tutorial.

10. Find your ssh private key which has been created earlier to connect to the host where the primary database is located.
     1. If you have used the **Reserve Workshop on Livelabs** option (Green Button), you should have used any of the methods for generating SSH key pairs using [How to Generate SSH Keys](https://oracle-livelabs.github.io/common/labs/generate-ssh-key/?lab=generate-ssh-keys) .
   Now, you should have the **Public** and **Private** key pair. You must have provided the Public Key while reserving the lab and you need the repsective Private key to connect the DB Server.
     2. If you have used the **Run on Your Tenancy** option (Brown Button), you must use the downloaded public and private keys (downloaded while creating the DB Systems) to connect to the DB servers.

   All the labs use Cloud shell to connect to the DB server. You can also connect to the DB servers with your preferred tools, such as Terminal on Mac, Powershell on Windows, Putty etc.  Refer the above mentioned link [How to Connect to Servers](https://oracle-livelabs.github.io/common/labs/generate-ssh-key/?lab=generate-ssh-keys) for detailed instructions. Once you connect to the DB server, **the rest of the instructions will remain the same**.

11. Using the **Upload** facility, upload the private key in the **Cloud Shell** environment.
    ![Screenshot of the cloud shell showing how to upload the keys](./images/cloud-shell-upload.png)
    ![Screenshot of the cloud shell showing how to upload the keys](./images/cloud-shell-upload-key.png)
   
12. To ease the copy & paste of the next operations, rename the key file to `cloudshellkey` (replace `YOUR_KEY_FILE` with the actual name):
    ````
    <copy>mv YOUR_KEY_FILE cloudshellkey</copy>
    ````
13. Change the permission of the private key to `0600`:
    ````
    <copy>chmod 600 cloudshellkey</copy>
    ````
14. Prepare the SSH config file to connect to the hosts.
    ````
    <copy>
    mkdir ~/.ssh
    </copy>
    ````
    **Replace IP_ADDRESS0 and IP_ADDRESS1 with the IPs that you noted down earlier**.
    ````
    <copy>
    bash -c "cat <<EOF > ~/.ssh/config
    Host adghol0
        Hostname \$0
        User opc
        IdentityFile ~/cloudshellkey

    Host adghol1
        Hostname \$1
        User opc
        IdentityFile ~/cloudshellkey
    EOF" IP_ADDRESS0 IPADDRESS1
    </copy>
    ````
    ![Screenshot of the cloud shell showing the steps executed so far](./images/ssh-config.png)
15. Verify the SSH config file content:
    ````
    <copy>
    cat ~/.ssh/config
    </copy>
    ````
    it should look similar to this (with the correct IP addresses):
    ````
    Host adghol0
    Hostname 129.148.41.182
        User opc
        IdentityFile ~/cloudshellkey
    
    Host adghol1
        Hostname 168.75.74.51
        User opc
        IdentityFile ~/cloudshellkey
    ````
16. Try the connection to the primary host:
    ````
    <copy>
    ssh adghol0
    </copy>
    ````

    The first connection will ask:
    ````
    Are you sure you want to continue connecting (yes/no/[fingerprint])? 
    ````

    Type `yes`.
    ![The SSH connection to adghol0 succeeded.](./images/ssh-adghol0.png)

   You should be connected to the primary database host.

## Task 2: Prepare the primary database host

1. As the `opc` user on `adghol0`, install git that we will use later:

    ````
    <copy>sudo dnf install -y git</copy>
    ````
   ![Screenshot of the cloud shell showing the steps executed so far](images/prepare-host0-1.png)

2. Become the `oracle` user:

    ```
    <copy>sudo su - oracle</copy>
    ```

3. Download the helper scripts using git, we will use them for the configuration and during some labs during the workshop:

    ```
    <copy>
    git clone -b main -n --filter=tree:0 --depth=1 https://github.com/oracle-livelabs/database-maa.git
    cd database-maa
    git sparse-checkout set --no-cone data-guard/active-data-guard-23ai/prepare-host/scripts
    git checkout
    </copy>
    ```
   ![The git clone command downloads only a portion of the git repository](images/git-clone.png)

4. Execute the preparation script. It will:
    * Create the static service registration entry in listener.ora
    * Create the entries for the DGConnectIdentifier and StaticConnectIDentifier
    * Create the application TNS entries in tnsnames.ora
    ```
    <copy>
    sh ~/database-maa/data-guard/active-data-guard-23ai/prepare-host/scripts/prepare.sh
    </copy>
    ```

5. Verify the content of `listener.ora` and `tnsnames.ora`
    ```
    <copy>
    cat $ORACLE_HOME/network/admin/listener.ora
    cat $ORACLE_HOME/network/admin/tnsnames.ora
    </copy>
    ```
    ![Content of listener.ora](images/listener-ora.png)

    After this step, there should be a total of seven connection descriptors in `tnsnames.ora`:
    * `adghol_site0`
    * `adghol_site0_dgmgrl`
    * `adghol_site1`
    * `adghol_site1_dgmgrl`
    * `mypdb_rw`
    * `mypdb_r0`
    * `mypdb_snap`

    The first four are the DGConnectIdentifier and StaticConnectIdentifier for the two databases. The last three are the descriptors that the the application will use to connect to the role-based services.

    More information about the Data Guard connect identifiers:
    * The `DGConnectIdentifier` connects to the default service named after the `DB_UNIQUE_NAME` (`adghol_site0` and `adghol_site1` in our lab) or another service accessible when the instance is mounted.
    * The `StaticConnectIdentifier` connects to the service statically registered with the listener (we created it in the previous step). In this lab we use `adghol_site0_dgmgrl` and `adghol_site1_dgmgrl`.
    The static service registration is required for the duplicate, and also, because there is no Oracle Clusterware. Data Guard has to restart the remote instance with a SQL*Net connection when switching over.
    By default, without Oracle Clusterware, Data Guard expects a static service named `{DB_UNIQUE_NAME}_DGMGRL.{DOMAIN_NAME}`. It is possible to override this name using the Data Guard property `StaticConnectIdentifier` (we will see that over the next labs).
    For more information about static service registration, check the documentation: [Configuring Static Service Registration](https://docs.oracle.com/en/database/oracle/oracle-database/23/netag/enabling-advanced-features.html#GUID-0203C8FA-A4BE-44A5-9A25-3D1E578E879F)

    For even more information about Data Guard `DGConnectIdentifier` and `StaticConnectIdentifier`, read the documentation:
    * [Oracle Data Guard Broker Properties - DGConnectIdentifier](https://docs.oracle.com/en/database/oracle/oracle-database/23/dgbkr/oracle-data-guard-broker-properties.html#GUID-32FF0A08-67DA-41AC-8BE8-0596CAF130BA)
    * [Oracle Data Guard Broker Properties - StaticConnectIdentifier](https://docs.oracle.com/en/database/oracle/oracle-database/23/dgbkr/oracle-data-guard-broker-properties.html#GUID-2F938A76-A178-4A35-A629-F67F34212CAB)


## Task 3: Prepare the standby database host

1.  **Duplicate the tab in your browser**. If your browser does not support tab duplication, open a new tab and connect again to the Cloud Console.
    If you get any errors opening the Cloud Shell, make sure the correct compartment is selected.

2. Connect to the secondary host:
    ````
    <copy>
    ssh adghol1
    </copy>
    ````

    The first connection will ask:
    ````
    Are you sure you want to continue connecting (yes/no/[fingerprint])? 
    ````

    Type `yes`.

1. Install the git package that we will use later:
    ```
    <copy>sudo dnf install -y git</copy>
    ```
   ![Screenshot of the cloud shell showing the steps executed so far](images/prepare-host0-1.png)

2. Become the `oracle` user:
    
    ```
    <copy>sudo su - oracle</copy>
    ```

3. Download the helper scripts using git:

    ```
    <copy>
    git clone -b main -n --filter=tree:0 --depth=1 https://github.com/oracle-livelabs/database-maa.git
    cd database-maa
    git sparse-checkout set --no-cone data-guard/active-data-guard-23ai/prepare-host/scripts
    git checkout
    </copy>
    ```
   ![The git clone command downloads only a portion of the git repository](images/git-clone.png)
     
4. Execute the preparation script also on the secondary host. It will:
    * Create the static service registration entry in listener.ora
    * Create the application TNS entries in tnsnames.ora
    ```
    <copy>
    sh ~/database-maa/data-guard/active-data-guard-23ai/prepare-host/scripts/prepare.sh
    </copy>
    ```
  
5. Verify the content of `listener.ora` and `tnsnames.ora`
    ```
    <copy>
    cat $ORACLE_HOME/network/admin/listener.ora
    cat $ORACLE_HOME/network/admin/tnsnames.ora
    </copy>
    ```

## Task 4: copy the Transparent Data Encryption (TDE) wallet and password file

Oracle Data Guard requires the same Transparent Data Encryption (TDE) master keys in the primary and standby database wallets. The quickest way to achieve that is to copy the entire wallet from the primary to the standby database.

Similarly, the default Data Guard authentication mechanism uses the password file. The password files must match to ensure that there are no authentication problems.

1. **On the primary host** (adghol0), **as oracle**, copy the keys in a location accessible from the user opc:
    ```
    <copy>
    # to execute on ADGHOL0
    cd /opt/oracle/dcs/commonstore/wallets/$ORACLE_UNQNAME/tde
    tar cvf /tmp/wallet.tar cwallet.sso ewallet.p12
    cp $ORACLE_HOME/dbs/orapwadghol /tmp
    chmod 644 /tmp/orapwadghol
    </copy>
    ```
  
2. Temporarily **go back to the Cloud Shell environment** by exiting the shell twice:
    ```
    exit
    exit
    ```
  
3. From the **Cloud Shell** environment, copy the wallet and password file from one node to the other, then delete them:
    ```
    <copy>
    scp adghol0:/tmp/wallet.tar /tmp
    scp adghol0:/tmp/orapwadghol /tmp
    scp /tmp/wallet.tar adghol1:/tmp
    scp /tmp/orapwadghol adghol1:/tmp
    rm /tmp/wallet.tar
    rm /tmp/orapwadghol
    </copy>
    ```
    ![Steps executed to copy the wallet on the second host](images/wallet-copy-1.png)
  
4. **Connect back to adghol0** and remove the wallet and password file from the temporary location:
    ```
    <copy>
    ssh adghol0
    sudo su - oracle
    rm /tmp/wallet.tar
    rm /tmp/orapwadghol
    </copy>
    ```

5. **On the standby host** (`adghol1`), **as oracle**, copy the files to the correct locations and permissions (as `oracle`), then remove the temporary files as `opc`. 
    **Note:** Use the appropriate browser tab connected to the `adghol1` server. Throughout the lab, make sure to have two browser tabs, one connected to `adghol0` and one connected to `adghol1`. Please carefully run the commands on the correct host according to the instructions provided.
    ```
    <copy>
    # to execute on ADGHOL1
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

You have successfully prepared the two hosts with everything required to start configuring the databases and Data Guard.

## Acknowledgements

- **Author** - Ludovico Caldara, Product Manager Data Guard, Active Data Guard and Flashback Technologies
- **Contributors** - Robert Pastijn
- **Last Updated By/Date** -  Ludovico Caldara, July 2025
