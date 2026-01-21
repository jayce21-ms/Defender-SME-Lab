targetScope = 'resourceGroup'

@description('Deployment location')
param location string = resourceGroup().location

@description('AKS cluster name')
param clusterName string = 'sme-hardened-aks'

@description('Resource group where the secure VNet lives')
param vnetResourceGroup string

@description('Secure VNet name')
param vnetName string

@description('Isolated subnet name in the secure VNet')
param subnetName string

// Reference the secure VNet and subnet
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroup)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  name: subnetName
  parent: vnet
}

// Reference the AKS module and pass the subnet from our secure VNet
module aksCluster './modules/aks.bicep' = {
  name: 'aksDeployment'
  params: {
    clusterName: clusterName
    location: location
    subnetId: subnet.id // Direct link to our isolated subnet
  }
}