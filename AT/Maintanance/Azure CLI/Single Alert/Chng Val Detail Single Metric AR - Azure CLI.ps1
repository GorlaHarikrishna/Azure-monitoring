az monitor metrics alert update `
  --name "VM - Disk - Data Disk IOPS Consumed Percentage - azm -cts-vm-05" `
  --resource-group "AZM-SNow" `
  --set description="CLI-Test-Desc" `
  --set criteria.allOf[0].threshold=6 `
  --set criteria.allOf[0].timeAggregation="Average" `
  --set criteria.allOf[0].operator="GreaterThan" `
  --set evaluationFrequency="PT1M" `
  --set windowSize="PT5M" `
  --set severity=3 