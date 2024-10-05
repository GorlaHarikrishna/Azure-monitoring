az monitor scheduled-query update `
  --name "VM - Disk - Percentiles Free Space - azm -cts-vm-05" `
  --resource-group "AZM-SNow" `
  --set description="CLI-Test-Desc" `
  --set criteria.allOf[0].threshold=6 `
  --set criteria.allOf[0].timeAggregation="Average" `
  --set criteria.allOf[0].operator="GreaterThan" `
  --set evaluationFrequency="PT5M" `
  --set windowSize="PT10M" `
  --set severity=3 
