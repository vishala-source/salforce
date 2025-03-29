public without sharing class LibraryController {

    @AuraEnabled(cacheable=true)
    public static List<Book__c> getBooks() {
        return [SELECT Id, Name, Author__c, Genre__c, Available_Copies__c FROM Book__c LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static List<Library_Member__c> getMembers() {
        return [SELECT Id, Member_Name__c, Email_Address__c, Phone_Number__c, Membership_Expiry_Date__c FROM Library_Member__c LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static List<Library_Transaction__c> getTransactions() {
        return [SELECT Id, Name, Book__c, Library_Member__c, Issue_Date__c, Due_Date__c, Return_Date__c FROM Library_Transaction__c LIMIT 10];
    }
}
