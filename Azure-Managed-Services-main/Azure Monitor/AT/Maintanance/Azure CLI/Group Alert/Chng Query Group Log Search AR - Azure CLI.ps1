# Get all scheduled query alerts in a specific resource group
$scheduledQueryAlerts = az monitor scheduled-query list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter scheduled query alerts by name containing the specific pattern and update
foreach ($alert in $scheduledQueryAlerts) {
    if ($alert.name -like "*VM - Disk - Virtual Machines by Free Space MB - azm -*") {
        az monitor scheduled-query update `
          --name $alert.name `
          --resource-group "AZM-SNow" `
          --set criteria.allOf[0].query="Perf | where TimeGenerated > ago(30min) | where ObjectName in ('LogicalDisk', 'Logical Disk') | where (InstanceName == 'C:' or InstanceName == '/') | where CounterName == 'Free Megabytes' | summarize MaxDiskFreeMB = max(CounterValue) by bin(TimeGenerated, 5m), Computer, _ResourceId, InstanceName" `
    }
}