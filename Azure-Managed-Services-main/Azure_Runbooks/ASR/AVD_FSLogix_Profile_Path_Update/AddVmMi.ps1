workflow AddVmMi
{
    param (
        [Object]$RecoveryPlanContext
    )

    # Connect to Azure
    Disable-AzContextAutosave -Scope Process
    Connect-AzAccount -Identity -AccountId "663e14ef-ecad-43c4-9879-9046dd7c0bda"
    Set-AzContext -SubscriptionID "1b33d000-1e51-4f67-9e88-c25a2587f429"

    Write-Output "Successfully connected with Automation account's Managed Identity"

    $vmMap = $RecoveryPlanContext.VmMap.PsObject.Properties

    Write-Output $vmMap
    
    foreach($VMProperty in $vmMap)
        {
            $VM = $VMProperty.Value
             
            InLineScript
            {

                $VmName =   Get-AzVM -Name $Using:VM.RoleName

                Write-Output $VmName

                # Add Managed Identity to VM
                Update-AzVM -ResourceGroupName $Using:VM.ResourceGroupName -VM $VmName -IdentityType UserAssigned -IdentityID "/subscriptions/1b33d000-1e51-4f67-9e88-c25a2587f429/resourcegroups/cloud-shell-storage-eastus/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ASR-Test"
                
                Write-output "Completed adding Managed Identity to VM"       
            }         
        }
}