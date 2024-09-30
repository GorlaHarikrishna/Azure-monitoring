**Azure Security Best Practices**

**Purpose:**

The purpose of this document is to provide minimum security standards for Azure Workloads.

**Pre-Requisites:**

- Azure subscription access
- Proper permissions on Azure Resources

**Azure KeyVault:**

- Use Azure Keyvault to store Customer Keys / Secret / Certificate
- Set up access policies using least privilege principle.

**Virtual Machine Security:**

- Deploy Microsoft Antimalware for Azure or other antimalware software from security vendors.
- Use Azure Disk Encryption, Bitlocker for Windows and dm-crypt for Linux to encrypt OS and Data disks.
- Enable Virtual Machine Backup and Azure Site Recovery.
- Use Azure Update manager to manager system updates.
- Restrict direct internet access to Virtual Machine, Use JIT VM access to restrict management port (RDP/SSH).
- Block RDP or SSH external access and use Bastion instead.

**Azure SQL Database**:

- Use **Azure AD identities** instead of username / password.
- Store Database’s connection string is stored in a **KeyVault**.
- Restrict database access to only resources that need access.
- Connect the database using **Private Endpoint** and block any external access.
- Server Side Encryption: Review and Enable “**Transparent Data Encryption (TDE)**” if not enabled by default.
- Client Side Encryption: Enable “**Always Encrypted**” Feature

**App Services:**

- Configure App Service to only accept HTTPS requests. 
- Use Azure AD authentication if needed.
- Store secrets (such as Connection Strings) in KeyVault. 
- Restrict external access, traffic should flow only thru WAF / Firewall.

**Storage Accounts:**

- Use Azure AD identities to access blobs instead of SAS token or keys.
- Check if Data is encrypted (should be On by default). 
- Store Storage Account’s connection string in KeyVault. 
- Restrict network access to only resources that need access.
- Connect to the Storage Account using Private Endpoint and block any external access.
