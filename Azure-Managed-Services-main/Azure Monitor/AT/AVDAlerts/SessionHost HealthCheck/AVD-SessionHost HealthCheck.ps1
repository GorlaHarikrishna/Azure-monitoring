param (
    [string]$ParameterFile = "C:\samples\AT\AVDAlerts\SessionHost HealthCheck\AVDAlert-SessionHost HealthCheck-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$Customer = $Parameters.ClNm
$IntSubID = $Parameters.subscriptionId

# Get all virtual machines in the subscription with a specific tag
# Get all host pool resources that have the specified tag name and value
$hostPoolsWithTag = Get-AzResource -ResourceType "Microsoft.DesktopVirtualization/hostpools" | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

$kqlQuery = @"
let HealthCheckIdToDescription = (idx: long) {
    case(
        idx == 0, "DomainJoin",
        idx == 1, "DomainTrust",
        idx == 2, "FSLogix",
        idx == 3, "SxSStack",
        idx == 4, "URLCheck",
        idx == 5, "GenevaAgent",
        idx == 6, "DomainReachable",
        idx == 7, "WebRTCRedirector",
        idx == 8, "SxSStackEncryption",
        idx == 9, "IMDSReachable",
        idx == 10, "MSIXPackageStaging",
        "Invalid"
    )
};
let GetHealthCheckResult = (idx: long) {
    case(
        idx == 1, "Succeeded",
        idx == 2, "Failed",
        "Invalid"
    )
};
WVDAgentHealthStatus
| where TimeGenerated > ago(1h)
| where isnotempty(SessionHostHealthCheckResult)
| mv-expand SessionHostHealthCheckResult to typeof(dynamic)
| extend HealthCheckName = tostring(SessionHostHealthCheckResult.HealthCheckName),
          HealthCheckResultIdx = toint(SessionHostHealthCheckResult.HealthCheckResult),
          AdditionalFailureDetails = tostring(SessionHostHealthCheckResult.AdditionalFailureDetails)
| where GetHealthCheckResult(HealthCheckResultIdx) == "Failed"
| extend HealthCheckDesc = HealthCheckIdToDescription(toint(HealthCheckName))
| summarize count(), FirstSeen=min(TimeGenerated), LastSeen=max(TimeGenerated)
    by HealthCheckDesc, SessionHostName, HealthCheckResult=GetHealthCheckResult(HealthCheckResultIdx)
"@

# Define Common Condition for Alert Rules
    $dim1 = New-AzScheduledQueryRuleDimensionObject -Name "SessionHostName" -Operator "Include" -Value "*"
    $dim2 = New-AzScheduledQueryRuleDimensionObject -Name "HealthCheckDesc" -Operator "Include" -Value "*"
    $condition = New-AzScheduledQueryRuleConditionObject -Dimension $dim1, $dim2 `
    -Query $kqlQuery `
    -TimeAggregation "Total" `
    -MetricMeasureColumn "count_" `
    -Operator "GreaterThan" `
    -Threshold "2" `

# Loop Through Virtual Machines and Create Alert Rules
foreach ($hostPoolWithTag in $hostPoolsWithTag) {

    $hpName = $hostPoolWithTag.Name
    $scope = "/subscriptions/$IntSubID/resourceGroups/$($hostPoolWithTag.ResourceGroupName)/providers/Microsoft.DesktopVirtualization/hostpools/$hpName"
    $alertRuleName = "AVD - Hostpool - SessionHost HealthCheck - azm -$hpName"
    $description = "Client Name:$Customer-Monitor and ensure the health and availability of session hosts within a host pool on $hpName"
    
    New-AzScheduledQueryRule -Name $alertRuleName `
        -ResourceGroupName $Parameters.resourceGroupName `
        -Location $Parameters.location `
        -DisplayName $alertRuleName `
        -Description $description `
        -Scope $scope `
        -Severity 4 `
        -WindowSize ([System.TimeSpan]::FromMinutes(10)) `
        -EvaluationFrequency ([System.TimeSpan]::FromMinutes(10)) `
        -CriterionAllOf $condition
}