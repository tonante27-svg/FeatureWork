/**
 * Batch service for removing tasks related to allowable sObjects.
 */
public with sharing class RemoveTasksBatchService {
   
    String objectTypeName;

/**
     * Returns the list of allowable objects configured for tasking.
     *
     * @return List<ComboboxOption> allowable objects (label/value)
     */
    @AuraEnabled (cacheable = true)
    public static List<ComboboxOption> getAllowableObjects(){
        List<ComboboxOption> options = new List<ComboboxOption>();
        try {
            for(Object_Task_Config__mdt e : [SELECT Object_API_Name__c, Label__c
                FROM Object_Task_Config__mdt
                WHERE Allowed_For_Tasking__c = true WITH USER_MODE
                ORDER BY Label__c ])
            {
                options.add(new ComboboxOption(e.Label__c, e.Object_API_Name__c));
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return options;
    }

    
    /**
     * Starts the batch Apex job to remove Tasks for the specified sObject type.
     *
     * @param objectTypeName API name of the sObject to process (e.g. Contact)
     * @throws AuraHandledException when the object does not have an AccountId field
     */
    @AuraEnabled
    public static void startBatchApexLWC(String objectTypeName){
        String objectName = objectTypeName;
        //Get Ids from the Object Name
        // Check if this object is realted to an Account via AcocuntId

         Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe()
            .get(objectTypeName)
            .getDescribe()
            .fields
            .getMap();
            
        // 2. Check if 'AccountId' exists in the map keys (case-insensitive check)
            if(!fieldsMap.containsKey('AccountId')){
                throw new AuraHandledException('Invalid object type Ids: Empty list.'); 
            }else{
                 Database.executeBatch(
                new RemoveTaskForSObjectsBatch(objectName), 200);
            }

    }

}