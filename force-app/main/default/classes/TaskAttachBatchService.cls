/**
 * Service class for starting task attachment batch processing from Aura, LWC, and Flow.
 */
public with sharing class TaskAttachBatchService {
    
    /**
     * Wrapper class used to pass task creation data from LWC.
     */
    public class LwcTaskRequest {
        @AuraEnabled public String objectTypeName { get; set; }
        /**
         * The date assigned to the Task record.
         * Used to populate the Task.ActivityDate field when creating tasks.
         */
        @AuraEnabled public Date taskDate { get; set; }
        /**
         * The priority level of the Task record.
         */
        @AuraEnabled public String taskPriority { get; set; }
        @AuraEnabled public String taskSubject { get; set; }
        @AuraEnabled public String taskType { get; set; }
        @AuraEnabled public String taskStatus { get; set; }
    }

    /**
     * Translates Flow-compatible requests into clean LwcTaskRequest wrappers.
     */
    private static List<TaskAttachBatchService.LwcTaskRequest> initializeFlowRequestList(List<TaskAttachBatchRequest> flowInputs){
        List<LwcTaskRequest> flowRequests = new List<LwcTaskRequest>();
        
        for(TaskAttachBatchRequest input : flowInputs) {
            LwcTaskRequest singleReq = new LwcTaskRequest();
            singleReq.objectTypeName = input.objectTypeName;
            singleReq.taskSubject = input.taskSubject;
            singleReq.taskDate = input.taskDate;
            singleReq.taskPriority = input.taskPriority;
            singleReq.taskType = input.taskType;
            singleReq.taskStatus = input.taskStatus;
            flowRequests.add(singleReq);
        }
        return flowRequests;
    }

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
     * Returns the picklist values for the Task.Status field as a list of
     * ComboboxOption objects suitable for use in LWC/Aura picklists.
     *
     * @return List<ComboboxOption> active status picklist entries (label/value)
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

    /**
     * Returns the picklist values for the Task.Type field as a list of
     * ComboboxOption objects suitable for use in LWC/Aura picklists.
     *
     * @return List<ComboboxOption> active type picklist entries (label/value)
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
     * Returns the picklist values for the Task.Priority field as a list of
     * ComboboxOption objects suitable for use in LWC/Aura picklists.
     *
     * @return List<ComboboxOption> active priority picklist entries (label/value)
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
     * Starts the task attachment batch from LWC/Apex by accepting a single
     * LwcTaskRequest and queuing the TaskAttachmentForSObjectsBatch.
     *
     * @param request The task request containing fields required to create tasks
     */
    @AuraEnabled
    public static void startBatchApexLWC(LwcTaskRequest request){
        try {
            String objectTypeName = request.objectTypeName;
            String taskPriority = request.taskPriority;
            String taskSubject = request.taskSubject;
            String taskType = request.taskType;
            String taskStatus = request.taskStatus;
            Date taskDate = request.taskDate;
            
            System.debug('<<<. SERVICE CLASS >> ' + objectTypeName);
            
            // Execute using the flat parameter list batch constructor
            Database.executeBatch(
                new TaskAttachmentForSObjectsBatch(
                    objectTypeName,
                    taskPriority,
                    taskSubject,
                    taskType,
                    taskStatus,
                    taskDate  
                ), 200);
        } catch (Exception e) {
            System.debug('*** EXCEPTION TYPE: ' + e.getTypeName());
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Invocable method that starts the task creation batch from Flow.
     *
     * @param request List of TaskAttachBatchRequest objects from Flow
     */
    @InvocableMethod(
        label='Start Task Batch'
        description='Starts the task creation batch.'
    )
    public static void startBatchFlow(List<TaskAttachBatchRequest> request) {
        if (request == null || request.isEmpty()) {
            System.debug('Error - Task Request list is empty');
            return;
        }
        
        // Instantiate list of LwcTaskRequest objects from the Flow request list
        List<TaskAttachBatchService.LwcTaskRequest> flowRequestList = initializeFlowRequestList(request);

        // Explicitly pull out the single request object at index 0
        TaskAttachBatchService.LwcTaskRequest singleRequest = flowRequestList[0];
    
        // Pass that single object into the object wrapper batch constructor
        Database.executeBatch(new TaskAttachmentForSObjectsBatch(singleRequest), 200);
    }
} // 🌟 Added final missing class closing brace  