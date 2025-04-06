public with sharing class FineRestController {
    
    @AuraEnabled(cacheable=true)
    public static List<Fine__c> getFinesByUser() {
        List<Fine__c> finesList = new List<Fine__c>();

        try {
            // Get the currently logged-in user
            String loggedInUserId = UserInfo.getUserId();

            if (String.isBlank(loggedInUserId)) {
                return finesList; // Return empty list instead of throwing an error
            }

            // Fetch all transactions associated with the logged-in user
            List<Library_Transaction__c> transactions = [
                SELECT Id
                FROM Library_Transaction__c
                WHERE Library_Member__r.User__c = :loggedInUserId
            ];

            if (transactions.isEmpty()) {
                return finesList;
            }

            // Fetch fines related to these transactions
            finesList = [
                SELECT Id, Library_Transaction__c, Library_Transaction__r.Name, Fine_Amount__c, Fine_Status__c, Fine_Paid_Date__c
                FROM Fine__c
                WHERE Library_Transaction__c IN :transactions
            ];

        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while fetching fines');
        }

        return finesList;
    }
}
