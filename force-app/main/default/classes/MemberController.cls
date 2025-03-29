public with sharing class MemberController {
    @AuraEnabled(cacheable=true)
    public static List<Library_Member__c> getMembers() {
        return [SELECT Id, Member_Name__c, Email_Address__c, Phone_Number__c, Membership_Expiry_Date__c FROM Library_Member__c LIMIT 10];
    }
}
