// Define Parameters
param location string 
param logicAppName string
// param logicAppDefinition object
@description('A test URI')
param testUri string = 'https://status.azure.com/en-us/status/'

var workflowSchema = 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'



// Actual logic app
resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    definition: {
      '$schema': workflowSchema
      contentVersion: '1.0.0.0'
      parameters: {
        testUri: {
          type: 'string'
          defaultValue: testUri

        }
        triggers: {}
        actions: {}
        outputs: {}  
      }
    }
  }
}
