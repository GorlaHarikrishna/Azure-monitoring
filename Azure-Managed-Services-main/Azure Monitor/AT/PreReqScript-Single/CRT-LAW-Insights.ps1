$ResourceGroup = "AZM-SNow"
$location = "East US"
$WorkspaceName = "LAW-AZM-SNOW-INSIGHTS"

# Create the workspace
New-AzOperationalInsightsWorkspace -Location $Location -Name $WorkspaceName -Sku PerGB2018 -ResourceGroupName $ResourceGroup