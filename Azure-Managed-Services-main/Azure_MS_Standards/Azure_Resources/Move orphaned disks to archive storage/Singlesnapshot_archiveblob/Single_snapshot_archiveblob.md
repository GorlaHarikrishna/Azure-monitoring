#Provide the subscription Id of the subscription where snapshot is created
$subscriptionId = ""

#Provide the name of your resource group where snapshot is created
$resourceGroupName =""

#Provide the snapshot name 
$snapshotName = ""

#Provide Shared Access Signature (SAS) expiry duration in seconds e.g. 3600.
#Know more about SAS here: https://docs.microsoft.com/en-us/Az.Storage/storage-dotnet-shared-access-signature-part-1

#Provide storage account name where you want to copy the snapshot. 
$storageAccountName = ""

#Name of the storage container where the downloaded snapshot will be stored
$storageContainerName = ""
$DestContainerName = ""

#Provide the key of the storage account where you want to copy snapshot. 
$storageAccountKey = ''

#Provide the name of the VHD file to which snapshot will be copied.
$pageblobVHDFileName = ""
$archiveVHDFileName = ""
 

# Set the context to the subscription Id where Snapshot is created
Select-AzSubscription -SubscriptionId $SubscriptionId
#Get the storage account context for the VHD blobs
$storageAccountContext = (Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -AccountName $storageAccountName).context

#Generate the SAS for the snapshot 
$snapshotSAS = Grant-AzSnapshotAccess -ResourceGroupName $ResourceGroupName -SnapshotName $SnapshotName -DurationInSecond 86400 -Access Read

#Generate the SAS for the storage account - valid for 24 hours
$storageaccountSAS = New-AzStorageAccountSASToken -Context $storageAccountContext -Service Blob -ResourceType Service,Container,Object -Permission "rw" -ExpiryTime (Get-Date).AddDays(1)

$destinationContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
#Copy snapshot to page blob
Start-AzStorageBlobCopy -AbsoluteUri $snapshotsas.AccessSAS -DestContainer $storageContainerName -DestContext $destinationContext -DestBlob $pageblobVHDFileName
#azcopy cp $snapshotSAS.accessSAS "https://$storageAccountName.blob.core.windows.net/$storageContainerName/$pageblobVHDFileName$storageaccountSAS" --recursive=true

#Copy-AzStorageBlob -SrcContainer $StoragecontainerName -SrcBlob $srcblobName -Context $ctx -DestContainer $destcontainerName -DestBlob $destblobName -DestContext $ctx -DestBlobType Block -StandardBlobTier $destTier
Get-AzStorageBlob -Container $storagecontainerName -Blob $pageblobVHDFileName -Context $StorageAccountContext | Copy-AzStorageBlob -DestContainer $destContainerName -DestBlob $archiveVHDFileName -DestBlobType block -DestContext $ctx 

#Delete page blog
Remove-AzStorageBlob -Container $storageContainerName -Blob $pageblobVHDFileName -Context $storageAccountContext

#Set block blob to archive tier
$archiveblob = Get-AzStorageBlob -Container $storageContainerName -Blob $archiveVHDFileName -Context $storageAccountContext
$archiveblob.BlobClient.SetAccessTier("Archive", $null, "Standard")
