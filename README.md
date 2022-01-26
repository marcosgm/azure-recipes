# azure-recipes

[![Git](https://app.soluble.cloud/api/v1/public/badges/d358a5a4-50d0-4007-86f7-593a234d86b0.svg?orgId=568518005652)](https://app.soluble.cloud/repos/details/github.com/marcosgm/azure-recipes?orgId=568518005652)  
A myriad of azure-related scripts and recipes

# Policies
FOLDER enforce-autoshutdown-vm
New-AzPolicyDefinition -Name 'ShutdownVM' -DisplayName 'Shutdown VMs' -Policy .\azurepolicy.rules.json -Parameter .\azurepolicy.parameters.json

FOLDER configure-softdelete-containers
New-AzPolicyDefinition -Name 'ApplySoftDeleteStorageContainere' -DisplayName 'Soft Delete Storage Containere' -Policy .\azurepolicy.rules.json -Parameter .\azurepolicy.parameters.json

FOLDER audit-softdelete-containers
New-AzPolicyDefinition -Name 'ApplySoftDeleteStorageContainers' -DisplayName 'Soft Delete Storage Containere' -Policy .\azurepolicy.rules.json

tip: Get-AzPolicyAlias -NameSpaceMatch Microsoft.Storage