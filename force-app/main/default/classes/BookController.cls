public without sharing class BookController {
    @AuraEnabled(cacheable=true)
    public static List<Book__c> getBooks() {
        return [SELECT Id, Name, Author__c, Genre__c, Available_Copies__c FROM Book__c LIMIT 10];
    }
}