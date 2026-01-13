targetScope = 'subscription'

param location string = 'eastus2'
param workspaceName string = 'law-hve-security-logs'
param emailAddress string = 'jayce-lab-alerts@example.com' 

// 1. Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-hve-lab-security'
  location: location
}

// 2. Log Analytics Workspace (The Brain)
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.7.0' = {
  scope: resourceGroup(rg.name)
  name: 'deploy-log-analytics'
  params: {
    name: workspaceName
    location: location
  }
}

// 3. Defender for Servers
resource defenderServers 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'VirtualMachines'
  properties: {
    pricingTier: 'Standard'
    subPlan: 'P1'
  }
}

// 4. Defender for Storage
resource defenderStorage 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'StorageAccounts'
  properties: {
    pricingTier: 'Standard'
    subPlan: 'DefenderForStorageV2'
  }
}

// 5. Security Contact
resource securityContact 'Microsoft.Security/securityContacts@2023-12-01-preview' = {
  name: 'default'
  properties: {
    emails: emailAddress
    isEnabled: true
    notificationsByRole: {
      state: 'On'
      roles: ['Owner']
    }
    notificationsSources: [
      {
        sourceType: 'Alert'
        minimalSeverity: 'High'
      }
    ]
  }
}
