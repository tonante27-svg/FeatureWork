public with sharing class CorporateBirthdays {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getBirthdayCelebrants(Id accountId) {
        try {
            // Validate CRUD permission before SOQL query
            if (!Schema.sObjectType.Contact.isAccessible()) {
                throw new AuraHandledException('Insufficient permissions to access Contact records');
            }
            
            List<Contact> contacts = [SELECT Id, Name, Email, Birthdate FROM Contact WHERE AccountId = :accountId ];
            
            // Strip inaccessible fields based on user's FLS permissions
            SObjectAccessDecision decision = Security.stripInaccessible(
                AccessType.READABLE,
                contacts
            );
            
            if(decision.getRecords().isEmpty()){
                return new List<Contact>();
            }
            return decision.getRecords();
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}