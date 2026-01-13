targetScope = 'subscription'

// --- PARAMETERS ---
param location string = 'eastus2'
param rgName string = 'rg-hve-lab-security'

// --- RESOURCE GROUP ---
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgName
  location: location
}

// --- WORKLOADS MODULE ---
// This calls your second file and tells it to run inside the Resource Group
module victimWorkloads 'workloads.bicep' = {
  name: 'deploy-victims-module'
  scope: rg 
  params: {
    location: location
  }
}
