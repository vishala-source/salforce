public with sharing class TransactionController {
    @AuraEnabled(cacheable=true)
    public static List<Library_Transaction__c> getTransactions() {
        return [SELECT Id, Name, Book__c, Library_Member__c, Issue_Date__c, Due_Date__c, Return_Date__c FROM Library_Transaction__c LIMIT 10];
    }
}
