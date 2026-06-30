/**
 * Wrapper class for task attachment batch requests.
 */
public with sharing class TaskAttachBatchRequest {
    @InvocableVariable(required = true)
    @AuraEnabled
    public String objectTypeName{get;set;}
    @InvocableVariable(required = true)
    @AuraEnabled
    public Date taskDate{get;set;}
    @InvocableVariable(required = true)
    @AuraEnabled
    public String taskPriority{get;set;}
    @InvocableVariable(required = true)
    @AuraEnabled
    public String taskSubject{get;set;}
    @InvocableVariable(required = true)
    @AuraEnabled
    public String taskType{get;set;}
    @InvocableVariable(required = true)
    @AuraEnabled
    public String taskStatus{get;set;}
}