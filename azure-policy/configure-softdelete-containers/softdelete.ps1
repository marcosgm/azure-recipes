# enable soft delete on all storage accounts within matching subscriptions

 

 

Connect-AzAccount

Get-AzContext

Select-AzSubscription -SubscriptionId XXXXXXXX

 

 

$subscriptionNameLike = "XXXXXXXXXXX"

$retentionDays=7

 

 

function enableSoftDelete($subscriptionNameLike, $retentionDays) {​​​​​​​

    $subscriptions = Get-AzSubscription | Where-Object{​​​​​​​$_.Name -like $subscriptionNameLike}​​​​​​​

 

 

    foreach ($subscription in $subscriptions) {​​​​​​​

        Write-Host "Processing subscription:" $subscription.Name -ForegroundColor Yellow

        Select-AzSubscription -SubscriptionObject $subscription

        $resources = Get-AzStorageAccount

 

 

 

        foreach ($resource in $resources) {​​​​​​​

            Write-Host "Processing storage account" $resource.StorageAccountName "in resource group" $resource.ResourceGroupName -ForegroundColor Yellow

            $resource | Enable-AzStorageBlobDeleteRetentionPolicy -RetentionDays $retentionDays                

        }​​​​​​​

    }​​​​​​​

}​​​​​​​ 

enableSoftDelete $subscriptionNameLike $retentionDays