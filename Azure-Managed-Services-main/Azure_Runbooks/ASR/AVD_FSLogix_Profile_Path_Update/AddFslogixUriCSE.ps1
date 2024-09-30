workflow AddFslogixUriCSE
{
    param (
        [Object]$RecoveryPlanContext
    )

    # Connect to Azure
    Disable-AzContextAutosave -Scope Process
    Connect-AzAccount -Identity -AccountId "663e14ef-ecad-43c4-9879-9046dd7c0bda"
    Set-AzContext -SubscriptionID "1b33d000-1e51-4f67-9e88-c25a2587f429"

    Write-Output "Successfully connected with Automation account's Managed Identity"

    #Provide the storage account name and the storage account key information
    $StorageAccountName = Get-AutomationVariable -Name 'ASRStorage'
    $StorageAccountKey  =  Get-AutomationVariable -Name 'ScriptStorageAccountKey'
    
    Write-Output "Got storage account key and context"
    
    #Provide the script details
    $ScriptContainer = "asr-poc"
    $ScriptName = "ASRAVDPOC.ps1"

    $vmMap = $RecoveryPlanContext.VmMap.PsObject.Properties

    Write-Output $vmMap
    
    foreach($VMProperty in $vmMap)
        {
            $VM = $VMProperty.Value
             
            InLineScript
            {

                $VmName =   Get-AzVM -Name $Using:VM.RoleName


                $context = New-AZStorageContext -StorageAccountName $Using:StorageAccountName -StorageAccountKey $Using:StorageAccountKey;
                $sasuri = New-AZStorageBlobSASToken -Container $Using:ScriptContainer -Blob $Using:ScriptName -Permission r -FullUri -Context $context
                $Settings = '{"fileUris":["https://asrcsetest9876.blob.core.windows.net/asr-poc/ASRAVDPOC.ps1"]}'
                $ProtectedSettings  =   '{"commandToExecute":"powershell -ExecutionPolicy Unrestricted -Command \"./ASRAVDPOC.ps1 \""}'
                
                Write-Output "Running inline scripts"

                Write-Output "Installing custom script extension"
                Set-AzVMExtension -ResourceGroupName $Using:VM.ResourceGroupName -VMName $Using:VM.RoleName -Name CustomScriptExtension -Publisher Microsoft.Compute -ExtensionType CustomScriptExtension -TypeHandlerVersion 1.09 -SettingString $Settings -ProtectedSettingString $ProtectedSettings -Verbose
                            
                # Write-output "Running script on  VM " + $Using:VM.RoleName
                # Set-AzVMCustomScriptExtension -ResourceGroupName $Using:VM.ResourceGroupName -Location "West US" -VMName $Using:VM.RoleName -Name CustomScriptExtension -TypeHandlerVersion 1.09 -StorageAccountName $Using:StorageAccountName -StorageAccountKey $Using:StorageAccountKey -FileName $Using:ScriptName -ContainerName $Using:ScriptContainer -Run $Using:ScriptName
               
                Write-output "Completed installing FSLogix Profile URI Custom Script Extension on VM"   
            }         
        }
}