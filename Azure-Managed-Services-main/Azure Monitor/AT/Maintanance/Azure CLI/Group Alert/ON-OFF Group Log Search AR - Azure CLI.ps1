# Define whether to enable or disable the alerts
$enableAlert = $false  # Set to $false to disable the alerts

# Get all scheduled query rules in a specific resource group
$scheduledRules = az monitor scheduled-query list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter scheduled query rules by name containing the specific pattern and update
foreach ($rule in $scheduledRules) {
    if ($rule.name -like "*VM - Disk - Virtual Machines by Free Space MB - azm -*") {
        az monitor scheduled-query update `
          --name $rule.name `
          --resource-group "AZM-SNow" `
          --set enabled=$enableAlert
    }
}