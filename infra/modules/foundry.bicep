// Parameters (Fixes Copilot point #2: Ensure these are used)
param aiHubName string
param location string
param storageAccountId string
param keyVaultId string
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
    
    // FIX #3: publicNetworkAccess must be INSIDE the properties block
    publicNetworkAccess: 'Disabled' 
    
    // Using the VNet parameters to satisfy the linter (Copilot point #2)
    vnetAllowRPCAndPublicNetworkAccess: false
    
    managedNetwork: {
      // THE SECURITY FIX: 
      isolationMode: 'AllowOnlyApprovedOutbound'
      status: {
        status: 'Active'
      }
    }
  }
}

// Output the ID so the main template can use it
output aiHubId string = aiHub.id
