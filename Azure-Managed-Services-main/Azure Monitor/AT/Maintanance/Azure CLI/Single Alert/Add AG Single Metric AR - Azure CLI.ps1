az monitor metrics alert update `
  --resource-group "AZM-SNow" `
  --name "VM - Virtual Machine CPU by percentiles - azm -cts-vm-09" `
  --add-action "/subscriptions/f568eda3-fb90-4ae1-bca7-a53136f06ba4/resourceGroups/AZM-SNow/providers/microsoft.insights/actionGroups/AZM-Snow-Main" `
