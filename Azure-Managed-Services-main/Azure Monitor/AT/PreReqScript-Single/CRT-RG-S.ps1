$resourceGroupName = "AZM-SNow"
$location = "East US"

# Check if the resource group already exists
if (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue) {
    Write-Host "Resource group '$resourceGroupName' already exists."
} else {
    # Create the new resource group
    New-AzResourceGroup -Name $resourceGroupName -Location $location
    Write-Host "Resource group '$resourceGroupName' created successfully in location '$location'."
}
