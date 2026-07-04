/**
 * Controller class for managing generic object operations and Task-related functionality.
 * Provides methods to retrieve picklist values and manage taskable objects.
 */
public with sharing class GenericObjectController{
    public GenericTaskRequest request = new GenericTaskRequest();
    /**
     * The API name of the object selected for task creation.
     */
    public String objectTypeName {get;set;}
    /**
     * The selected status value for a Task record.
     */
    public String taskStatus {get;set;}
    /**
     * The selected priority value for a Task record.
     */
    public String taskPriority {get;set;}
    /**
     * The subject of the Task record being created.
     */
    public String taskSubject {get;set;}
    /**
     * The selected Type value for a Task record.
     */
    public String taskType {get;set;}
    /**
     * The date assigned to the Task record.
     */
    public Date taskDate {get;set;}
    /**
     * Wrapper class used to pass task creation data from LWC.
     */
    public class GenericTaskRequest {
        /**
         * The API name of the object type to which the Task will be related.
         */
        public String objectTypeName { get; set; }
        /**
         * The date assigned to the Task record.
         * Used to populate the Task.ActivityDate field when creating tasks.
         */
        public Date taskDate { get; set; }
        /**
         * The priority level of the Task record.
         */
        public String taskPriority { get; set; }
        /**
         * The subject of the Task record.
         */
        public String taskSubject { get; set; }
        /**
         * The type of the Task record.
         */
        public String taskType { get; set; }
        /**
         * The status of the Task record.
         */
        public String taskStatus { get; set; }
    }
   /**
    * Retrieves the list of select options for taskable objects.
    *
    * @return List<SelectOption> list of object labels and API names
    */
   public List<SelectOption> getObjectNameOptions(){

        List<SelectOption> options = new List<SelectOption>();
        
         try {
            for(Object_Task_Config__mdt e : [SELECT Object_API_Name__c, Label__c
                FROM Object_Task_Config__mdt
                WHERE Allowed_For_Tasking__c = true WITH USER_MODE
                ORDER BY Label__c ])
            {
                options.add(new SelectOption(e.Label__c, e.Object_API_Name__c));
            }
        } catch (Exception ex) {
            System.debug('Error retrieving taskable objects: ' + ex.getMessage());
        }
        return options;
    }

    /**
     * Returns the picklist values for the Task.Status field as a list of
     * SelectOption objects suitable for use in LWC/Aura picklists.
     *
     * @return List<SelectOption> active status picklist entries (label/value)
     */
    public List<SelectOption> getStatusValues(){
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.PicklistEntry entry : Task.Status.getDescribe().getPicklistValues()) {
            if(entry.isActive()) {
                options.add(new SelectOption(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }

   /**
     * Returns the picklist values for the Task.Subject field as a list of
     * SelectOption objects suitable for use in LWC/Aura picklists.
     *
     * @return List<SelectOption> active subject picklist entries (label/value)
     */
    
    public List<SelectOption> getSubjectValues(){
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.PicklistEntry entry : Task.Subject.getDescribe().getPicklistValues()) {
            if(entry.isActive()) {
                options.add(new SelectOption(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }

     /**
     * Returns the picklist values for the Task.Type field as a list of
     * SelectOption objects suitable for use in LWC/Aura picklists.
     *
     * @return List<SelectOption> active type picklist entries (label/value)
     */
    public static List<SelectOption> getTypeValues(){
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.PicklistEntry entry : Task.Type.getDescribe().getPicklistValues()) {
            if(entry.isActive()) {
                options.add(new SelectOption(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }

    /**
     * Returns the picklist values for the Task.Priority field as a list of
     * SelectOption objects suitable for use in LWC/Aura picklists.
     *
     * @return List<SelectOption> active priority picklist entries (label/value)
     */
    public static List<SelectOption> getPriorityValues(){
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.PicklistEntry entry : Task.Priority.getDescribe().getPicklistValues()) {
            if(entry.isActive()) {
                options.add(new SelectOption(entry.getLabel(), entry.getValue()));
            }
        }
        return options;
    }

    /**
     * Returns the currently selected object API name for task creation.
     *
     * @return the selected object API name
     */
    public String getSelectedObject(){
        return request.objectTypeName;
    }

    /**
     * Sets the currently selected object API name for task creation.
     *
     * @param objectTypeName The selected object API name.
     */
    public void setSelectedObject(String objectTypeName){
        this.objectTypeName = objectTypeName;
        request.objectTypeName = this.objectTypeName;   
    }

    /**
     * Returns the currently selected Task.Priority value.
     *
     * @return The selected Task.Priority value.
     */
    public String getSelectedPriority(){ 
        return this.taskPriority;
    } 

    /**
     * Sets the selected Task.Priority value for the current request.
     *
     * @param priority The Task.Priority value to assign.
     */
    public void setSelectedPriority(String priority){
        this.taskPriority = priority;
        request.taskPriority = this.taskPriority;
    }
   
    /**
     * Returns the currently selected Task.Subject value for task creation.
     *
     * @return The selected Task.Subject value.
     */
    public String getSelectedSubject(){
        return this.taskSubject;
    }

    /**
     * Sets the selected Task.Subject value for the current request.
     *
     * @param subject The Task.Subject value to assign.
     */
    public void setSelectedSubject(String subject){
        this.taskSubject = subject;
        request.taskSubject = this.taskSubject;
    }
       
    /**
     * Returns the currently selected Task.Type value.
     *
     * @return The selected Task.Type value.
     */
    public String getSelectedType(){
        return this.taskType;
    }

    /**
     * Sets the selected Task.Type value for the current request.
     *
     * @param type The Task.Type value to assign.
     */
    public void setSelectedType(String type){
        this.taskType = type;
        request.taskType = this.taskType;
    }  

    /**
     * Returns the currently selected status for the Task record.
     *
     * @return The selected Task.Status value.
     */
    public String getSelectedStatus(){   
        return this.taskStatus;
    }

    /**
     * Sets the status for the Task record being configured.
     *
     * @param status The status value to assign to the Task
     */
    public void setSelectedStatus(String status){
        this.taskStatus = status;
        request.taskStatus = this.taskStatus;
    }

    /**
     * Returns the currently selected Task due date.
     *
     * @return The date assigned to Task.ActivityDate in the current request
     */
    public Date getSelectedDate(){ 
        return request.taskDate;
    }

    /**
     * Sets the due date for the Task record being configured.
     *
     * @param taskDate The date to assign to Task.ActivityDate
     */
    public void setSelectedDate(Date taskDate){ 
        this.taskDate = taskDate;
        request.taskDate = this.taskDate;
    }

    /**
     * Starts the batch process that creates a Task related to the selected object.
     */
    public void createTask() {
        // 1. Guard check: Make sure they picked an object type before running batch
        if (String.isBlank(this.request.objectTypeName)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a target object type before executing.'));
            return;
        }

        try {  
            // 2. Execute the Batch class, passing parameters cleanly out of your request wrapper
            TaskAttachmentForSObjectsBatch batchJob = new TaskAttachmentForSObjectsBatch(
                this.request.objectTypeName, 
                this.request.taskPriority, 
                this.request.taskSubject, 
                this.request.taskType, 
                this.request.taskStatus,
                 this.request.taskDate
            );
            
            Database.executeBatch(batchJob, 200);
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Batch task creation engine successfully spawned!'));
            
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to launch batch job: ' + ex.getMessage()));
        }
    }
}