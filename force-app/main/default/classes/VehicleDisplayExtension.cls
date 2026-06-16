/**
 * Extension controller for displaying Vehicle__c records with pagination support.
 */
public with sharing class VehicleDisplayExtension {
     /**
     * StandardSetController for managing Vehicle__c records.
     */
    public ApexPages.StandardSetController ssc {get;  set;}
    
    /**
     * Constructor to initialize the StandardSetController.
     */
    public VehicleDisplayExtension() {
         this.ssc = controller;
        this.ssc.setPageSize(25);
    }

      /**
     * Returns the list of Vehicle__c records for the current StandardSetController.
     * @return List<Vehicle__c> list of vehicle records from the StandardSetController
     */
    public List<Vehicle__c> getVehicles(){
        List<Vehicle__c> vehs = ssc.getRecords();
        return vehs;
    }
}