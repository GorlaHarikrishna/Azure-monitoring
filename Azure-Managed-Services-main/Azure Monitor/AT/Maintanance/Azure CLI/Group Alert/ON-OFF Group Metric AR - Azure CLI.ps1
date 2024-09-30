# Define whether to enable or disable the alerts
$enableAlert = $false  # Set to $false to disable the alerts

# Get all metric alerts in a specific resource group
$metricAlerts = az monitor metrics alert list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter metric alerts by name containing the specific pattern and update
foreach ($alert in $metricAlerts) {
    if ($alert.name -like "*VM - Virtual Machine CPU by percentiles - azm -*") {
        az monitor metrics alert update `
          --name $alert.name `
          --resource-group "AZM-SNow" `
          --enabled $enableAlert
    }
}