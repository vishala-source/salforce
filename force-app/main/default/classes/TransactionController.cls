public with sharing class TransactionController {
    @AuraEnabled(cacheable=true)
    public static List<Library_Transaction__c> getTransactions() {
        Id currentUserId = UserInfo.getUserId(); // Get the logged-in User ID

        // Fetch Id, Name, Issue Date, Due Date, Return Date, and Status
        return [SELECT Id, Name, Issue_Date__c, Due_Date__c, Return_Date__c, Status__c
                FROM Library_Transaction__c 
                WHERE User__c = :currentUserId];
    }
}

