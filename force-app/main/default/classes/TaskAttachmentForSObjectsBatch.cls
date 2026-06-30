/**
 * Batch class to process sObjects and create follow-up Tasks based on JSON configuration.
 */
public with sharing class TaskAttachmentForSObjectsBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    // Configuration blueprint variables
    public String objectTypeName;
    public Date taskDate;
    public String taskPriority;
    public String taskSubject;
    public String taskType;
    public String taskStatus;

    private Integer taskCount = 0;

    /**
     * Constructor 1: Accepts individual primitive parameters (Called by LWC Service route)
     */
    public TaskAttachmentForSObjectsBatch(
            String objectTypeName,
            String taskPriority,
            String taskSubject,
            String taskType, 
            String taskStatus,
            Date taskDate) {
        
        this.objectTypeName = objectTypeName;
        this.taskPriority = taskPriority;
        this.taskSubject = taskSubject;
        this.taskType = taskType;
        this.taskStatus = taskStatus;
        this.taskDate = taskDate;
        
        if (String.isNotBlank(this.objectTypeName)) {
            System.debug('BATCH: << OBJECT TYPE NAME >> ' + this.objectTypeName);
            if (!Schema.getGlobalDescribe().containsKey(this.objectTypeName)) {
                throw new AuraHandledException('Invalid object type: ' + this.objectTypeName);
            }
        }  
    }

    /**
     * Constructor 2: Accepts the LWC Wrapper object (Called by Flow Service route)
     * 🌟 This is exactly what you wrote, and it is completely correct!
     */
    public TaskAttachmentForSObjectsBatch(TaskAttachBatchService.LwcTaskRequest request) {
         
        if (request != null) {
            this.objectTypeName = request.objectTypeName;
            this.taskSubject = request.taskSubject;
            this.taskDate = request.taskDate;
            this.taskPriority = request.taskPriority;
            this.taskType = request.taskType;
            this.taskStatus = request.taskStatus;
            
            System.debug('BATCH (Wrapper): << OBJECT TYPE NAME >> ' + this.objectTypeName);
            if (String.isNotBlank(this.objectTypeName) && !Schema.getGlobalDescribe().containsKey(this.objectTypeName)) {
                throw new AuraHandledException('Invalid object type: ' + this.objectTypeName);
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
        String lowerObjName = objectTypeName.toLowerCase();
        if (lowerObjName == 'contact' || lowerObjName == 'opportunity' || lowerObjName == 'case') {
            query = 'SELECT Id, AccountId FROM ' + objectTypeName;
        } else {
             query = 'SELECT Id FROM ' + objectTypeName;
        }
        return Database.query(query);
    }

    /**
     * Execute processes the records in chunks and creates tasks attached to them.
     */
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Task> tasksToCreate = new List<Task>();
       
        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectTypeName).getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = describeResult.fields.getMap();
        String objType = objectTypeName != null ? objectTypeName.toLowerCase() : null;
        
        for (SObject sObj : scope) {
            Task t = new Task();
        //Use WHO Side (People objects)
            if (objType == 'lead' || objType == 'contact') {
                t.WhoId = sObj.Id;
            }else{
                t.WhatId = sObj.Id;
            }
            t.Subject = taskSubject;
            t.Priority = taskPriority;
            t.ActivityDate = taskDate;
            t.Status = taskStatus;
            t.Type = taskType;
            // 🌟 Fixed: Avoid safe-assignment syntax issue with a clean string assignment
            t.Description = 'Processed Object Type: ' + objectTypeName;
            
            tasksToCreate.add(t);
        }
        
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
            taskCount += tasksToCreate.size(); // 🌟 Fixed: accumulate total size instead of overwriting it
        }
    }

    /**
     * Finish method sends out notifications and summary emails.
     */
    public void finish(Database.BatchableContext bc) {
        String txtEmailBody = 'The total number of task records appended to object ' + objectTypeName + ' is: ' + taskCount;
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setSubject('Processed Object Type: ' + objectTypeName); // 🌟 Fixed: added proper setter method syntax
        msg.setToAddresses(new List<String>{'emiliosilva181@gmail.com'});
        msg.setPlainTextBody(txtEmailBody); // 🌟 Fixed: added proper setter method syntax
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {msg};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].isSuccess()){ // 🌟 Fixed: use isSuccess() method call
             System.debug('The email was sent successfully.');
        } else {
             System.debug('The email could not be sent.' + results[0].getErrors()[0].getMessage()); // 🌟 Fixed: use proper array getters
        }
        
        Id jobId = bc.getJobId();
        AsyncApexJob job = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedDate, CompletedDate
            FROM AsyncApexJob
            WHERE Id = :jobId
            LIMIT 1
        ];

        System.debug('Batch Status: ' + job.Status);
        System.debug('Processed: ' + job.JobItemsProcessed + '/' + job.TotalJobItems);
      
        CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Batch_Status_Notification' LIMIT 1];
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setBody('The background task creation for ' + this.objectTypeName + ' has finished running.');
        notification.setTitle(taskCount + ' Tasks Attached Successfully!');
        notification.setNotificationTypeId(type.Id);
        notification.setTargetId(UserInfo.getUserId());
        
        try {
            notification.send(new Set<String> { UserInfo.getUserId() });
        } catch (Exception e) {
            System.debug('Error sending notification: ' + e.getMessage());
        }
    }
}