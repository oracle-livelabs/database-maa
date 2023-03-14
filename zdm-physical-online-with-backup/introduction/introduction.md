# Introduction

## About this workshop

This workshop covers a step-by-step guide for migrating On-premises Oracle Databases to Oracle Co-Managed databases using ZDM's Physical Online workflow with the backup location. 

Estimated Time: 3 hours


### About Zero Downtime Migration

Oracle Zero Downtime Migration (ZDM) is the Oracle Maximum Availability Architecture (MAA)-recommended solution to migrate Oracle Databases to the Oracle Cloud. ZDM's inherent design keeps the migration process as straightforward as possible and ensures the most negligible impact on production workloads. The Source Database to be migrated can be on-premises, deployed on Oracle Public Cloud Gen 1 or Oracle Cloud Infrastructure. The Target Database deployment can be in a Database Cloud Service on Oracle Cloud Infrastructure (Oracle Cloud Infrastructure) Virtual Machine, Exadata Cloud Service, Exadata Cloud at Customer, or Autonomous Database. ZDM automates the entire migration process, reducing the chance of human errors. ZDM leverages Oracle Database-integrated high availability (HA) technologies such as Oracle Data Guard and GoldenGate and follows all MAA best practices that ensure no significant downtime of production environments. Oracle ZDM supports both Physical and Logical Migration workflows. 

Oracle ZDM supports Oracle Database versions 11.2.0.4, 12.1.02, 12.2.0.1, 18c, 19c & 21c. ZDM’s physical migration workflow requires the source and target databases to be in the same database release.  Starting with ZDM 21.1, the Logical Migration workflow supports cross-version migration, thus providing an in-flight upgrade while migrating to the Oracle Cloud.

Oracle ZDM allows the source database to be a non-CDB or a container database (CDB) with one or more Pluggable Databases (PDBs). Starting with release 21.1, Oracle ZDM allows non-CDB Databases to be migrated to Pluggable Databases on the fly, allowing for total conversion and adding more versatility to the migration workflow. 

The Zero Downtime Migration software offers a command line interface that you install and run on a host that you provision. The server where the Zero Downtime Migration software is installed is called the Zero Downtime Migration service host. You can run one or more database migration jobs from the Zero Downtime Migration service host.



### Supported Physical Migration Paths

Zero Downtime Migration supports the following physical migration paths.

* On-premises Oracle Database to Oracle Cloud Infrastructure (either virtual machine or bare metal).
* On-premises Oracle Database to Exadata Cloud Service.
* On-premises Oracle Database to Oracle Exadata Cloud at Customer.
* On-premises Oracle Database to On-Premises Exadata Database Machine.
* Oracle Cloud Infrastructure Classic Database to Oracle Cloud Infrastructure (either virtual machine or bare metal).
* Oracle Cloud Infrastructure Database to a database in another Oracle Cloud Infrastructure region.
  For example, you can move a database from the phoenix commercial OCI region to the frankfurt or ashburn region.

### Supported Logical Migration Targets

Zero Downtime Migration supports logical database migration to the following target databases.

* Oracle Autonomous Database Shared (Data Warehouse or Transaction Processing).
* Oracle Autonomous Database Dedicated Infrastructure (Data Warehouse or Transaction Processing).
* Oracle Autonomous Database on Exadata Cloud@Customer.
* Oracle Co-managed Database Systems:
  Virtual Machine
  Bare Metal
  Exadata Cloud Service
  Exadata Cloud at Customer
* On premises Exadata Database Machine.
* Autonomous Database on Dedicated Infrastructure and Autonomous Database on Cloud@Customer with fractional OCPU allocation, where a   
  
  fraction of OCPU is allocated per database service, instead of integer OCPU.

  You can specify any predefined fractional service alias available; however, for Autonomous Transaction Processing workloads TP* services are preferred over LOW* services because LOW* is meant for low priority batch jobs.

      * TP\_TLS, TP, LOW\_TLS, or LOW (for Autonomous Transaction Processing workloads).
      * LOW\_TLS or LOW (for Autonomous Data Warehouse workloads).
  
### Migration Workflows


#### Physical Offline Migration
ZDM physical offline migration leverages Oracle Recovery Manager and migrates the database using a backup and restore methodology. Customers can use this method when migrating to Oracle Database Cloud Services Virtual Machines, Exadata Cloud Service, Exadata Cloud at Customer and Exadata Database Machine On-Premises. 

![Zero Downtime Migration Physical Offline Workflow Step-by-Step high level description](./images/physical-offline-workflow.png " ")




#### Physical Online Migration
ZDM physical online migration leverages Oracle Recovery Manager and Oracle Data Guard. Customers should use this method when a highly available migration and minimizing any possible impact is a priority. Customers can use this method to migrate to Oracle Base Database service, Oracle Exadata Database Service on Dedicated Infrastructure, Oracle Exadata Cloud at Customer and Exadata Database Machine On-Premises.

![Zero Downtime Migration Physical Online Workflow Step-by-Step high level description](./images/physical-online-workflow.png " ")


#### Logical Offline Migration with Backup Location
ZDM logical offline migration with Data Pump and Backup Location offers customers a simple yet efficient method to migrate their databases to the Oracle Cloud. The backup location can be the Object Storage for Oracle Cloud Infrastructure migrations and NFS or the Recovery Appliance for Exadata Cloud at Customer.

![Zero Downtime Migration Logical Offline with Backup Location Workflow Step-by-Step high level description](./images/logical-offline-backup-workflow.png " ")

#### Logical Offline Migration with Database Links
ZDM offline logical migration can also leverage Database Links to establish a direct connection between the source database and the target database in the Oracle Cloud, thus eliminating the need for a backup location. This methodology is recommended only for Databases smaller than 100Gb.

![Zero Downtime Migration Logical Offline with Database Links Workflow Step-by-Step high level description](./images/logical-offline-dblinks-workflow.png " ")

#### Logical Online Migration with Database Links
Oracle ZDM leverages a GoldenGate hub that will help synchronize both the source and target database while providing a highly available migration. Database Links are used for a direct connection between source and database target while the instantiation of the target database is done by using Data Pump.

![Zero Downtime Migration Logical Online with Database Links Workflow Step-by-Step high level description](./images/logical-online-dblinks-workflow.png " ")

#### Logical Online Migration with Backup Location
Customers can also leverage a designated backup location instead of using a direct Database Link between the source and the target database. Migration to Oracle Cloud Infrastructure-based databases will use the Object Store, whereas migrations to Exadata Cloud at Customer can choose between an external NFS filer or the Recovery Appliance as a backup location.

![Zero Downtime Migration Logical Online with Backup Location Workflow Step-by-Step high level description](./images/logical-online-backup-workflow.png " ")


For more information on Oracle Zero Downtime Migration please visit ZDM's [product website](http://www.oracle.com/goto/zdm).


### Objectives

In this lab, you will perform below :

* Learn about Oracle Zero Downtime Migration Fundamentals.
* Create SSH keys.
* Provision source database.
* Provision target database.
* Provision and configure ZDM service host.
* Prepare source database.
* Prepare target database.
* Create Object Storage Bucket and Auth Token.
* Migrate database.

### Prerequisites

This workshop requires an Oracle Cloud account.

## Learn More

* [Oracle Zero Downtime Migration - Product Page](http://www.oracle.com/goto/zdm)
* [Oracle Zero Downtime Migration - Product Documentation](https://docs.oracle.com/en/database/oracle/zero-downtime-migration/)
* [Oracle Zero Downtime Migration - Logical Migration Step by Step Guide](https://www.oracle.com/a/tech/docs/oracle-zdm-logical-migration-step-by-step-guide.pdf)
* [Oracle Zero Downtime Migration - Physical Migration Step by Step Guide](https://www.oracle.com/a/tech/docs/oracle-zdm-step-by-step-guide.pdf)

You may now **proceed to the next lab**.

## Acknowledgements
* **Author** - Ricardo Gonzalez, Senior Principal Product Manager, Oracle Cloud Database Migration
* **Contributors** - LiveLabs Team, ZDM Development Team
* **Last Updated By/Date** - Amalraj Puthenchira , Cloud Data Management Specialist , March 2023
