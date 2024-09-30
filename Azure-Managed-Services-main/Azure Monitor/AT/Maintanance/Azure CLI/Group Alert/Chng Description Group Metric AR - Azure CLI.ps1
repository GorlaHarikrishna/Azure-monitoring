# Get all metric alerts in a specific resource group
$metricAlerts = az monitor metrics alert list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter metric alerts by name containing the specific pattern and update
foreach ($alert in $metricAlerts) {
    if ($alert.name -like "*VM - Virtual Machine CPU by percentiles - azm -*") {
        az monitor metrics alert update `
          --name $alert.name `
          --resource-group "AZM-SNow" `
          --set description="909-CLI-Test-Desc"
    }
}