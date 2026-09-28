# Lab 1: Deploy and Validate the Cloud-Native AI Workload in the Primary Region OKE Cluster
## Introduction

Deploy the AI document application in the primary OKE cluster. Verify its components before configuring disaster recovery.

Watch the video below for a quick walk-through of the lab.
[Deploy AI Workload](videohub:1_24gs4wgc)

**Before you begin**

Complete the workshop introduction. Confirm your OCI credentials, compartment, and region information.

- **Primary region:** Ashburn (`us-ashburn-1`)
- **Standby region:** Phoenix (`us-phoenix-1`)

Run all commands from Cloud Shell in the Ashburn region. Do not use a local terminal or Cloud Shell in another region.

The application runs in the Kubernetes namespace `ai-fsdr-lab`. Use `-n ai-fsdr-lab` with `kubectl` commands throughout the workshop.

Estimated Time: 15 minutes

### Objectives

In this lab, you will:

- Deploy the application to the primary region.
- Confirm that the application components are running.
- Start cross-region replication for the Ollama application volume.
- Use the application to submit a question and upload a document.

## Task 1: Gather the Database OCID and Download the Script Package

1. Sign in to the OCI Console with the credentials provided with the lab environment. Make sure to select the **Ashburn** region (`us-ashburn-1`).
    
    ![Ashburn region console](./images/ashburn-region-console.png)

    After signing in, open the profile menu and select **Console settings**.

    ![Open OCI Console settings](./images/console-settings.png)

    Under **Display settings**, select **Dark mode**, then click **Update**. Use Dark mode for the remaining steps in this lab. If you prefer **Light mode**, you can continue to the next step without changing the setting.

    ![Select Dark mode in OCI Console settings](./images/display-settings-dark-mode.png)

2. In the OCI Console, open the navigation menu. Select **Oracle AI Database**, then **Autonomous AI Database**.

    **Compartment:** Select the compartment assigned to you.

    ![Oracle ADB menu](./images/adb-menu.png)

    Select the compartment (**LLXXXXXX-COMPARTMENT**) shown in the lab instructions. You can verify it with **View Login Info** at the top left of the instructions page. **LLXXXXXX** is the user name used to sign in to the OCI Console.

    Use the compartment selector's search field to enter your assigned compartment name, such as **LLXXXXXX-COMPARTMENT**, and then select the matching compartment from the results.
    
    **Expected result:** You should see an Autonomous Transaction Processing (ATP) database. In this workshop, **ATP** refers to the Autonomous AI Database used by the application. If you do not see one, verify the compartment. Its name should resemble **FsrAiAppDB-XXXXXX**.

    ![ATP Database](./images/atp-database.png)

    Open the three-dot menu (...) beside the ATP database. Select the option to copy the ATP OCID, then save it for use in **Task 2**.

    ![ATP Database OCID](./images/atp-database-ocid.png)


3. Before opening Cloud Shell, verify that the OCI Console is set to your assigned compartment, **LLXXXXXX-COMPARTMENT**. Selecting the correct compartment ensures that you can view and use the lab resources.

    Open **Cloud Shell** using the Developer tools (computer) icon next to **Ashburn**. Confirm that the Cloud Shell session region is `us-ashburn-1`, then keep this session open for the remaining commands.

    ![Navigate to Cloud Shell](./images/cloud-shell.png)

    Cloud Shell home directory opens after a few seconds and displays the prompt. If the tutorial appears, enter **N** to close it.

    ![Cloud Shell prompt](./images/cloud-shell-prompt.png)

    **Note:** Select the assigned compartment and open a lab resource, such as **Autonomous AI Database**, before opening Cloud Shell. If you open Cloud Shell directly without first selecting the compartment and resource, you may see a **Policy missing** error stating that you are not authorized to access Code Editor. Close the error, return to the OCI Console, select the correct compartment, and then open Cloud Shell from the resource page.

    ![Cloud Shell Policy missing error](./images/cloud-shell-policy-missing.png)

4. Download the application package from the Object Storage URL provided with the lab environment.

    **Ashburn Cloud Shell**

    ```bash
    <copy>
    wget -O oci-ai-resiliency-lab.zip 'https://idfwhcj05ugj.objectstorage.us-ashburn-1.oci.customer-oci.com/p/dIx74t1ht57X3smpT37SmYRdq8ohGV7bGjZxwjFgkCVd0QdOjsdI-wwNkVO_sgjX/n/idfwhcj05ugj/b/fsdrs/o/oci-ai-resiliency-lab.zip' && ls -ltr oci-ai-resiliency-lab.zip
    </copy>
    ```

    Press **Enter** to run the command. The file listing appears automatically after the download completes.
    ![Download application package](./images/download-application-package.png)

5. Extract the package and enter its directory.

    **Ashburn Cloud Shell**

    ```bash
    <copy>
    unzip oci-ai-resiliency-lab.zip && cd oci-ai-resiliency-lab
    </copy>
    ```
    ![Extract application package](./images/extract-application-package.png)

## Task 2: Deploy the Application and Configure Replication

1. Run the deployment script.

    In the Ashburn Cloud Shell, run:

    ```bash
    <copy>
    ./bootstrap-ai-fsdr-lab.sh
    </copy>
    ```

    When prompted, enter these values. **Passwords are not visible while you type them in Cloud Shell. This is expected.** Enter each password twice so the script can catch typing mistakes before deployment begins. Press **Enter** after each value.

    - **Database username: `ADMIN`**
    - **Database password: `AIWorld2026!`**
    - **Wallet password: `Admin123`**
    - **Ashburn ATP OCID: the OCID copied in Task 1, Step 2**

    **Note:** An incorrect database or wallet password will cause the deployment to fail.

    Verify each value, then press **Enter**.

    ![Deploy AI application](./images/deploy-ai-application.png)

2. Monitor the deployment. It takes approximately 5 minutes.

    If deployment fails, the script explains the likely cause and asks whether you want to retry. Choose whether to replace the ADB password, wallet password, or both. The existing Kubernetes resources are reused; cleanup is not required. The script allows up to three attempts. If you stop or use all attempts, verify the ADB username, ADB password, wallet password, selected ATP, and wallet, then rerun `./bootstrap-ai-fsdr-lab.sh`.

    ![Monitor AI application deployment](./images/monitor-ai-application-deployment-1.png)

    **Expected result:** The script returns to the shell prompt without an error. If it reports an error, verify the values from Step 1 and rerun the step.

    If the deployment output displays an **Application URL**, open it in a separate browser tab. If it is not displayed, you will retrieve the URL in Step 4.

    ![Monitor AI application deployment](./images/monitor-ai-application-deployment-2.png)

3. Start cross-region replication for the application data volume.

    In the Ashburn Cloud Shell, run:

    ```bash
    <copy>
    ./configure-crr-after-deploy.sh
    </copy>
    ```
    ![Start cross-region replication](./images/start-cross-region-replication.png)


4. Verify that the application resources are running in the `ai-fsdr-lab` namespace. Full Stack DR uses this namespace for the application resources.

    In the Ashburn Cloud Shell, run:

    ```bash
    <copy>
    kubectl -n ai-fsdr-lab get pods,svc,pvc
    </copy>
    ```
    ![Application details](./images/application-details.png)

    The `ai-frontend` service's **External IP** is the application URL. If no external IP appears, wait a few moments and run the command again. You will validate the application in the next task.


## Task 3: Validate the AI Application Without and With RAG

1. Open the application URL in a separate browser tab. The URL may take a short time to become reachable after the External IP is assigned.

    Confirm that **Active DB region** and **Connected DB region** show `us-ashburn-1`. Check that the API, Autonomous DB, and Ollama statuses show **ok** or **up**, and that the model is `granite4.1:3b`.

    ![Primary Ashburn application showing healthy services and the Granite model](./images/validate-ai-application-primary.png)

    Under **ADB-backed documents**, confirm that **No documents yet** appears. Leave **Use uploaded documents when available** checked. With no documents available, the application sends your question directly to Granite without retrieved context.

    In **Chat with Granite**, enter the following question and click **Ask**:

    **What is OCI Full Stack Disaster Recovery?**

    **Response time:** Each response may take about a minute because this demo application runs on an OKE cluster with a small node pool and limited compute resources. Wait for the response to complete before asking another question. Response times can vary.

    ![Ask Granite a question with an empty document list](./images/ask-granite-without-documents.png)

    Confirm that Granite returns an answer. Below the response, check for **Without RAG — direct Granite response** and no document sources. Your answer may differ from the example.

    ![Granite response without RAG before uploading a document](./images/validate-ai-response-without-rag.png)

    **RAG note:** Retrieval-augmented generation (RAG) adds retrieved document text to the question sent to Granite. The first response uses no document context. After you upload a document, the application can retrieve its text chunks to help generate an answer.

    **Existing environments:** If documents are already listed, uncheck **Use uploaded documents when available** before asking the first question. This bypasses all stored documents without deleting them. The deployment smoke test may also appear in **ADB-backed history**; chat history is not sent to Granite as context.

2. Upload the documentation to test RAG.

    Download the [OCI Full Stack Disaster Recovery official documentation](https://c4u02.objectstorage.us-ashburn-1.oci.customer-oci.com/p/9DEArLjsgbKXuJgQtSG95E8hMXRFtxgHR8jiHbqz4HgyVYXVnSo0SC_s-zq5CJA3/n/c4u02/b/hosted-files/o/OCI%20Full%20Stack%20DR%20doc.pdf) to your local computer, not to Cloud Shell.

    Under **Upload a document**, select the PDF and click **Upload & Index**. Wait for the indexing confirmation and verify that the PDF appears under **ADB-backed documents**.

    The application splits the document into text chunks and stores them in Autonomous AI Database. It uses keyword scoring to select chunks as context for Granite.

    ![Upload FSDR documentation](./images/upload-fsdr-doc.png)

3. Select **Use uploaded documents when available**, then enter the same question and click **Ask**:

    **What is OCI Full Stack Disaster Recovery?**

    Confirm that the response is labeled **With RAG — document context used**. Unlike the generic response in Step 1, which used Granite's model knowledge without document context, this answer is generated using excerpts retrieved from the documentation you uploaded in Step 2. It should reflect the information in that document.

    Review the **Sources** filenames and excerpts below the response to confirm that the uploaded PDF was used and that the answer accurately reflects the documentation. RAG grounds the answer in document content, but does not guarantee correctness. The generated wording may vary.

    ![Granite response using RAG after uploading the documentation](./images/validate-ai-response-with-rag.png)

In Lab 2, you will configure OCI Full Stack Disaster Recovery for this AI workload, including the primary and standby DR protection groups and their recovery plans.

You may now [proceed to the next lab](#next).

## Acknowledgements

* **Author** - Suraj Ramesh, Lead Principal Product Manager, Oracle Database High Availability (HA), Scalability and Maximum Availability Architecture (MAA)
* **Last Updated By/Date** - September 2026
