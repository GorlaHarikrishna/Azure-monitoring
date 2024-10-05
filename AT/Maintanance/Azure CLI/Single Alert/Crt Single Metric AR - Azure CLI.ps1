# Create Single Alert Rule using Azure CLI
az monitor metrics alert create `
  --name "CLI-Test" `
  --resource-group "AZM-SNow" `
  --scopes "/subscriptions/f568eda3-fb90-4ae1-bca7-a53136f06ba4/resourceGroups/CTS-NJ-MONITOR-TEST/providers/Microsoft.Compute/virtualMachines/cts-vm-05" `
  --condition "avg Percentage CPU > 80" `
  --description "Trigger alert when CPU usage exceeds 80%" `
  --action "/subscriptions/f568eda3-fb90-4ae1-bca7-a53136f06ba4/resourceGroups/AZM-SNow/providers/microsoft.insights/actionGroups/AZM-Snow-Main"
