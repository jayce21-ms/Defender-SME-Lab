// workloads.bicep
param location string
param vnetName string = 'vnet-hve-lab'

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.0.0.0/16'] }
    subnets: [
      {
        name: 'snet-victims'
        properties: { addressPrefix: '10.0.1.0/24' }
      }
    ]
  }
}

// Windows Victim
resource nicWindows 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-win-victim'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: vnet.properties.subnets[0].id }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource windowsVM 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'vm-win-victim'
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    hardwareProfile: { vmSize: 'Standard_B2s' }
    osProfile: {
      computerName: 'win-victim'
      adminUsername: 'azureuser'
      adminPassword: 'SME-Lab-Password-2026!'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter-Azure-Edition'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [{ id: nicWindows.id }]
    }
  }
}

// Linux Victim
resource nicLinux 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-nix-victim'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: vnet.properties.subnets[0].id }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource linuxVM 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'vm-nix-victim'
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    hardwareProfile: { vmSize: 'Standard_B2s' }
    osProfile: {
      computerName: 'nix-victim'
      adminUsername: 'azureuser'
      adminPassword: 'SME-Lab-Password-2026!'
      linuxConfiguration: { disablePasswordAuthentication: false }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [{ id: nicLinux.id }]
    }
  }
}]