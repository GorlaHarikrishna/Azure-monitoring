# Get all scheduled query rules in a specific resource group
$rules = az monitor scheduled-query list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter rules by name containing the specific pattern
$filteredRules = $rules | Where-Object { $_.name -like "*VM - Disk - Percentiles Free Space - azm*" }

# Loop through each filtered rule and update
foreach ($rule in $filteredRules) {
    az monitor scheduled-query update `
      --name $rule.name `
      --resource-group "AZM-SNow" `
      --set description="CLI-Test-Desc" `
      --set criteria.allOf[0].threshold=6 `
      --set criteria.allOf[0].timeAggregation="Average" `
      --set criteria.allOf[0].operator="GreaterThan" `
      --set evaluationFrequency="PT5M" `
      --set windowSize="PT10M" `
      --set severity=3
}