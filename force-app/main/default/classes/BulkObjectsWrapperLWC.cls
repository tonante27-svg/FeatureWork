public with sharing class BulkObjectsWrapperLWC {
    public class ComboboxOption{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }

    @AuraEnabled (Cacheable = true)
    public static List<ComboboxOption> getEntityDefinitions(){
        List<ComboboxOption> options = new List<ComboboxOption>();
        try {
            for(EntityDefinition e : [SELECT QualifiedApiName, Label
                                       FROM EntityDefinition
                                       WHERE IsQueryable = true WITH USER_MODE
                                       ORDER BY Label ]){
                ComboboxOption anOption = new ComboboxOption(e.Label, e.QualifiedApiName);
                options.add(anOption);
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return options;
    }

    @AuraEnabled(cacheable = true)
    public static List<ComboboxOption> getStatusValues(){
    List<Schema.PicklistEntry> entries = Task.Status.getDescribe().getPicklistValues();
    }
     @AuraEnabled(cacheable = true)
    public static List<ComboboxOption> getTypeValues(){
    List<Schema.PicklistEntry> entries = Task.Type.getDescribe().getPicklistValues();
    }

     @AuraEnabled(cacheable = true)
    public static List<ComboboxOption> getPriorityValues(){
    List<Schema.PicklistEntry> entries = Task.Priorty.getDescribe().getPicklistValues();
    }
}