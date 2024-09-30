$ResourceGroup = "AZM-SNow"
$location = "East US"
$WorkspaceName = "LAW-AZM-SNOW-PERF"

# Create the workspace
New-AzOperationalInsightsWorkspace -Location $Location -Name $WorkspaceName -Sku PerGB2018 -ResourceGroupName $ResourceGroup

# Linux Perf
New-AzOperationalInsightsLinuxPerformanceObjectDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "System" -InstanceName "*"  -CounterNames @("Uptime") -IntervalSeconds 20  -Name "System Up Time Linux"
New-AzOperationalInsightsLinuxPerformanceObjectDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "Memory" -InstanceName "*"  -CounterNames @("% Used Memory", "Available MBytes") -IntervalSeconds 20  -Name "Memory Linux"
New-AzOperationalInsightsLinuxPerformanceObjectDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "Logical Disk" -InstanceName "*"  -CounterNames @("Free Megabytes") -IntervalSeconds 20  -Name "Disk Linux"
Enable-AzOperationalInsightsLinuxPerformanceCollection -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName

# Windows Perf
New-AzOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "ASRAnalytics" -InstanceName "*" -CounterName "SourceVmChurnRate" -IntervalSeconds 20 -Name "Perf-Backup"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "ASRAnalytics" -InstanceName "*" -CounterName "SourceVmThrpRate" -IntervalSeconds 20 -Name "Perf-Backup1"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "Memory" -InstanceName "*" -CounterName "% Committed Bytes In Use" -IntervalSeconds 20 -Name "Committed Bytes In Use"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "LogicalDisk" -InstanceName "*" -CounterName "% Free Space" -IntervalSeconds 20 -Name "Free Space"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "LogicalDisk" -InstanceName "*" -CounterName "Free Megabytes" -IntervalSeconds 20 -Name "Free Megabytes"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "System" -InstanceName "*" -CounterName "System Up Time" -IntervalSeconds 20 -Name "System Up Time"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "NetworkInterface" -InstanceName "*" -CounterName "Bytes Total/sec" -IntervalSeconds 20 -Name "Bytes Totalsec"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "Memory" -InstanceName "*" -CounterName "Available Bytes" -IntervalSeconds 20 -Name "Available Bytes"
New-AzOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceGroup -WorkspaceName $WorkspaceName -ObjectName "Memory" -InstanceName "*" -CounterName "% Used Memory" -IntervalSeconds 20 -Name "Used Memory"