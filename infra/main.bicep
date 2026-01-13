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
// 6. Enable Defender CSPM (Cloud Security Posture Management)
resource defenderCloudPosture 'Microsoft.Security/pricings@2024-01-01' = {
  name: 'CloudPosture'
  properties: {
    pricingTier: 'Standard'
  }
}
// ==========================================
// PHASE 2: ATTACK SURFACE (NETWORKING & VMS)
// ==========================================

// 7. Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-hve-lab'
  location: location
  scope: rg // <--- ADD THIS
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'snet-victims'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

// 8. Windows Victim 
resource nicWindows 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-win-victim'
  location: location
  scope: rg // <--- ADD THIS
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: vnet.id, 'properties/subnets/0': {} } // Refined for scope
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource windowsVM 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'vm-win-victim'
  location: location
  scope: rg // <--- ADD THIS
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

// 9. Linux Victim
resource nicLinux 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-nix-victim'
  location: location
  scope: rg // <--- ADD THIS
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: vnet.id, 'properties/subnets/0': {} } // Refined for scope
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource linuxVM 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'vm-nix-victim'
  location: location
  scope: rg // <--- ADD THIS
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
}
