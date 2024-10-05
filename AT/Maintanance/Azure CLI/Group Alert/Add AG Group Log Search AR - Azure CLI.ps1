# Get all scheduled query alerts in a specific resource group
$scheduledQueryAlerts = az monitor scheduled-query list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter scheduled query alerts by name containing the specific pattern and update
foreach ($alert in $scheduledQueryAlerts) {
    if ($alert.name -like "*VM - Virtual Machine System Up Time - azm -*") {
        az monitor scheduled-query update `
          --name $alert.name `
          --resource-group "AZM-SNow" `
          --action "/subscriptions/13adf441-79e5-4fcb-9762-8ca26c8fb7c4/resourceGroups/AZM-SNow/providers/microsoft.insights/actionGroups/AZM-SNow-M" `
    }
}