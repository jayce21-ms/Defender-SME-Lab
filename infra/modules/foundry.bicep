// infra/modules/foundry.bicep
param hubName string
param projectName string
param location string
param vnetId string
param subnetId string

// 1. The AI Foundry Hub (The "Management" layer)
resource aiHub 'Microsoft.MachineLearningServices/workspaces@2024-04-01' = {
  name: hubName
  location: location
  kind: 'Hub' // Specifies this is an AI Foundry Hub
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: 'SME Security Research Hub'
    vnetAllowRPCAndPublicNetworkAccess: false // TD-REC alignment: No public access
    managedNetwork: {
      isolationMode: 'AllowOnlyApprovedOutbound' // Prevents data exfiltration by agents
    }
  }
}

// 2. The AI Foundry Project (The "Execution" layer)
resource aiProject 'Microsoft.MachineLearningServices/workspaces@2024-04-01' = {
  name: projectName
  location: location
  kind: 'Project'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hubResourceId: aiHub.id // Links Project to the Hub
    friendlyName: 'CRISP-MCP Agent Testing'
  }
}

output hubId string = aiHub.id
// Inside the Hub resource properties:
managedNetwork: {
  isolationMode: 'AllowOnlyApprovedOutbound' // This is the "Mani-level" security fix
}
publicNetworkAccess: 'Disabled' // This is the "Toni-level" TD compliance fix
// ... (keep your parameters at the top)

resource aiHub 'Microsoft.MachineLearningServices/workspaces@2023-08-01-preview' = {
  name: aiHubName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: 'Hardened AI Foundry Hub'
    storageAccount: storageAccountId
    keyVault: keyVaultId
    
    // FIX #3: Integrated property (TD Compliance)
    publicNetworkAccess: 'Disabled' 
    
    // FIX #2: Using the passed-in parameters
    vnetAllowRPCAndPublicNetworkAccess: false 
    
    managedNetwork: {
      isolationMode: 'AllowOnlyApprovedOutbound' // The core security requirement
      status: {
        status: 'Active'
      }
    }
  }
}
