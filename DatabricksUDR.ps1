#alternative approach: https://github.com/HolgerReiners/Azure-Manage-ServiceTagUDR
$SERVICETAG_SERVICE="AzureDatabricks" 
$UDR_RESOURCE_GROUP_NAME="databricksnetwork-rg"
$DATABRICKS_REGION="centralus"
$UDR_LOCATION="centralus"
$UDR_ROUTE_TABLE_NAME="databricksonprem-rt"

$useregionallist=$true #if true, only open routes to the FQDNs listed for my Databricks region, if false, use all regions

# ERROR IN THE FOLLOWING URLS
#    "dbartifactsprodcentralus.blob.core.windows.net",
#    "dblogprodcentralus.blob.core.windows.net",
$regionalurllist="consolidated-centralus-prod-metastore.mysql.database.azure.com",
    "consolidated-centralus-prod-metastore-addl-1.mysql.database.azure.com",    
    "consolidated-centralusc2-prod-metastore-0.mysql.database.azure.com",
    "arprodcusa1.blob.core.windows.net",
    "arprodcusa2.blob.core.windows.net",
    "arprodcusa3.blob.core.windows.net",
    "arprodcusa4.blob.core.windows.net",
    "arprodcusa5.blob.core.windows.net","arprodcusa6.blob.core.windows.net",
    "dbartifactsprodscus.blob.core.windows.net",
    "dblogprodwestus.blob.core.windows.net",
    "prod-westus-observabilityEventHubs.servicebus.windows.net",
    "prod-centralusc2-observabilityeventhubs.servicebus.windows.net"

#Route table MUST exist before this script, we are not creating new resources, just updating it if needed
$createRT = $false
if ($createRT)
{
    New-AzResourceGroup -ResourceGroupName $UDR_RESOURCE_GROUP_NAME -Location $UDR_LOCATION
    $routeTable = New-AzRouteTable -ResourceGroupName $UDR_RESOURCE_GROUP_NAME -Location $UDR_LOCATION -Name $UDR_ROUTE_TABLE_NAME
}

$databricksIPv4=@()
if ($useregionallist) #only open routes to the FQDNs listed for my Databricks region
{
    foreach ($name in $regionalurllist)
    {
        try {
            $dnsq=Resolve-DnsName -Name $name -Type A -ErrorAction Stop
            $iprecord=[ipaddress] $dnsq.IP4Address            
        }
        Catch{
            throw  "DNS not found for $name, abort"        
        }
         
        Write-Host "+++ Adding $iprecord for $name as it wasn't found in routetable"
        $databricksIPv4 += ($iprecord.ToString()+"/32")
        
    }
    Write-Host "UDR should be " $databricksIPv4.Count " long, proceed"
} else { #open routes to All Databricks resources
    Write-Host "Opening UDRs to all service regions"
    $NetworkServiceTag = Get-AzNetworkServiceTag -Location $DATABRICKS_REGION
    
    $databricksIPs = $NetworkServiceTag.Values.Properties | Where-Object { $_.SystemService -eq $SERVICETAG_SERVICE } | Where-Object {$_.AddressPrefixes -match ':'}
    $databricksIPv4 = $databricksIPs.AddressPrefixes | Where-Object {$_ -notmatch ':'}
    #reminder: 400 UDR per route table limit https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-resource-manager-virtual-networking-limits
    if ( $databricksIPv4.Count -gt 400 ) {
        throw "UDR too long, abort"
    } else {
        Write-Host "UDR should be " $databricksIPv4.Count " long, proceed"
    }
}

#### PROCEED WITH THE RT UPDATE ####
$routeTable = Get-AzRouteTable -ResourceGroupName $UDR_RESOURCE_GROUP_NAME -Name $UDR_ROUTE_TABLE_NAME
Foreach ($iprange in $databricksIPv4)
{
    $routename="Databricks-$iprange".replace('/','_')
    #optimize by not adding existing duplicate routes
    if ($routetable.Routes.AddressPrefix -NotContains $iprange){
        Write-Host "+++ Adding $iprange as it wasn't found in routetable"
        Add-AzRouteConfig -Name $routename -AddressPrefix $iprange -RouteTable $routeTable -NextHopType Internet | Out-Null
    }else {
        Write-Host "skipping $iprange as it was found in routetable already"
    }    
}
$routeTable | Set-AzRouteTable | Out-Null


