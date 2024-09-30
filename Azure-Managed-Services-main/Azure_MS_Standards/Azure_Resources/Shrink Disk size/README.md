**Purpose:**

The purpose of this script is to shrink disk size to save cost.

**Pre-Requisites:**

- VM should be in running state
- Ability to remote into the VM

**What does the script do**

	- Creates a temporary storage account
	- Creates a new temp disk in the new Storage Account to read the footer from
	- Copies the Managed Disk into temporary Storage Account
	- Changes the footer (size)
	- Converts the disk back to Managed Disk
	- Swaps the VM's Current OS disk with the new smaller disk
	- Deletes the temporary storage account and the old managed disk
	- Starts the VM

**Shrink Disk**

	- Create a snapshot of  disk in azure portal as a backup plan
	- Run below commands by remote logging into the VM that you would like to shrink the disk size.
          Get-Partition -DiskNumber 0
          Get-Partition -DiskNumber 0 -PartitionNumber 2 | Resize-Partition -Size **GB (Select the PartitionNumber and choose the disk you would like to shrink the disk to)
	- Stop the VM
	- Change below variables in the powershell script as required
	1. DiskID
	2. VmName
	3. DiskSizeGB
        4. AzSubscription
       - Wait until the script executes successfully(this may take 15-30 minutes depending on the size of the disk)
       - Extend the volume of the disk by logging into the VM
