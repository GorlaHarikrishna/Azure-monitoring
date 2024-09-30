### Azure Managed Services - Virtual Machine Creation Standards

#### 1. Purpose
The purpose of this document is to provide a standardized procedure for creating and managing virtual machines within the Azure environment to ensure security, efficiency, and compliance with company standards.

#### 2. Pre-Requisites
- Azure subscription access
- Proper permissions for VM creation
- Knowledge of VM sizing and configurations
- Understanding of Azure networking

#### 3. Standard Operating Procedure

##### 3.1. Virtual Machine Creation
1. **Name Convention**: Use a standardized naming convention for VMs (`vm-environment-workload-location`).
   
2. **Resource Group**: Ensure the VM is placed in the appropriate resource group based on its purpose and ownership.

3. **Region**: Select the Azure region that aligns with data residency and latency requirements.

4. **Image Selection**:
   - Choose the appropriate OS image (Windows, Linux, etc.).
   - Optionally, select a custom image if available and approved.

5. **Size and Configuration**:
   - Select the VM size based on workload requirements and performance expectations.
   - Configure CPU, memory, disk, and network settings accordingly.

6. **Networking**:
   - Assign a virtual network (VNet) and subnet.
   - Configure network security groups (NSGs) for inbound and outbound traffic.

7. **Data Disks**:
   - Add data disks as needed, considering storage requirements.
   - Set up disk caching options based on workload (if applicable).

8. **Authentication**:
   - Set up SSH keys (for Linux) or RDP authentication (for Windows) for secure access.
   - Avoid using default usernames/passwords.

9. **Monitoring**:
   - Enable Azure Monitor for VM insights.

10. **Tags**:
    - Apply relevant tags for tracking and cost management.
    - Include tags such as environment (dev, test, prod), owner, and department.

11. **Backup and Recovery**:
    - Configure backup policies based on data sensitivity and retention requirements.
    - Ensure disaster recovery plan alignment.

12. **Review**:
    - Review all settings and configurations before deployment.
    - Confirm compliance with company policies and security standards.

##### 3.2. Post-Creation Checklist
- Verify VM connectivity.
- Test access credentials (SSH/RDP).
- Check resource utilization.
- Confirm backup and monitoring configurations.

#### 4. Approval
VM creation requires approval from a designated authority (Client IT Manager or Verified Approver) before deployment.

#### 6. Compliance
All Azure VM deployments must adhere to these standards to maintain compliance and alignment with company policies.