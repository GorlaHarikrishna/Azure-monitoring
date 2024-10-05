# Get all scheduled-query alerts in a specific resource group
$metricAlerts = az monitor scheduled-query list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter scheduled-query alerts by name containing the specific pattern and update
foreach ($alert in $metricAlerts) {
    if ($alert.name -like "*VM - Disk - Virtual Machines by Free Space MB - azm -*") {
        az monitor scheduled-query update `
          --name $alert.name `
          --resource-group "AZM-SNow" `
          --set description="909-CLI-Test-Desc"
    }
}