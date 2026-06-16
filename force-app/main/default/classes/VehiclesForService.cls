public with sharing class VehiclesForService {
    public VehiclesForService() {

    }
    @AuraEnabled(cachable = true)
    public static List<Vehicle__c> getVehicles(){
        try {
            return [SELECT Id, VIN__c, Make__c,Model__c,Year__c FROM Vehicle__c WITH USER MODE];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
   
}