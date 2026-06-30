/**
 * Batch class to remove Task records related to a specific SObject type.
 *
 * This class supports batch processing and maintains state across transactions
 * to track the total number of Task records removed.
 */
public with sharing class RemoveTaskForSObjectsBatch implements Database.Batchable<SObject>, Database.Stateful {
   
   Integer totalTasksRemoved = 0;
   String objectTypeName {get; set;}

    /**
     * Constructor for the batch class to remove Task records related to a specific SObject type.
     *
     * @param objectTypeName the API name of the SObject type whose related Tasks will be removed
     */
    public RemoveTaskForSObjectsBatch(String objectTypeName) {
        // Check the validity of the object name first.
        this.objectTypeName = objectTypeName;
        if (String.isNotBlank(this.objectTypeName)) {
            System.debug('BATCH: << OBJECT TYPE NAME >> ' + this.objectTypeName);
            if (!Schema.getGlobalDescribe().containsKey(this.objectTypeName)) {
                throw new AuraHandledException('Invalid object type: ' + this.objectTypeName);
            }
        }

    }
    /**
     * Returns a query locator for Tasks related to the configured SObject type.
     *
     * @param bc the batchable context for the current execution
     * @return QueryLocator for Task records linked via WhatId
     */
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query='';
        //Get our tasks from all the WhatIds belonging to this object Type.
        if(this.objectTypeName.equalsIgnoreCase('Contact') || this.objectTypeName.equalsIgnoreCase('Lead')){
            query = 'SELECT Id FROM Task WHERE WhoId IN (SELECT Id FROM ' + String.escapeSingleQuotes(this.objectTypeName) + ')';
        }else{
            query = 'SELECT Id FROM Task WHERE WhatId IN (SELECT Id FROM ' + String.escapeSingleQuotes(this.objectTypeName) + ')';
        }
        return Database.getQueryLocator(query);
    }

    /**
     * Executes the batch operation on a chunk of Task records.
     *
     * @param bc The batchable context for the current execution
     * @param scope The list of Task records in the current batch chunk to be processed
     * @throws AuraHandledException when no tasks are found in the provided scope
     */
    public void execute(Database.BatchableContext bc, List<Task> scope){
        if(scope != null && !scope.isEmpty()){
            totalTasksRemoved += scope.size();
            delete scope;
        }
    }

    /**
     * Finalizes the batch execution by sending email and notification summaries.
     *
     * @param bc The batchable context for the current execution
     */
    public void finish(Database.BatchableContext bc){
        String txtEmailBody = 'The total number of task records removed from object ' + objectTypeName + ' is: ' + totalTasksRemoved;
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
        notification.setBody('The background task creation for ' + this.objectTypeName + ' has finished running.'+
        '\n with '+job.JobItemsProcessed+ 'Processes');
        notification.setTitle(totalTasksRemoved + ' Tasks Removed Successfully from all objects!');
        notification.setNotificationTypeId(type.Id);
        notification.setTargetId(UserInfo.getUserId());
        
        try {
            notification.send(new Set<String> { UserInfo.getUserId() });
        } catch (Exception e) {
            System.debug('Error sending notification: ' + e.getMessage());
        }
    }
}