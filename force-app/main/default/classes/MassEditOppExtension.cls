/**
 * Controller extension to support mass editing selected Opportunity records.
 */
public with sharing class MassEditOppExtension {
    ApexPages.StandardSetController setController;

    /**
     * The list of Opportunity records selected for bulk edit.
     */
    public List<Opportunity>  oppsToEdit{get;set;}

    /**
     * Constructor for the mass edit Opportunity extension.
     * @param ssc The standard set controller providing the selected records.
     */
    public MassEditOppExtension(ApexPages.StandardSetController ssc) {
        this.setController = ssc;
        // Grab the records selected by the checkboxes on the list view
        this.oppsToEdit = (List<Opportunity>)ssc.getSelected();
        if (this.oppsToEdit == null || this.oppsToEdit.isEmpty()) {
            if (Schema.sObjectType.Opportunity.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
                && Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
                && Schema.sObjectType.Opportunity.fields.CloseDate.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Amount.isAccessible()) {
                this.oppsToEdit = [SELECT Name, StageName, CloseDate, Amount FROM Opportunity LIMIT 20];
            } else {
                this.oppsToEdit = new List<Opportunity>();
            }
        }
    }

    /**
     * Saves the edited Opportunity records and redirects the user back to the Opportunity home tab.
     * @return A PageReference to the Opportunity home tab on success, or null when an error occurs.
     */
    public PageReference saveChanges() {
        try {
            if (this.oppsToEdit != null && !this.oppsToEdit.isEmpty()) {
                if (!Schema.sObjectType.Opportunity.isUpdateable()
                    || !Schema.sObjectType.Opportunity.fields.StageName.isUpdateable()
                    || !Schema.sObjectType.Opportunity.fields.CloseDate.isUpdateable()
                    || !Schema.sObjectType.Opportunity.fields.Amount.isUpdateable()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient access to update Opportunity records.'));
                    return null;
                }
                update oppsToEdit;
            }
            // Redirect the user back to the Opportunity home tab on success
            PageReference pageRef = new PageReference('/006/o');
            pageRef.setRedirect(true);
            return pageRef;
        } catch (DmlException dex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'DML Error: ' + dex.getDmlMessage(0)));
            return null;
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'System Error: ' + ex.getMessage()));
            return null;
        }

    }

}