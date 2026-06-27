/**
 * Wrapper class for task attachment batch requests.
 */
public with sharing class TaskAttachBatchRequest {
    @InvocableVariable(required = true)
    @AuraEnabled
    public String objectTypeName;
    @InvocableVariable(required = true)
    @AuraEnabled
    public Date taskDate;
    @InvocableVariable(required = true)
    @AuraEnabled
    public String taskPriority;
    @InvocableVariable(required = true)
    @AuraEnabled
    public String taskSubject;
    @InvocableVariable(required = true)
    @AuraEnabled
    public String taskType;
    @InvocableVariable(required = true)
    @AuraEnabled
    public String taskStatus;
}