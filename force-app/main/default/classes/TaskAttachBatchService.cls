/**
 * Service class for starting task attachment batch processing from Aura, LWC, and Flow.
 */
public with sharing class TaskAttachBatchService {


    // 1. Fetch Entity Definitions for LWC Combobox
    /**
     * Retrieves entity definitions that can be queried for the LWC combobox.
     *
     * @return A list of combobox options for queryable entities.
     */
    @AuraEnabled (cacheable = true) // Fixed casing of cacheable
    public static List<ComboboxOption> getEntityDefinitions(){
        System.debug('<<<< MEHOD CALLED >>>');
        List<ComboboxOption> options = new List<ComboboxOption>();
        try {
            for(Object_Task_Config__mdt e : [SELECT Object_API_Name__c, Label__c
                FROM Object_Task_Config__mdt
                WHERE Allowed_For_Tasking__c = true
                ORDER BY Label__c ])
            {
                options.add(new ComboboxOption(e.Label__c, e.Object_API_Name__c));
                //options.add(new ComboboxOption('TEST', 'TEST'));
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        System.debug('Options Count = ' + options.size());
        System.debug(options);
        return options;
    }

    /**
     * Retrieves active task status picklist values.
     *
     * @return A list of combobox options for task statuses.
     */
    @AuraEnabled(cacheable = true)
    public static List<ComboboxOption> getStatusValues(){
        List<ComboboxOption> options = new List<ComboboxOption>();
        for(Schema.PicklistEntry entry : Task.Status.getDescribe().getPicklistValues()) {
            if(entry.isActive()) {
                options.add(new ComboboxOption(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }

    // 3. Fetch Task Type Picklist Values
    /**
     * Retrieves active task type picklist values.
     *
     * @return A list of combobox options for task types.
     */
    @AuraEnabled(cacheable = true)
    public static List<ComboboxOption> getTypeValues(){
        List<ComboboxOption> options = new List<ComboboxOption>();
        for(Schema.PicklistEntry entry : Task.Type.getDescribe().getPicklistValues()) {
            if(entry.isActive()) {
                options.add(new ComboboxOption(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }

    /**
     * Retrieves active task priority picklist values.
     *
     * @return A list of combobox options for task priorities.
     */
    @AuraEnabled(cacheable = true)
    public static List<ComboboxOption> getPriorityValues(){
        List<ComboboxOption> options = new List<ComboboxOption>();
        for(Schema.PicklistEntry entry : Task.Priority.getDescribe().getPicklistValues()) {
            if(entry.isActive()) {
                options.add(new ComboboxOption(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }

    /**
     * Starts the batch job for creating tasks from the provided request.
     *
     * @param request The batch request data from the Lightning component.
     */
    @AuraEnabled
    public static void startBatchApexLWC(TaskAttachBatchRequest request){
        try {
            Database.executeBatch(new TaskAttachmentForSObjectsBatch(request), 200);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Starts the batch job from an invocable Flow action.
     *
     * @param requests The incoming Flow requests to process.
     */
    @InvocableMethod(
        label='Start Task Batch'
        description='Starts the task creation batch.'
    )
    public static void startBatchFlow(List<TaskAttachBatchRequest> requests) {
        if (requests == null || requests.isEmpty()) {
            System.debug('Error - Task Request list is empty');
            return;
        }

        TaskAttachBatchRequest flowReq = requests[0];
        Database.executeBatch(new TaskAttachmentForSObjectsBatch(flowReq), 200);
    }
}

