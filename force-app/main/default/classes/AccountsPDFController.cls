public with sharing class AccountsPDFController {
    public ApexPages.StandardSetController setController;
    public List<Account> records {get;set;}
    
    public AccountsPDFController(ApexPages.StandardSetController ssc){
        this.setController = ssc;
        this.records = (List<Account>)ssc.getRecords();
        
    }
    
    public PageReference sendEmail() {
        // Get selected records
        List<Account> selectedAccounts = this.records;
        System.debug('< SENDEMAIL: Base Class for acocunts > '+this.records);
    
        if(selectedAccounts.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No accounts selected.'));
            return null;
        }
        
        List<String> accountIds = new List<String>();
        for (Account acc : selectedAccounts) {
            accountIds.add(acc.Id);
        }
    
        // Pass IDs to the PDF page
        PageReference pdfPage = Page.AccountsPDF;
        pdfPage.getParameters().put('ids', String.join(accountIds, ','));
    
        // Generate PDF blob
        Blob pdfBlob;
    	// Need to make sure we only get content if we are not Debu testing this class.
        if(Test.isRunningTest()) {
            pdfBlob = Blob.valueOf('Unit Test PDF Body');
        } else {
            pdfBlob = pdfPage.getContent();
        }
        // Create email
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Accounts.pdf');
        attachment.setBody(pdfBlob);
        attachment.setContentType('application/pdf');
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'tonante27@gmail.com'});
        mail.setSubject('Accounts PDF Export');
        mail.setPlainTextBody('Please find the attached PDF of accounts.');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Email sent with ' + selectedAccounts.size() + ' accounts.'));
		return new PageReference('/001/o');
    }
}