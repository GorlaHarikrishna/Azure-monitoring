$ResourceGroup = "AZM-SNow"
$location = "East US"
$DCRRName = "azm-snow-dcr-insights88888"
$DCRRFName = "C:\\samples\\PreReqScript-Single\\dcrtmplt-insights.json" 
$DCRDes = "Collect Logs Insights Table"

# Create the data collection rule
New-AzDataCollectionRule -ResourceGroupName $ResourceGroup -Location $location -RuleName $DCRRName -RuleFile $DCRRFName -Description $DCRDes
