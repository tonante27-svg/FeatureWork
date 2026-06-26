/**
 * Wrapper class used to invoke Tasking attachment for records of  unknown SObjects via batch apex.
 */
public with sharing class BulkSObjectWrapper {
    /**
     * Inner wrapper for invocable parameters.
     */
    public class SObjectWrapper { 
        @InvocableVariable(required=true) public String sObjectName; 
        @InvocableVariable(required=true) public Date aDate;
        @InvocableVariable(required=true) public String aPriority;
        @InvocableVariable(required=true) public String aSubject;
        @InvocableVariable(required=true) public String aType;
        @InvocableVariable(required=true) public String aStatus;
    }


   
    /**
     * Invocable method to call batch apex for processing SObjects.
     * @param someObjectsWrapper list of wrapper objects containing object type names
     */
    @InvocableMethod(label='Task Attachment Process for SObjects via Batch' description='Calling Batch Apex to Process Unknown Objects and create new tasks for their records.')
    public static List<BulkSObjectWrapper.SObjectWrapper> callProcessSObjects(List<BulkSObjectWrapper.SObjectWrapper> someObjectsWrapper) {
        if (someObjectsWrapper == null || someObjectsWrapper.isEmpty()) {
            return someObjectsWrapper;
        }

        // serialize the wrapper into a string
        String wrapperSerialized = JSON.serialize(someObjectsWrapper[0]);

        // Call Batch Apex to create a Task For Each record
        TaskAttachmentForSObjectsBatch myBatch = new TaskAttachmentForSObjectsBatch(wrapperSerialized);
        ID batchProcessID = Database.executeBatch(myBatch, 200);
        return someObjectsWrapper;
    }
}