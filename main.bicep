@description('Resources location')
// param location string = resourceGroup().location

param location string = 'eastus'

//----------- Storage Account Parameters ------------
@description('Function Storage Account name')
@minLength(3)
@maxLength(24)
param storageAccountName string = 'stgoiuop'

@description('Function Storage Account SKU')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageAccountSku string = 'Standard_LRS'

//----------- Application Insights Parameters ------------
@description('Application Insights name')
param applicationInsightsName string = 'apiinghtsfortest'

//----------- Function App Parameters ------------
@description('Function App Plan name')
param planName string = 'asp-poi'

@description('Function App Plan operating system')
@allowed([
  'Windows'
  'Linux'
])
param planOS string = 'Windows'

@description('Function App name')
param functionAppName string

@description('Function App runtime')
@allowed([
  'dotnet'
  'node'
  'python'
  'java'
])
param functionAppRuntime string = 'dotnet'

@description('The name of the API Management service instance')
param apiManagementServiceName string = 'apiservice${uniqueString(resourceGroup().id)}'

@description('The email address of the owner of the service')
@minLength(1)
param publisherEmail string = 'hrushikesh.yalavarthi@outlook.com'

@description('The name of the owner of the service')
@minLength(1)
param publisherName string = 'Hrushikesh Y'





var buildNumber = uniqueString(resourceGroup().id)




//----------- Storage Account Deployment ------------
module storageAccountModule 'templates/StorageAccount.bicep' = {
  name: 'stvmdeploy-${buildNumber}'
  params: {
    name: storageAccountName
    sku: storageAccountSku
    location: location
  }
}

//----------- Application Insights Deployment ------------
module applicationInsightsModule 'templates/AppInsights.bicep' = {
  name: 'appideploy-${buildNumber}'
  params: {
    name: applicationInsightsName
    location: location
  }
}

//----------- App Service Plan Deployment ------------
module appServicePlan 'templates/AppServicePlan.bicep' = {
  name: 'plandeploy-${buildNumber}'
  params: {
    name: planName
    location: location
    os: planOS
  }
}

//----------- Function App Deployment ------------
module functionAppModule 'templates/FunctionApp.bicep' = {
  name: 'funcdeploy-${buildNumber}'
  params: {
    name: functionAppName
    location: location
    planId: appServicePlan.outputs.planId
  }
  dependsOn: [
    storageAccountModule
    applicationInsightsModule
    appServicePlan
  ]
}

//------------ API Management Deployment -----------

module api_management './templates/apim.bicep' ={
  name: apiManagementServiceName
  
  params: {
    location: location
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}
  