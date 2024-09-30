# Get all scheduled query rules in a specific resource group
$rules = az monitor scheduled-query list --resource-group "AZM-SNow" | ConvertFrom-Json

# Filter rules by name containing the specific pattern
$filteredRules = $rules | Where-Object { $_.name -like "*AVD - Memory - Percentiles Committed Bytes In Use - azm -*" }

# Loop through each filtered rule and update
foreach ($rule in $filteredRules) {
      az monitor scheduled-query update `
      --name $rule.name `
      --resource-group "AZM-SNow" `
      --set criteria.allOf[0].threshold=100 `
      --set criteria.allOf[0].operator="GreaterThanOrEqual" `
      --set evaluationFrequency="PT30M" `
      --set windowSize="PT30M" `
}