/**
 * Controller extension for Case management, providing related cases and case history.
 */
public with sharing class CaseManagerExtension {
    ApexPages.StandardController controller;
    List<Case> cases {get;set;}
    List<CaseHistory> caseHistories {get;set;}

    /**
     * Constructor for CaseManagerExtension.
     *
     * @param controller Standard controller for Case.
     */
    public CaseManagerExtension(ApexPages.StandardController controller) {
        this.controller = controller;
        if (!Schema.sObjectType.Case.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No access to case records.'));
            return;
        }
        this.cases = [SELECT Id, Subject, Status FROM Case WHERE Id = :controller.getId()];
        if(cases.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Case not found.'));
        }
    }

    /**
     * Refreshes the current Visualforce page by redirecting to the current URL
     * and adding refresh parameters.
     */
    public void refreshPage() {
        // Refresh the page by redirecting to the current URL
        PageReference currentPage = ApexPages.currentPage();
        currentPage.setRedirect(true);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Page refreshed successfully.'));
        ApexPages.currentPage().getParameters().put('refresh', 'true');
        ApexPages.currentPage().getParameters().put('timestamp', String.valueOf(System.currentTimeMillis()));
        ApexPages.currentPage().getParameters().put('caseId', controller.getId());
    }

    /**
     * Sends an email notification to the active System Administrator
     * related to the current case.
     */
    public void sendEmailNotification() {
        String txtEmailBody = 'Case Records have been updated. Please review the changes.';
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setSubject('Processed Contacts'); // 🌟 Fixed: added proper setter method syntax
        msg.setToAddresses(new List<String>{'emiliosilva181@gmail.com'});
        msg.setPlainTextBody(txtEmailBody); // 🌟 Fixed: added proper setter method syntax
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {msg};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].isSuccess()){ // 🌟 Fixed: use isSuccess() method call
             System.debug('The email was sent successfully.');
        } else {
             System.debug('The email could not be sent.' + results[0].getErrors()[0].getMessage()); // 🌟 Fixed: use proper array getters
        }
    }
}