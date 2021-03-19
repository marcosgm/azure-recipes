# azure-recipes
A myriad of azure-related scripts and recipes

# Policies
FOLDER enforce-autoshutdown-vm
New-AzPolicyDefinition -Name 'ShutdownVM' -DisplayName 'Shutdown VMs' -Policy .\azurepolicy.rules.json -Parameter .\azurepolicy.parameters.json

FOLDER configure-softdelete-containers
New-AzPolicyDefinition -Name 'ApplySoftDeleteStorageContainere' -DisplayName 'Soft Delete Storage Containere' -Policy .\azurepolicy.rules.json -Parameter .\azurepolicy.parameters.json

FOLDER audit-softdelete-containers
New-AzPolicyDefinition -Name 'ApplySoftDeleteStorageContainers' -DisplayName 'Soft Delete Storage Containere' -Policy .\azurepolicy.rules.json

tip: Get-AzPolicyAlias -NameSpaceMatch Microsoft.Storage