Purpose:

The purpose of this script is to move orphaned disk snapshots to archive storage.

Pre-Requisites:

Create snapshots for each orphaned disk
Gather SubscriptionID, resource groupname, storage Account name, Storage Account Key information
Create two containers in storage account. One for source and another for destination

Export list of orphaned disks to excel sheet from azure runbook to use Multiple snapshots to archive blob script with below columns:
 - SnapshotName
 - pageblobVHDFileName
 - archiveVHDFileName
   
What does the script do:
- Grants Read access to the snapshot
- Generates SAS Token for the storage account with read and write access
- Copies snapshot to page blob
- Copies page blob to block blob
- Deletes page blob
- Sets the block blob to archive tier 
