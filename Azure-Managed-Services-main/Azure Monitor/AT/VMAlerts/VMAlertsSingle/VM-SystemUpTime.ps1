param (
    [string]$ParameterFile = "C:\AZM Git\Azure-monitoring\Azure-Managed-Services-main\Azure Monitor\AT\VMAlerts\VMAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$Customer = $Parameters.ClNm
$IntSubID = $Parameters.subscriptionId

# Get all virtual machines in the subscription with a specific tag
$vms = Get-AzVM | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Define Common Condition for Alert Rules
$dimension = New-AzScheduledQueryRuleDimensionObject -Name "Computer" -Operator "Include" -Value "*"
$condition = New-AzScheduledQueryRuleConditionObject -Dimension $dimension `
    -Query "Perf | where TimeGenerated > ago(30min) | where ObjectName == 'System' | where CounterName == 'Uptime'  or CounterName == 'System Up Time' | summarize MaxSystemUpTime = max(CounterValue) by bin(TimeGenerated, 5m), Computer" `
    -TimeAggregation "Maximum" `
    -MetricMeasureColumn "MaxSystemUpTime" `
    -Operator "LessThan" `
    -Threshold "500"

# Loop Through Virtual Machines and Create Alert Rules
foreach ($vm in $vms) {
    $vmName = $vm.Name
    $scope = "/subscriptions/$IntSubID/resourceGroups/$($vm.ResourceGroupName)/providers/Microsoft.Compute/virtualMachines/$vmName"
    $alertRuleName = "VM - Virtual Machine System Up Time - azm -$vmName"
    $description = "Client Name:$Customer-Time a virtual machine (VM) has been running without being restarted or experiencing any downtime on VM $vmName"
    
    New-AzScheduledQueryRule -Name $alertRuleName `
        -ResourceGroupName $Parameters.resourceGroupName `
        -Location $Parameters.location `
        -DisplayName $alertRuleName `
        -Description $description `
        -Scope $scope `
        -Severity 4 `
        -WindowSize ([System.TimeSpan]::FromMinutes(10)) `
        -EvaluationFrequency ([System.TimeSpan]::FromMinutes(5)) `
        -CriterionAllOf $condition
}