// infra/modules/aks.bicep
param clusterName string
param location string
param subnetId string

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    // Hardening: Disabling local accounts to force Entra ID login
    disableLocalAccounts: true 
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: subnetId // Plugs into your secure VNet
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      networkDataplane: 'cilium' // SME Choice: Best for security visibility
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
    }
  }
}

output clusterName string = aks.name
