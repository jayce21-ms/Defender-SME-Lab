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
targetScope = 'subscription'

param location string = 'eastus2'
param workspaceName string = 'law-hve-security-logs'
param emailAddress string = 'your-email@example.com' // <-- Change this!

// 1. Existing Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-hve-lab-security'
  location: location
}

// 2. Existing Log Analytics Workspace
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.7.0' = {
  scope: resourceGroup(rg.name)
  name: 'deploy-log-analytics'
  params: {
    name: workspaceName
    location: location
  }
}

// 3. NEW: Enable Defender for Servers (Plan 1)
resource defenderServers 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'VirtualMachines'
  properties: {
    pricingTier: 'Standard'
    subPlan: 'P1'
  }
}

// 4. NEW: Enable Defender for Storage
resource defenderStorage 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'StorageAccounts'
  properties: {
    pricingTier: 'Standard'
    subPlan: 'DefenderForStorageV2'
  }
}

// 5. NEW: Set Security Contact (Where alerts go)
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
