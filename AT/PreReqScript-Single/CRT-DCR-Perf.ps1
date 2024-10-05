$ResourceGroup = "AZM-SNow"
$location = "East US"
$DCRRName = "azm-snow-dcr-perf"
$DCRRFName = "C:\\samples\\PreReqScript-Single\\dcrtmplt-perf.json" 
$DCRDes = "Collect Logs Perf Table"

# Create the data collection rule
New-AzDataCollectionRule -ResourceGroupName $ResourceGroup -Location $location -RuleName $DCRRName -RuleFile $DCRRFName -Description $DCRDes
