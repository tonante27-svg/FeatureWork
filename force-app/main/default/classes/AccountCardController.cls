public with sharing class AccountCardController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, Type, Industry, Phone FROM Account LIMIT 10];
    }
}