param (
    [string]$ParameterFile = "C:\samples\AT\RAlerts\RAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Cache for Redis - EvictedKeys - azm "
$Customer = $Parameters.ClNm

# Get all Azure Cache for Redis instances in the subscription
$redisCaches = Get-AzRedisCache

# Loop through Cache for Redis and create metric alert rules
foreach ($redisCache in $redisCaches)
{
    # Create the metric alert condition for CPU usage
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "EvictedKeys" -TimeAggregation "count" -Operator "GreaterThan" -Threshold 0
    
    # Define alert rule name based on the Redis Cache name
    $alertRuleName = "$alertRuleNamePrefix-$($redisCache.Name)"

    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $redisCache.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the count of keys that have been evicted from the Redis cache on $($redisCache.Name)"
}
