az monitor scheduled-query update `
  --name "VM - Disk - Percentiles Free Space - azm -cts-vm-05" `
  --resource-group "AZM-SNow" `
  --set description="New description here" `
  --set criteria.allOf[0].threshold=6 `
  --set evaluationFrequency="PT5M" `
  --set windowSize="PT10M"