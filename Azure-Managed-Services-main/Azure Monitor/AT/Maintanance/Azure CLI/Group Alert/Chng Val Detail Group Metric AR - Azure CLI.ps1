# Get all scheduled query rules in a specific resource group
$rules = az monitor metrics alert list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter rules by name containing the specific pattern
$filteredRules = $rules | Where-Object { $_.name -like "*VM - Virtual Machine CPU by percentiles - azm -*" }

# Loop through each filtered rule and update
foreach ($rule in $filteredRules) {
      az monitor metrics alert update `
      --name $rule.name `
      --resource-group "AZM-SNow" `
      --set description="CLI-Test-Desc" `
      --set criteria.allOf[0].threshold=96 `
      --set criteria.allOf[0].timeAggregation="Average" `
      --set criteria.allOf[0].operator="GreaterThan" `
      --set evaluationFrequency="PT1M" `
      --set windowSize="PT5M" `
      --set severity=3
}