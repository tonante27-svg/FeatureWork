/**
 * Wrapper class for task attachment batch requests.
 */
public with sharing class TaskAttachBatchRequest {
    
    @AuraEnabled public String objectTypeName;
    @AuraEnabled public Date taskDate;
    @AuraEnabled public String taskPriority;
    @AuraEnabled public String taskSubject;
    @AuraEnabled public String taskType;
    @AuraEnabled public String taskStatus;
}