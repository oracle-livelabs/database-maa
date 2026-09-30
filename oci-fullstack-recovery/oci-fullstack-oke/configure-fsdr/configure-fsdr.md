# Lab 2: Configure Full Stack DR for the AI Workload

## Introduction

Configure OCI Full Stack DR for the AI application deployed in Lab 1. Keep the original Ashburn Cloud Shell session available.

This lab creates DR protection groups and plans for the primary and standby regions. The Start Drill plan converts the standby Autonomous AI Database to the Snapshot Standby role, restores the application to the standby OKE cluster, and restores its associated storage when you execute the plan in Lab 3.

Watch the video below for a quick walk-through of the lab.
[Configure Full Stack DR](videohub:1_zwchhrdr)

Run the commands from the Ashburn Cloud Shell used in Lab 1.

**Before you begin:** Complete Lab 1 and keep the original Ashburn Cloud Shell session available.

The AI application runs in the Kubernetes namespace `ai-fsdr-lab`. Full Stack DR protects and restores the OKE resources in this namespace.

Estimated Time: 15 minutes

### Objectives

In this lab, you will:

- Run the Full Stack DR configuration script.
- Confirm that the configuration completes successfully.
- Verify the DR protection groups and DR plans in the OCI Console.

## Task 1: Configure Full Stack DR

1. In the Ashburn Cloud Shell, change to the application directory created in Lab 1.

    Run:

    ```bash
    <copy>
    cd ~/oci-ai-resiliency-lab
    </copy>
    ```

2. Run the Full Stack DR configuration script.

    Before you run the script, review the configuration flow. The script performs these actions in order:

    - Creates a DR protection group in the standby region.
    - Adds the standby OKE cluster and standby ATP to the standby DR protection group.
    - Creates the primary DR protection group in the primary region and associates it with the standby DR protection group using the **Primary** role.
    - Adds the primary OKE cluster, primary ATP, and Ollama volume group to the primary DR protection group.
    - Creates the **Switchover**, **Failover**, and **Start Drill** plans in the standby DR protection group.

    In the Ashburn Cloud Shell, run:

    ```bash
    <copy>
    ./scripts/configure-fsdr-snapshot-standby.sh
    </copy>
    ```

    As part of the Full Stack DR configuration experience, you will use the script interactively at each resource-creation phase. It pauses before creating the standby DR protection group, before creating and associating the primary DR protection group, and once before the combined Switchover, Failover, and Start Drill plan-creation phase. At each prompt, review the region and resources listed, then press **Enter** to continue or type `q` to stop. Allow the preceding work request to complete before continuing to the next prompt.

    ![Lab 2 snapshot standby script paused before creating the standby DR protection group](./images/fsdr-snapshot-standby-pause-standby.png)

    After you press **Enter** and the work request completes, the standby DR protection group is created and the standby ATP and OKE cluster are added as members.

    ![Lab 2 snapshot standby script paused before creating the primary DR protection group](./images/fsdr-snapshot-standby-pause-plans.png)

    After you press **Enter** and the work request completes, the primary DR protection group is created, associated with the standby group, and populated with the primary ATP, OKE cluster, and Ollama volume group. The script then pauses again before creating the three DR plans.

    ![Lab 2 snapshot standby script paused before creating the Switchover, Failover, and Start Drill plans](./images/fsdr-snapshot-standby-complete.png)

    Press **Enter** to start creating the Switchover, Failover, and Start Drill plans. Plan creation takes approximately **7–8 minutes**. While the plans are being created, continue to **Task 2: Monitor the Configuration in the OCI Console**. Keep the Ashburn Cloud Shell tab open.

    When the script finishes, return to Task 1. Confirm that it returns to the shell prompt and displays the OCIDs for the primary and standby protection groups and the three DR plans. The complete configuration takes approximately 10 minutes, excluding time spent at the confirmation prompts.

    ![Lab 2 snapshot standby DR plans created successfully](./images/fsdr-snapshot-standby-plans-created.png)

## Task 2: Monitor the Full Stack DR Configuration in the OCI Console

1. While the script runs, open two additional OCI Console tabs. Set one to **Ashburn** and the other to **Phoenix**. Keep the Ashburn Cloud Shell tab open. In each Console tab, select **Migration & Recovery**, then **Recovery**, and then **Disaster Recovery**.

    **Ashburn:**

    ![OCI Console navigation menu showing Migration & Recovery, Recovery, and Disaster Recovery in Ashburn](./images/oci-navigation-ashburn-disaster-recovery.png)

    **Phoenix:**

    ![OCI Console navigation menu showing Migration & Recovery, Recovery, and Disaster Recovery in Phoenix](./images/oci-navigation-phoenix-disaster-recovery.png)

2. In both OCI Console tabs, change to the compartment assigned to you. Expand the root compartment, select **Livelabs**, and then select your assigned compartment.

3. Open **DR Protection groups** in each Console tab and monitor the pages as the primary and standby protection groups are created. Refresh the Console tabs periodically if the resources do not appear immediately; do not refresh the Cloud Shell tab. Verify the region-specific names:

    - **Ashburn:** `fsdr-rag-primary-xxxxxx`
    - **Phoenix:** `fsdr-rag-standby-xxxxxx`

    The `xxxxxx` suffix is generated for your environment and may differ from the examples.

    Verify the protection group roles. The `fsdr-rag-primary-xxxxxx` protection group shows the **Primary** role, and the `fsdr-rag-standby-xxxxxx` protection group shows the **Standby** role.

    ![Ashburn Full Stack DR protection groups](./images/ashburn-full-stack-dr-protection-groups.png)

    ![Phoenix Full Stack DR protection groups](./images/phoenix-full-stack-dr-protection-groups.png)

4. As the configuration progresses, verify that the protection groups contain the expected AI workload resources as members.

    - In the Ashburn region, select `fsdr-rag-primary-xxxxxx` and open the **Members** tab. Confirm that it contains the primary OKE cluster, primary ATP, and Ollama volume group.

    ![Ashburn Full Stack DR protection groups members](./images/ashburn-full-stack-dr-protection-groups-members.png)

    - In the Phoenix region, select `fsdr-rag-standby-xxxxxx` and open the **Members** tab. Confirm that it contains the standby OKE cluster and standby ATP.

    ![Phoenix Full Stack DR protection groups members](./images/phoenix-full-stack-dr-protection-groups-members.png)

5. After the configuration script in Task 1 completes successfully in the Ashburn Cloud Shell, use the Phoenix Console tab to open the plans for the **standby DR protection group**. Confirm that the following plans are available:

    ![Full Stack DR plans](./images/full-stack-dr-plans.png)

    **Expected recovery plans**

    | Plan type | Plan name |
    | --- | --- |
    | Switchover | `fsdr-rag-xxxxxx-switchover` |
    | Failover | `fsdr-rag-xxxxxx-failover` |
    | Start Drill | `fsdr-rag-xxxxxx-start-drill` |

    **Note:** Full Stack DR allows you to create and execute DR plans only from the DR protection group with the **Standby** role.

    The `xxxxxx` portion is generated for your environment and may differ from the example.

6. Open each plan and review its task groups. Expand the groups to understand the order of operations. Do not start or execute a plan.

    A plan group is an ordered collection of recovery tasks that Full Stack DR executes as part of a plan. Full Stack DR creates the plans in the standby DR protection group. You can create plans, run plan prechecks, and execute plans only from the standby DR protection group.

    Each plan group contains individual plan steps. Full Stack DR generates these steps from the members and dependencies added to the DR protection group, so the steps can differ between environments.

    At a high level, expect the following plan types and task categories:

    | Plan type | Purpose | Expected task categories |
    | --- | --- | --- |
    | **Switchover** | Planned transition from the Ashburn primary environment to the Phoenix standby environment. | Prechecks, database and application role transitions, OKE and storage operations, and post-transition validation. |
    | **Failover** | Recovery when the Ashburn primary environment is unavailable. | Recovery prechecks, standby activation, application and database recovery, OKE and storage operations, and validation. |
    | **Start Drill** | Test the recovery workflow without changing the production role of the application. | Prechecks, drill-specific database and application operations, OKE and storage actions, and application validation. |

    The following console views show the task groups generated for each plan type:

    **Switchover plan**

    ![Switchover plan groups in the standby DR protection group](./images/fsdr-switchover-plan-groups.png)

    **Failover plan**

    ![Failover plan groups in the standby DR protection group](./images/fsdr-failover-plan-groups.png)

    **Start Drill plan**

    ![Start Drill plan groups in the standby DR protection group](./images/fsdr-start-drill-plan-groups.png)

    The **Start Drill** plan uses these resources to create a recovery test environment without changing the production roles of the DR protection groups.

    **Important:**

    - Do not run or precheck any plan in Lab 2. The **Start Drill** plan runs in Lab 3.
    - After a successful **Start Drill**, you can create a **Stop Drill** plan to end the drill and restore the environment. Running it is outside the scope of this workshop.
    - **Switchover** and **Failover** change the DR protection group roles. **Start Drill** and **Stop Drill** do not change the roles.
    - This workshop uses the built-in plan groups. User-defined plan groups are not covered; use **Manage plan groups** to customize plans.

In Lab 3, you will run prechecks and execute the **Start Drill** plan, then monitor the drill execution until it succeeds.

You may now [proceed to the next lab](#next).

## Acknowledgements

* **Author** - Suraj Ramesh, Lead Principal Product Manager, Oracle Database High Availability (HA), Scalability and Maximum Availability Architecture (MAA)
* **Last Updated By/Date** - September 2026
