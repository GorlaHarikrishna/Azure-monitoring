
                              **VM Decommission Process in Azure**

**Request:** Request for VM decommission should be from an authorized person from customer.

**Backup Data**: Before decommissioning the VM, ensure that all necessary data has been backed up and retain backups according to customer retention policy.

**Monitoring**: Remove VM from Monitoring tool (Logic Monitor).

**Deallocate Resources**: Deallocate the VM resources within the Azure portal. This action stops the VM but retains its configuration settings, disks, and network interfaces. It also stops billing for the VM.

**Remove Resources**: Delete Virtual Machine, remove any remaining resources that are no longer needed, such as disks or network interfaces related to the Virtual machine, from the resource group.

**Release IP Addresses**: If the VM had any associated public IP addresses, release them to prevent unnecessary costs.

**Review network and firewall rules**: Review any network and firewall rules that were associated with it to ensure that no ports or services are still open that could allow unauthorized access.


