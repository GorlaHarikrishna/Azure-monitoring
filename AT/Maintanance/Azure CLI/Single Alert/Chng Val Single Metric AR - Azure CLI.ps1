az monitor metrics alert update `
  --name "VM - Disk - Data Disk IOPS Consumed Percentage - azm -cts-vm-05" `
  --resource-group "AZM-SNow" `
  --set description="New description here" `
  --set criteria.allOf[0].threshold=99 `
  --set evaluationFrequency="PT1M" `
  --set windowSize="PT5M"
