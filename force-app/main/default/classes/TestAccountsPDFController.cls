@isTest
public class TestAccountsPDFController {
    
    @testSetup
    public static void testCreateAccounts(){
        List<Account> accts = new List<Account>();
        for(Integer i=0;i< 10; i++){
            accts.add(new Account(Name='TesterAcct'+i, Rating='Warm', Industry='Agriculture'));
        }
        
        Database.insert(accts, false);
    }
    
    @isTest
    public static void testGoodPDF(){
       	ApexPages.StandardSetController sec = new ApexPages.StandardSetController([SELECT Id, Name, Rating, Industry FROM Account LIMIT 10 ]);
		System.debug('SETCONTROLLER : '+(List<Account>)sec.getRecords());
		AccountsPDFController apc = new AccountsPDFController(sec);
        System.debug('APC: '+apc.records);
        Assert.isTrue(sec.getRecords().size() > 0);
        apc.setController = sec;
        System.debug('APC: '+apc.records);
        apc.sendEmail();
    }
    
    @isTest
    public static void testBadPDF(){
        List<Account> emptyList = new List<Account>();
       	ApexPages.StandardSetController sec = new ApexPages.StandardSetController(emptyList);
		System.debug('SETCONTROLLER : '+(List<Account>)sec.getRecords());
		AccountsPDFController apc = new AccountsPDFController(sec);
        System.debug('APC: '+apc.records);
        Assert.isFalse(sec.getRecords().size() > 0);
        apc.setController = sec;
        System.debug('APC: '+apc.records);
        Assert.isFalse(apc.records == null);
        ApexPages.PageReference pr;
        // get new governor limits
        Test.startTest();
        pr = apc.sendEmail();
       Test.stopTest();
        
        System.assertEquals(null, pr, 'This should be null page pointer');
       	List<ApexPages.Message> messages =  ApexPages.getMessages();
        // SAFETY CHECK: This prevents the Index Out of Bounds error
    	System.assert(!messages.isEmpty(), 'The message list was NOT empty! The error was never added.');
        System.assertEquals(1, messages.size(), 'The controller should have added one error message.');
        System.assertEquals(ApexPages.Severity.ERROR, messages[0].getSeverity());
        System.assertEquals('No accounts selected.', messages[0].getSummary());
        
        
    }

}