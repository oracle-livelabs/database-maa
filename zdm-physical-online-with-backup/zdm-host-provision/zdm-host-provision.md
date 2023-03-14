# Provision and configure ZDM service host

## Introduction

Estimated Time: 40 minutes

### Objectives

In this lab

* You will provision a compute instance to use as ZDM servive host.
* You will configure ZDM software on the compute instance.

### Prerequisites

* All previous labs have been successfully completed.

## Task 1 : Provision ZDM Compute Instance

1. Navigate to compute instance in Oracle Console.

   Click the **Navigation Menu** in the upper left, navigate to **Compute** and then select **Instances**.

   ![Image showing navigation to compute instance](./images/navigate-to-compute.png)

2. Select **Compartment**.

   Select the appropriate compartment on the left side of the console.

   ![Image showing the selection of compartment](./images/compartment.png)

3. Click on **Create Instance**.

   ![Image showing option to create compute instance](./images/create-instance.png)

4. Enter **Name** for compute.

   Enter **zdm-host** as name for compute and select appropriate **compartment** if it is not already done.

   ![Image showing the name to be entered for compute](./images/compute-name.png)

5. Leave the **Placement** section as it is.

6. Select correct image.

   Under **Image and Shape** , click on **Change image**.

   ![Image showing the option to change the image for compute](./images/os-image.png)

   Select **Oracle Linux 7.9** and click on **Select Image**

   ![Image showing the OS image selected for compute](./images/os-selected.png)

7. Select VCN and Subnet.

   Under **Networking** , Select **ZDM-VCN** as VCN and **Public Subnet-ZDM-VCN** as subnet.

   ![Image showing network selected](./images/network.png)

8. Upload SSH Keys.

   Under **Add SSH keys** , upload the public ssh key generated in Lab 1.

   ![Image showing option to upload ssh kesy](./images/ssh.png)

9. Specify custom boot volume.

   Under **Boot volume** , select **Specify a custom boot volume size** and specify 150.

   ![Image showing custom boot volume size](./images/boot.png)
10. Click on **Create** to start the provisioning of compute.

    In less than a few minutes ZDM compute instance will be provisioned.

## Task 2 : Configure ZDM Service

1. Login to ZDM host using the Public IP and ssh key file.

   ![Image showing Public IP for ZDM host ](./images/ip.png)

2. Expand the root FS.

   Execute below command as **opc** user and **press y and Enter** when asked.

   **sudo /usr/libexec/oci-growfs**

   You will see an output similar to the one below.

   ![Image showing command to expand root FS](./images/expand-fs.png)

3. Check the existence of required packages for ZDM.

   ZDM software requires below packages to be installed.

   glibc-devel

   expect

   unzip

   libaio

   oraclelinux-developer-release-el7

   Execute the below command to identify already installed packages.
     ```text
     <copy>
     yum list installed glibc-devel expect unzip libaio oraclelinux-developer-release-e17
     </copy>
     ```
     You will receive an output similar to the one below which shows glibc-devel, libaio , oraclelinux-developer-release-e17 and unzip are alraady installed.

     ![Image showing pre installed packages for ZDM ](./images/preinstalled-package.png)

4. Install missing packages.

   We have seen that **expect** package is missing as per output of previous step.

   Install the **expect** package using commands below.

   **sudo yum install -y expect**

   Sample output is shown below.

   ![Image showing installation of expect package](./images/expect-install.png)

5. Create user, group and directories required for ZDM.

   Switch to **root** user using below command.

   **sudo su -**

   Execute below commands.
     ```text
     <copy>
     groupadd zdm
     useradd -g zdm zdmuser
     mkdir -p /home/zdmuser/zdminstall
     mkdir /home/zdmuser/zdmhome
     mkdir /home/zdmuser/zdmbase
     chown -R zdmuser:zdm /home/
     </copy>
     ```
6. Download ZDM software.

   Download the ZDM software from below URL.

   https://www.oracle.com/database/technologies/rac/zdm-downloads.html

7. Upload ZDM software to ZDM host.

   Upload the software(.zip file) to /tmp directory in ZDM host.

   Ensure that all users can read the .zip file.

8. Unzip the ZDM software.

   Switch user to **zdmuser** using below command.

   **sudo su - zdmuser**
   
   Unzip the ZDM software under /tmp directory.

   Note down the directory path of unzipped folder , it will be **/tmp/zdm21.x** for **ZDM 21.x** , Please note this is a generic placeholder name for ZDM software and make sure to use the latest version available.

9. Install ZDM software.

   Change directory to ZDM software unzipped location using below command.

   cd /tmp/zdm21.x
   
   Execute the below command to install ZDM software.
     ```text
     <copy>
     ./zdminstall.sh setup oraclehome=/home/zdmuser/zdmhome oraclebase=/home/zdmuser/zdmbase ziploc=/tmp/zdm21.3/zdm_home.zip -zdm
     </copy>
     ```
     This will take couple of minutes.

     You will see output as below when ZDM service setup has been completed.

     ![Image showing ZDM service setup completion](./images/zdmservice.png)

10. Start ZDM service.

    Navigate using below command.

    **cd /home/zdmuser/zdmhome/bin**

    Execute below command to start ZDM.

    **./zdmservice start**

    You will receive similar output as below once ZDM has been successfully started.

    ![Image showing successful start of ZDM service](./images/zdm-service-start.png)

11. Check ZDM service status.

    Execute below command to see the ZDM servive status.

    **./zdmservice status**

    Sample output is given below.

    ![Image showing ZDM service status](./images/zdm-service-status.png)

    You have successfuly installed ZDM software , please proceed to next task.

## Task 3 : Configure SSH Connectivity from ZDM Host to Source and Target DB System

   Please follow the below steps to enable SSH connectivity from ZDM service host to Source and Target DB system.

1. Allow incoming connection on port 22 for Source and Target database subnet.

   You have deployed source database , target database and ZDM service host into the same Public subnet for the purpose of this lab.

   You need to ensure that incoming connection on port 22 is not blocked on Subnet level.

   No action needs to be taken for this lab since port 22 is already open by default for the Public subnet configured in this lab.

   However, you may need to take care of opening port 22 if your source and target deployment is different compared to the one specified in this lab.

2. Enable Source and Target hostname resolution from ZDM service host.

   You can enable Source and Target hostname resolution by adding the correspnding Database System IP and FQDN Details to **/etc/hosts** file in ZDM service host.

   Please follow below steps.

   a. Collect Source Database System details.

   Click the **Navigation Menu** in the upper left, navigate to **Compute** and then select **Instances**.

   ![Image showing navigation to compute instance](./images/navigate-to-compute.png)

   Click on the **ZDM-Source-DB** compute host as shown below.

   ![Image showing list of compute instances](./images/compute-list.png)

   Note down the **Private IP** and **Internal FQDN** under Primary VNIC section.

   ![Image showing private ip and  of source](./images/source-ip-fqdn.png)

   b. Collect Target Database System details.

   Click the **Navigation Menu** in the upper left, navigate to **Oracle Database** and then select **Oracle Base Database (VM,BM)**.

   ![Image showing navigation to Oracle Base Database](./images/navigate-oracle-base.png)

   Click on **zdm-target-db**.

   Click on **Nodes** under **Resources** section and note down the **Private IP** and **FQDN**.

   ![Image showing private ip and fqdn of target database](./images/target-ip-fqdn.png)
   
   c. Modify **/etc/hosts** file  in ZDM service host.

   Open the /etc/hosts file for editing using **sudo vi /etc/hosts** command as opc user.
   
   Insert Source and Target database system private IP and FQDN details to **/etc/hosts** file and save it.

   Sample output after editing is shown below.

   ![Image showing contents of hosts file](./images/etc-host.png)

3. Copy the private SSH key to ZDM host.

   Copy the SSH private key generated in lab 1 to ZDM service host under **zdmuser** home (/home/zdmuser).

   Please note that you are using same private key and public key pair for source database compute , target DB System and ZDM host in this lab.

   If you have different private keys for source and target database systems then you have to copy both of them to ZDM service host.

   Change the permission of private key as below.

   chmod 600 **key\_file\_name**

4. Verify SSH connectivity from ZDM servive host to Source and Target DB system.

   i. Execute the below command to test the ssh connectivity from ZDM service host to source database system.

   **ssh -i key\_file\_name opc@zdm-source-db**

   You will be logged in to the Source DB system if the connectivity is successful as shown below.

   ![Image showing successful ssh connectivity from zdm to source](./images/ssh-source-login.png)

   ii. Execute the below command to test the ssh connectivity from ZDM service host to Target database system.

   **ssh -i key\_file\_name opc@zdm-target-db**

   You will be logged in to the Target DB system if the connectivity is successful as shown below.

   ![Image showing successful ssh connectivity from zdm to target](./images/ssh-target-login.png)


You may now **proceed to the next lab**.

## Acknowledgements
* **Author** - Amalraj Puthenchira, Cloud Data Management Modernise Specialist, EMEA Technology Cloud Engineering
* **Last Updated By/Date** - Amalraj Puthenchira, March 2023




