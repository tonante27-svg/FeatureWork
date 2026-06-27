/**
 * Batch class to process sObjects and create follow-up Tasks based on JSON configuration.
 */
public with sharing class TaskAttachmentForSObjectsBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    // Maintain state of the wrappers passed from the Invocable context
    
    // Configuration blueprint variables
    private String objectTypeName;
    private Date taskDate;
    private String taskPriority;
    private String taskSubject;
    private String taskType;
    private String taskStatus;
    private Integer taskCount = 0;
    // Constructor accepts the whole collection
    public TaskAttachmentForSObjectsBatch(TaskAttachBatchRequest requests){
        if(requests != null){
            // Map<String, Object> blueprint = (Map<String, Object>) JSON.deserializeUntyped(jsonConfig);
            this.objectTypeName = requests.objectTypeName;
            this.taskPriority = requests.taskPriority;
            this.taskSubject = requests.taskSubject;
            this.taskType = requests.taskType;
            this.taskStatus = requests.taskStatus;
            if(requests.taskDate != null){
                this.taskDate = requests.taskDate;
            }
        }  
    }

    /**
     * Start method returns the query scope for the batch query.
     */
    public Iterable<SObject> start(Database.BatchableContext bc) {
        String query = '';
        if (String.isBlank(objectTypeName)) {
            return new List<SObject>();
        }
        if(objectTypeName.toLowerCase() == 'contact' || 
            objectTypeName.toLowerCase() == 'opportunity' || objectTypeName.toLowerCase() =='case'){
            query = 'SELECT Id, AccountId FROM ' + objectTypeName;
        }else{
             query = 'SELECT Id FROM ' + objectTypeName;
        }
        return Database.query(query);
    }

    /**
     * Execute processes the wrappers in chunks (scoped by the size specified in executeBatch).
     * Creates tasks attached to the processed sObjects.
     */
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Task> tasksToCreate = new List<Task>();
       
        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectTypeName).getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = describeResult.fields.getMap();
        String objType = objectTypeName != null
        ? objectTypeName.toLowerCase()
        : null;
        
        for(SObject sObj : scope ){
            Task t = new Task();
            // For each SObject in scope, match against wrappers and create tasks
            // You may need to match sObj.Id to a wrapper, depending on use-case
            // WHO side
            if (objType == 'lead' || objType == 'contact') {
                t.WhoId = sObj.Id;
            }
            if(fieldsMap.containsKey('AccountId') && objType != 'contact'){
                t.WhatId = (Id) sObj.get('AccountId');
            }
            t.Subject = taskSubject;
            t.Priority = taskPriority;
            t.ActivityDate = taskDate;
            t.Status = taskStatus;
            t.Type = taskType;
            t.Description += '\nProcessed Object Type: ' + objectTypeName;
            tasksToCreate.add(t);
        }//For
        
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
            taskCount = tasksToCreate.size();
        }
    }
    /**
     * Execute email and notification concerning the total trasks created and appeded to the sObject
     * 
     */
    public void finish(Database.BatchableContext bc) {
        // Optional: Send an email confirmation or log results
        String txtEmailBody = 'The tottal number of task records appended to object '+objectTypeName+' is: '+taskCount;
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.subject = '\nProcessed Object Type: ' + objectTypeName;
        msg.toAddresses = new List<String>{'emiliosilva181@gmail.com'};
        msg.plainTextBody = txtEmailBody;
        Messaging.SingleEmailMessage[] messages = 
        new List<Messaging.SingleEmailMessage> {msg};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success){
             System.debug('The email was sent successfully.');
        }else{
                System.debug('The email could not be sent.'+ results[0].errors[0].message);
        }
         Id jobId = bc.getJobId();

        AsyncApexJob job = [
            SELECT Id,
                   Status,
                   NumberOfErrors,
                   JobItemsProcessed,
                   TotalJobItems,
                   CreatedDate,
                   CompletedDate
            FROM AsyncApexJob
            WHERE Id = :jobId
            LIMIT 1
        ];

        System.debug('Batch Status: ' + job.Status);
        System.debug('Processed: ' + job.JobItemsProcessed + '/' + job.TotalJobItems);
      
        //Send notification too
       // Get the Notification Type Id (Setup -> Custom Notifications)
        CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Batch_Status_Notification' LIMIT 1];
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setBody('The background task creation for ' + this.objectTypeName + ' has finished running.');
        notification.setTitle(taskCount+' Tasks Attached Successfully!');
        notification.setNotificationTypeId(type.Id);
        notification.setTargetId(UserInfo.getUserId()); // Or send to a specific record page
        
        try {
            // Send to the user who kicked off the batch
            notification.send(new Set<String> { UserInfo.getUserId() });
        } catch (Exception e) {
            System.debug('Error sending notification: ' + e.getMessage());
        }

    }//FINISH
}