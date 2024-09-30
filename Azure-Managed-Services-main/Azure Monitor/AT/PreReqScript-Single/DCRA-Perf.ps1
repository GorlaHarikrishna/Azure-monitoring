# DCR-Association.ps1

    $ResourceGroup = "AZM-SNow"
    $dcrName = "azm-snow-dcr-perf-Med"
    $tagKey = "cts_type"
    $tagValue = "Iaas"

# Get virtual machines by a specific tag
$virtualMachinesWithTag = Get-AzResource | Where-Object { $_.ResourceType -eq "Microsoft.Compute/virtualMachines" -and $_.Tags[$tagKey] -eq $tagValue }

# Iterate through each virtual machine and associate the DCR
foreach ($vm in $virtualMachinesWithTag) {
    $vmId = $vm.Id
    $dcrAssocName = "dcrAssoc-perf-$($vm.Name)"

    # Get the DCR if you haven't already
    if (-not $dcr) {
        $dcr = Get-AzDataCollectionRule -ResourceGroupName $ResourceGroup -RuleName $dcrName
    }

    # Associate the DCR with the VM
    New-AzDataCollectionRuleAssociation -TargetResourceId $vmId -AssociationName $dcrAssocName -RuleId $dcr.Id
}
