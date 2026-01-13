targetScope = 'subscription'

param location string = 'eastus2'
param workspaceName string = 'law-hve-security-logs'

// 1. Create the Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-hve-lab-security'
  location: location
}

// 2. Create the Log Analytics Workspace (The Security Brain)
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.7.0' = {
  scope: resourceGroup(rg.name)
  name: 'deploy-log-analytics'
  params: {
    name: workspaceName
    location: location
  }
}
