public with sharing class TaskAttachBatchService {

    @AuraEnabled
    public static void startBatch(TaskBatchRequest request){
        try {
            Database.executeBatch(new TaskAttachmentForSObjectsBatch,200);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void startBatchForApex(TaskBatchRequest request){
        Database.executeBatch(new TaskAttachmentForSObjectsBatch,200);

    }
}