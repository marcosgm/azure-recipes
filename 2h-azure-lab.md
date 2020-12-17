# INSTALLATION
https://github.com/microsoft/MCW-Security-baseline-on-Azure/blob/master/Hands-on%20lab/Before%20the%20HOL%20-%20Security%20baseline%20on%20Azure.md

Open the Cloud Shell, type BASH

If not in cloud shell, do **az login**  first)

``` 
resourcegroup="myazseclab-rg"
location="canadacentral"
az group create -n $resourcegroup -l $location
``` 

Get the ObjectID of your current user
``` 
objectid=$(az ad signed-in-user show --query objectId)
echo $objectid
``` 

Set the parameters for the template deployment
``` 
sqlservername="azsecsql9876"
``` 

Deploy the template
``` 
url="https://raw.githubusercontent.com/microsoft/MCW-Security-baseline-on-Azure/master/Hands-on%20lab/AzureTemplate/template.json"
curl -o template.json $url
az group deployment create -g $resourcegroup -n azseclab --template-file template.json --parameters userObjectId=$objectid --parameters sqlservername=$sqlservername 
``` 
## Now read the full LAB MATERIAL
https://github.com/microsoft/MCW-Security-baseline-on-Azure/blob/master/Hands-on%20lab/HOL%20step-by%20step%20-%20Security%20baseline%20on%20Azure.md#exercise-4-securing-the-network


# Lab Activities
When the *paw-1* VM is up and running, connect to it via the Azure Portal
* RDP username = wsadmin
* password = p@ssword1rocks

Disconnect, now you can proceed with LAB EXERCISE #1
# Exercise 1: Just-in-time Access
https://github.com/microsoft/MCW-Security-baseline-on-Azure/blob/master/Hands-on%20lab/HOL%20step-by%20step%20-%20Security%20baseline%20on%20Azure.md#task-1-setup-virtual-machine-with-jit

# Ignore Exercise 2, SQL masking
# Ignore Exercise 3, Keyvault

# Exercuse 4: Secure the network
https://github.com/microsoft/MCW-Security-baseline-on-Azure/blob/master/Hands-on%20lab/HOL%20step-by%20step%20-%20Security%20baseline%20on%20Azure.md#exercise-4-securing-the-network

In the paw-1 VM, download the repo in ZIP format https://codeload.github.com/microsoft/MCW-Security-baseline-on-Azure/zip/master

Execute the PortScanner.ps1 script with Windows Powershell as admin, with the unrestricted execution policy. (NOTE: The Notepad++ link is currently broken) 




# Delete the lab
``` 
az group delete -n $resourcegroup 
```