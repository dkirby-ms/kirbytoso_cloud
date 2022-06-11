@description('Azure service principal client id')
param spnClientId string

@description('Azure service principal client secret')
@secure()
param spnClientSecret string

@description('Azure AD tenant id for your service principal')
param spnTenantId string

@description('Username for Windows account')
param windowsAdminUsername string

@description('Password for Windows account. Password must have 3 of the following: 1 lower case character, 1 upper case character, 1 number, and 1 special character. The value must be between 12 and 123 characters long')
@minLength(12)
@maxLength(123)
@secure()
param windowsAdminPassword string

@description('Name for your log analytics workspace')
param logAnalyticsWorkspaceName string

@description('Target GitHub account')
param githubAccount string = 'dkirby-ms'

@description('Target GitHub branch')
param githubBranch string = 'main'

@description('Choice to deploy Bastion to connect to the client VM')
param deployBastion bool = false


var templateBaseUrl = 'https://raw.githubusercontent.com/${githubAccount}/kirbytoso_cloud/${githubBranch}/azure_infra/'

var location = resourceGroup().location

module clientVmDeployment 'adds.bicep' = {
  name: 'clientVmDeployment'
  params: {
    windowsAdminUsername: windowsAdminUsername
    windowsAdminPassword: windowsAdminPassword
    spnClientId: spnClientId
    spnClientSecret: spnClientSecret
    spnTenantId: spnTenantId
    workspaceName: logAnalyticsWorkspaceName
    stagingStorageAccountName: stagingStorageAccountDeployment.outputs.storageAccountName
    templateBaseUrl: templateBaseUrl
    flavor: flavor
    subnetId: mgmtArtifactsAndPolicyDeployment.outputs.subnetId
    deployBastion: deployBastion
    githubUser: githubUser
    location: location
  }
}
