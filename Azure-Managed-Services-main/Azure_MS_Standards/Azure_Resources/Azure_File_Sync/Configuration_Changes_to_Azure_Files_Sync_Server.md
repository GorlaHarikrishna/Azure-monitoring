## Azure File Sync File Server Changes

Once Azure File Sync is configured and your data is uploaded to the storage account, the local file server is just a cache. If cloud tiering is enabled on the Sync Group, the data on the file server is often much smaller than it was previously. If that file server is a virtual machine in a public cloud environment (Azure, AWS, GCP, etc.) there can be significant cost savings by resizing the data disk of the file server. Alternatively, there may be a desire to move to a whole new file server. Because all of the file server data is stored in the Azure File share(s), the file server data drive or the server itself can easily be changed. 

### How to resize the file server data disk? 

As you cannot shrink a drive once it's been deployed, the resize process is really a replacement process. Below are the steps for completing this process.

1.  Navigate to the Storage Sync Service and open the Sync Group for the file server you'd like to replace.
2.  Select the server endpoint for the data disk that you want to replace.
3.  Take a screen shot of the server endpoint settings and save it for later.
4.  Shut down the virtual machine and add a new data disk.
5.  Power on the server.
6.  Initialize the new disk and add a partition with an available drive letter. 
7.  On the file server, backup the registry keys that contain the share information and save it to the desktop (or somewhere else that is convenient). 
8.  On the file server, verify there are no open files or sessions. If there are, close them. 
9.  In the Sync Group, remove the server endpoint without recalling the data to the file server.
10.  Once the server endpoint has been removed, you're ready to make the drive changes.
11.  On the file server, change the drive letter of the current (larger) data drive to an available drive letter.
12.  On the file server, change the drive letter of the new (smaller) drive to the drive letter of the old (larger) drive. 
13.  In the Sync Group, recreate the server endpoint based on the settings from the screen shot taken in step 3. 
14.  Once the storage endpoint is created, it will begin copying the namespace of the files and folders to the new drive. 
15.  Once the namespace has been downloaded to the new drive, restart the lanman services.
16.  Verify that the file shares are correct and test the shares and opening a file.
17.  If the shares are not correct, load the registry key backup and restart the server. 

### How to migrate to a new file server?

1.  Create and configure the new file server
2.  Register the new file server with the Storage Sync Service
3.  Navigate to the Storage Sync Service and open the Sync Group for the file server you'd like to replace.
4.  Select the server endpoint for the data disk that you want to replace.
5.  Take a screen shot of the server endpoint settings and save it for later. 
6.  On the current file server, verify there are no open files or sessions. If there are, close them. 
7.  In the Sync Group, create a new server endpoint for the new file server based on the settings from the screen shot taken in step 5.
8.  Once the storage endpoint is created, it will begin copying the namespace of the files and folders to the new drive. 
9.  Once the namespace has been downloaded to the new drive, restart the lanman services.
10.  Verify that the file shares are correct and test the shares and opening a file.
11.  In the Sync Group remove the server endpoint for the old server without recalling the data to the file server.
12.  Shut down the old file server.
13.  Update DNS entry for the file server to point to the new server.
14.  Verify that the shares are working correctly. 

### Resources: 

[https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/azure-file-sync-switching-server-endpoint-on-existing-server/ba-p/2553169](https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/azure-file-sync-switching-server-endpoint-on-existing-server/ba-p/2553169)

[https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-server-registration](https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-server-registration)

[https://docs.microsoft.com/en-us/troubleshoot/windows-client/networking/saving-restoring-existing-windows-shares](https://docs.microsoft.com/en-us/troubleshoot/windows-client/networking/saving-restoring-existing-windows-shares)