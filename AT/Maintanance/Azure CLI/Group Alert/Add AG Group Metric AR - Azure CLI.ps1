# Get all scheduled query alerts in a specific resource group
$scheduledQueryAlerts = az monitor metrics alert list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter scheduled query alerts by name containing the specific pattern and update
foreach ($alert in $scheduledQueryAlerts) {
    if ($alert.name -like "*VM - Virtual Machine CPU by percentiles - azm -*") {
        az monitor metrics alert update `
          --name $alert.name `
          --resource-group "AZM-SNow" `
          --add-action "/subscriptions/672368b4-ad27-40b4-a025-c8da230b7835/resourceGroups/AZM-SNow/providers/microsoft.insights/actionGroups/AZM-Snow-Main-AVD" `
    }
}