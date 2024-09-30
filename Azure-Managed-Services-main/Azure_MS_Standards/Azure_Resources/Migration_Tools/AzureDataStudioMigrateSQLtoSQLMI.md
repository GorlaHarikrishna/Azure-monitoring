# Migrate SQL Server Databases to Azure SQL Managed Instance

<br>

This procedure will show the process to migrate on-prem SQL Server Databases to Azure SQL Managed Instance. It includes the process to Install Azure Data Studio on a migration server, Run a Database Assesment, Configure the Database Migration, and Complete the Migration Cutover.

<br>

### **Install Azure Data Studio To Migration Server**

- From the migration appliance windows server, Download and install Azure Data Studio from this link: <https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver16#download-azure-data-studio>
- Run azuredatastudio-windows-user-setup-1.37.0.exe
- Follow the wizard to install it
- Open Azure Data Studio 
- Connect to the SQL Server
  - ![ Image ]( docimages/sqlmimig.001.png)
  - Click "New Connection" 
  - Fill out the Server IP or hostname and authentication method
  - Click Connect
- Install the Azure SQL Migration Extension.
  - ![ Image ]( docimages/sqlmimig.002.png)

<br><br>

## **Run Database Assesment**

- Run Database Assesment <https://docs.microsoft.com/en-us/azure/dms/tutorial-sql-server-managed-instance-online-ads#launch-the-migrate-to-azure-sql-wizard-in-azure-data-studio>
  - Click Migrate to Azure SQL
  - ![ Image ]( docimages/sqlmimig.003.png)
  - Select the DBs to run assesment on
  - ![ Image ]( docimages/sqlmimig.004.png)
  - Click "Azure SQL Managed Instance"
  - ![ Image ]( docimages/sqlmimig.005.png)
  - After a few minutes the recommended sizing will be displayed 
- ![ Image ]( docimages/sqlmimig.006.png)
- Make sure your SQL MI instance has the recommended configuration.
- Select the databases to migrate
- ![ Image ]( docimages/sqlmimig.007.png)
- Click Next

<br><br>

## **Configure Migration Settings**

- Connect to the target Azure SQL MI. 
- If you haven't already, link to your azure portal account.
- ![ Image ]( docimages/sqlmimig.008.png)
- Click "Link account". Click "add an account". Log in with your azure account.
- ![ Image ]( docimages/sqlmimig.009.png)
- Fill out the target subscription settings to point to your target SQL MI. click next
- ![ Image ]( docimages/sqlmimig.010.png)
- Choose online migration. Click next
- ![ Image ]( docimages/sqlmimig.011.png)
- Choose Backup to Azure Blob or CIFS share.
  - Note: must have "With checksum" backup option enabled.
  - If blob storage. Follow this article to set up backup to block blob storage for SQL 2016 or later. SQL 2012-2015 must be page block storage: <https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url?view=sql-server-ver16>
  - If using CIFS share. Continue with wizard
- For this procedure we are backing up DBs to a CIFS share. Fill out the DB backup info: 
- ![ Image ]( docimages/sqlmimig.012.png)
- Fill out the Storage Account details. Click Next.
- ![ Image ]( docimages/sqlmimig.013.png)
- Select or create a new Azure Database Migration service. If one is already created, skip to step number 43. If none are created, click create new.
- ![ Image ]( docimages/sqlmimig.014.png)
- Choose the resource group and type a name
- ![ Image ]( docimages/sqlmimig.015.png)
- It will then generate keys to register your integration runtime
- ![ Image ]( docimages/sqlmimig.016.png)
- Click download and install "Microsoft Integration Runtime" 
- ![ Image ]( docimages/sqlmimig.017.png)
- Open the file, click next
- ![ Image ]( docimages/sqlmimig.018.png)
- Accept the license, click next
- Leave the default install path, click next
- Click install
- ![ Image ]( docimages/sqlmimig.019.png)
- Click finish
- When finished it will open the Microsoft Integration Runtime configuration Manger. From here, copy a Authentication key from the azure data studio window and paste it in here:
- ![ Image ]( docimages/sqlmimig.020.png)
- Click Register.
- Leave the defaults. Click Finish
- ![ Image ]( docimages/sqlmimig.021.png)
- ` `It will show successfully registered 
- ![ Image ]( docimages/sqlmimig.022.png)
- Click Lauch Integrated runtime config Manager. It will show the status.
- ![ Image ]( docimages/sqlmimig.023.png)
- When complete, go back to the Azure Data Studio window and click "Test Connection"
- ![ Image ]( docimages/sqlmimig.024.png)
- It will show the status 
- ![ Image ]( docimages/sqlmimig.025.png)
- Click Done. 
- ![ Image ]( docimages/sqlmimig.026.png)
- Click Next.
- View the summary window. Click Start Migration.
- ![ Image ]( docimages/sqlmimig.027.png)
- It will then show the database migration status
- ![ Image ]( docimages/sqlmimig.028.png)
- Click the database migration progress to see detailed status.
- ![ Image ]( docimages/sqlmimig.029.png)
- When the backup files have a status of "Restored" The backup file is successfully restored on Azure SQL MI

<br><br>

## **Complete Migration Cutover**

To complete the cutover,

- Stop all incoming transactions to the source database and prepare to make any application configuration changes to point to the target database in Azure SQL Managed Instance.
- Take any tail log backups for the source database in the backup location specified. (5-10 min to show up in Data Studio after backup completes)
- Ensure all database backups have the status Restored in the monitoring details page.
  - Open Azure Data Studio
  - Double click on the SQL Server
  - ![ Image ]( docimages/sqlmimig.030.png)
  - Click Azure SQL Migration
  - ![ Image ]( docimages/sqlmimig.031.png)
  - In the Database migration status window, click "Database migrations in progress"
  - ![ Image ]( docimages/sqlmimig.032.png)
  - Click the first database 
  - ![ Image ]( docimages/sqlmimig.033.png)
  - Verify that the status is "Restored" for all backups in the backup chain.
  - ![ Image ]( docimages/sqlmimig.034.png)
- Select Complete cutover in the monitoring details page.
  - ![ Image ]( docimages/sqlmimig.035.png)
  - If you have verified all log backups and full backups in the chain have a "Restored" status then you can check the box to confirm. Then click "Complete Cutover"
  - ![ Image ]( docimages/sqlmimig.036.png)
  - Go back to the SQL migrate page and it will show a category for completing the cutover. Click to see details
  - ![ Image ]( docimages/sqlmimig.037.png)
- During the cutover process, the migration status changes from in progress to completing. When the cutover process is completed, the migration status changes to succeeded to indicate that the database migration is successful and that the migrated database is ready for use.
  - ![ Image ]( docimages/sqlmimig.038.png)
  - On the SQL MI you will see the DB Status change to "Online" and it is ready to use in azure
  - ![ Image ]( docimages/sqlmimig.039.png)
- Repeat steps for all DBs.
- **Note**:  you can cutover many DBs at the same time
- ![ Image ]( docimages/sqlmimig.040.png)
- Once the databases are in “Online” Status then the post migration steps can start.
  - Application owners can connect to the SQL MI DB and do verifications.

