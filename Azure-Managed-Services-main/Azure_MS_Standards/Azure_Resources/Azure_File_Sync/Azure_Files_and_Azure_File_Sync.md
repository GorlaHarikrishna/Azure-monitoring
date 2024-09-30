## Azure File and Azure File Sync

Azure File is an Azure native file services solution that is specifically designed for storing file server data. Azure File is contained within a storage account. An Azure File share can be mounted directly from a Windows server, from the Azure Portal, from the Azure Storage Explorer application, or via a traditional file server via Azure File Sync. Azure File Sync connects a traditional file server and Azure File to provide a seamless user experience and a highly scalable solution. Azure File Sync allows you to use your traditional file server as a cache server for recently accessed files, and all other files are stored in Azure File. Files that are stored in Azure File are recalled to the file server when an end user accesses the file. End users have the same user experience whether the file is cached on the file server or recalled from Azure File. Azure File Sync allows for a smaller storage footprint on traditional file servers and provides scalability up to 100 TB per Azure File share. Below are details on the components of Azure File Sync, resources to help with deployment, and the deployment process. 

### Resource Overview

*   Storage Sync Service: The Azure resource that facilitates the connection and synchronization between the file server(s) and the storage account(s).
    *   Registered Server: A file server that is connected to the Storage Sync Service for participation in Azure File Sync.
    *   Sync Group: The service that contains the connection to the Storage Account and Registered Servers. 
        *   Cloud Endpoint: The Sync Groups connection to the File share within the Storage Account. 
        *   Server Endpoint: The connection between the Registered Server and the Sync Group. This is where the file server directory to sync and cloud tiering settings are configured. 
*   Storage Account: The container for the Azure File share(s) where the file server data will be stored. 
    *   File Share: The individual share(s) where the data from the Registered Servers will be stored. 

### Deployment Recommendations

*   Create one Storage Sync Service and register all servers to it.
    *   Only create multiple Storage Sync Services when compliance or security requires segmentation of some or all servers.
*    General Purpose v2 Standard Storage Accounts are recommended for Azure File.
*   By default, an Azure File share can be up to 5 TB. If more than 5 TB is required for a share, you must enable large file shares on the Storage Account.
    *   Large File Shares only support ZRS or LRS for storage redundancy.
*   Data replication from the file server to Azure File begins when the Server Endpoint is created within a Sync Group.
*   Create a single Sync Group and Server Endpoint per file server drive letter, when possible.
    *   This will simplify your deployment as you can only define a single directory within the Server Endpoint. 
*   When using Azure File Sync and cloud tiering, the file server should not be backed up or only the OS drive should be backed up.
    *   Backup applications can recall all files to the file server, leading to high egress costs and an exceptionally long backup window.
    *   If files are not recalled by the server backup, a backup of the file server data drive(s) will only contain the cached files, not all files.
*   Configure Azure File backup within an Azure Recovery Services Vault.

### Deployment Process

*   Plan deployment 
    *   Review Azure File Sync documentation 
    *   Complete the Azure Namespace Mapping template 
    *   Define backup and disaster recovery plan for Azure File Sync
*   Create Storage Sync Service
    *   Add Private Endpoint (if desired) 
*   Create Storage account(s)
    *   Enable soft delete 
    *   Enable Large File Shares (if required)
    *   Add Private Endpoint (if desired) 
    *   Domain join storage account
    *   Create Azure File share(s) 
*   Download and install file server agent
    *   Register server(s) to the Storage Sync Service
    *   Limit Azure File Sync bandwidth on file server(s)
    *   Run server and data verification commands
        *   Verify any findings with Microsoft documentation
*   Create Sync Group(s)
    *   Add Cloud Endpoint(s)
    *   Add Server Endpoint(s)
        *   Configure Sync Directory and Cloud Tiering 
*   Configure Backup 

### Documentation and Resources

General Documentation: 

[https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-planning](https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-planning)

[https://www.youtube.com/watch?v=nfWLO7F52-s](https://www.youtube.com/watch?v=nfWLO7F52-s)

[https://docs.microsoft.com/en-us/azure/architecture/hybrid/hybrid-file-services](https://docs.microsoft.com/en-us/azure/architecture/hybrid/hybrid-file-services)

[https://docs.microsoft.com/en-us/azure/architecture/hybrid/azure-file-share](https://docs.microsoft.com/en-us/azure/architecture/hybrid/azure-file-share)

Azure File Sync Namespace Mapping Template:

[https://download.microsoft.com/download/1/8/D/18DC8184-E7E2-45EF-823F-F8A36B9FF240/Azure%20File%20Sync%20-%20Namespace%20Mapping.xlsx](https://download.microsoft.com/download/1/8/D/18DC8184-E7E2-45EF-823F-F8A36B9FF240/Azure%20File%20Sync%20-%20Namespace%20Mapping.xlsx)

Azure File Sync limits:

[https://docs.microsoft.com/en-us/azure/storage/files/storage-files-scale-targets](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-scale-targets)

AD Joining Storage Accounts:

[https://docs.microsoft.com/en-us/azure/storage/files/storage-files-active-directory-overview?toc=%2Fazure%2Fstorage%2Ffilesync%2Ftoc.json](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-active-directory-overview?toc=%2Fazure%2Fstorage%2Ffilesync%2Ftoc.json)

[https://docs.microsoft.com/en-us/azure/storage/files/storage-files-identity-ad-ds-enable](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-identity-ad-ds-enable)

File Server Data and Configuration Verification: 

[https://docs.microsoft.com/en-us/powershell/azure/install-Az-ps?view=azps-8.0.0](https://docs.microsoft.com/en-us/powershell/azure/install-Az-ps?view=azps-8.0.0)

Limit Azure File Sync Bandwidth:

[https://www.tecklyfe.com/how-to-limit-azure-file-sync-bandwidth/](https://www.tecklyfe.com/how-to-limit-azure-file-sync-bandwidth/)

Configure Azure File Backup:

[https://docs.microsoft.com/en-us/azure/backup/backup-afs](https://docs.microsoft.com/en-us/azure/backup/backup-afs)

Storage Sync Service and Storage Account Private Endpoint: 

[https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-networking-endpoints?tabs=azure-portal#create-the-storage-account-private-endpoint](https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-networking-endpoints?tabs=azure-portal#create-the-storage-account-private-endpoint)

Azure File Sync Troubleshooting Guide:

[https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-troubleshoot?tabs=portal1%2Cazure-portal](https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-troubleshoot?tabs=portal1%2Cazure-portal)