/**
 * DisplatchSchedController
 *
 * Controller used with a StandardSetController to expose a list of Contact
 * records to Visualforce pages. Initializes contactList from the provided
 * ApexPages.StandardSetController.
 */
public with sharing class DispatchSchedController {
    
    /** List of Contact records exposed to the Visualforce page. */
    public List<ContactWrapper> cwList{get; private set;}
    /** List of RouteWrapper records exposed to the Visualforce page. */
    public List<RouteWrapper> rwList{get; private set;}
    /** The departure date for the dispatch schedule. */
    public Date departDate { get; set; }
    /** The departure time for the dispatch schedule. */
    public String departTime { get; set; }
    /**
     * Available dispatch time options for the Visualforce page picklist.
     */
    

    private ApexPages.StandardSetController controller;
    
    private void initLists(){
        this.cwList = new List<ContactWrapper>();
        this.rwList = new List<RouteWrapper>();
    }

    /**
     * Constructor that initializes the controller and contact/route lists.
     *
     * @param ssc The StandardSetController used to manage the record set.
     */
    public DispatchSchedController(ApexPages.StandardSetController ssc) {
        this.controller = ssc;
        this.controller.setPageSize(25);
        this.departDate = Date.today();   // optional
        this.departTime = '9:00AM';
        initLists();
        loadContacts();
        loadRoutes();
    }
    
    /**
     * loadContacts
     *
     * Loads Contact records into a list of ContactWrapper instances.
     * Verifies Contact object-level access before querying.
        *
        * This method populates cwList with ContactWrapper instances; it does
        * not return a value.
     */
    public void loadContacts(){
        if (this.cwList == null) {
            this.cwList = new List<ContactWrapper>();
        }
        if (Schema.sObjectType.Contact.isAccessible()) {
            List<Contact> contactList = [SELECT Name, Email FROM Contact];
            for(Contact c : contactList){
                this.cwList.add(new ContactWrapper(c));
            }
        }
    }
    /**
     * loadRoutes
     *
     * Loads Bus_Route__c records into a list of RouteWrapper instances.
     * Checks object-level access before querying. Always returns the
     * rwList (may be empty if the object is not accessible).
        *
        * This method populates rwList with RouteWrapper instances; it does
        * not return a value.
     */
    public void loadRoutes(){
         if (this.rwList == null) {
            this.rwList = new List<RouteWrapper>();
        }
        if (Schema.sObjectType.Bus_Route__c.isAccessible()) {
            List<Bus_Route__c> routeList = [SELECT Id, Name FROM Bus_Route__c WITH USER_MODE];
            for(Bus_Route__c r : routeList){
                this.rwList.add(new RouteWrapper(r));
            }
        }
    }
    /**
     * items
     *
     * Returns a list of SelectOption instances representing available time slots
     * for dispatch scheduling.
     *
     * @return List<SelectOption> the list of available time options
     */
    public List<SelectOption> items {
        get{
            if(items == null){
                items = new List<SelectOption>();
                items.add(new SelectOption('9:00 AM','9:00 AM'));
                items.add(new SelectOption('11:00 AM','11:00 AM'));
                items.add(new SelectOption('1:00 PM','1:00 PM'));
                items.add(new SelectOption('3:00 PM','3:00 PM'));
                items.add(new SelectOption('5:00 PM','5:00 PM'));
            }
             return items;
        }
        private set;    
    }

   
    /**
     * saveRouteSchedule
     *
     * Processes the selected ContactWrapper and RouteWrapper instances and
     * performs the intended action (placeholder). Currently returns null as
     * no navigation is performed.
     *
     * @return PageReference Navigation target; null indicates stay on page.
     */
    public PageReference saveRouteSchedule(){
        // Now create the Route schedule using the date, taime and contact
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Passenger\'s Route Schedule was successfully created');
        ApexPages.addMessage(myMsg);
      return null;

    }
// ================= WRAPPER CLASSES: =================
     /**
     * ContactWrapper
     *
     * Lightweight wrapper around a Contact record used by the Visualforce
     * page to track selection state alongside the Contact data.
     *
     * @author Generated
     * @since 1.0
     */
    public class ContactWrapper{
        /**
         * The Contact record contained in this wrapper.
         * @remarks Used to present Contact data alongside selection state in the UI.
         */
        public Contact cont { get; set; }
        /**
         * Indicates whether the wrapped Contact is selected in the UI.
         * @remarks Used by Visualforce to track selection state for bulk actions.
         */
        public Boolean selected { get; set; }

        /**
         * Constructor for ContactWrapper.
         *
         * @param c The Contact record to be wrapped.
         */
        public ContactWrapper(Contact c){
            this.cont  = c;
            this.selected = false;
        }
    }

    /**
     * RouteWrapper
     *
     * Lightweight wrapper around a Bus_Route__c record used by the Visualforce
     * page to track selection state alongside the Bus_Route__c data.
     *
     * @author Generated
     * @since 1.0
     */
    public class RouteWrapper{
        /**
         * The Bus_Route__c record contained in this wrapper.
         * Used to present Bus Route data alongside selection state in the UI.
         */
        public Bus_Route__c route { get; set; }
        /**
         * Indicates whether the wrapped Bus_Route__c is selected in the UI.
         * @remarks Used by Visualforce to track selection state for bulk actions.
         */
        public Boolean selected { get; set; }

        /**
         * Constructor for RouteWrapper.
         *
         * @param r The Bus_Route__c record to be wrapped.
         */
        public RouteWrapper(Bus_Route__c r){
            this.route  = r;
            this.selected = false;
        }
    }
}