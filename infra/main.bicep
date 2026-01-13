targetScope = 'subscription'

param location string = 'eastus2'
param rgName string = 'rg-hve-lab-security'

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgName
  location: location
}

module victimWorkloads 'workloads.bicep' = {
  name: 'deploy-victims-final'
  scope: rg 
  params: {
    location: location
  }
}
