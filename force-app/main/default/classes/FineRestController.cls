public without sharing class FineRestController {
    
    @AuraEnabled(cacheable=true)
    public static List<Fine__c> getFinesByUser() {
        List<Fine__c> finesList = new List<Fine__c>();

        try {
            // Get the currently logged-in user ID
            Id loggedInUserId = UserInfo.getUserId(); 

            if (loggedInUserId == null) {
                return finesList; // Return empty list if no user is found
            }

            // Fetch Library Transactions linked to this User
            List<Library_Transaction__c> transactions = [
                SELECT Id FROM Library_Transaction__c WHERE User__c = :loggedInUserId
            ];

            if (transactions.isEmpty()) {
                return finesList; // No transactions found
            }

            // Fetch fines related to these transactions
            finesList = [
                SELECT Id, Name, Fine_Amount__c, Fine_Status__c, Fine_Paid_Date__c, 
                       Library_Transaction__c, Library_Transaction__r.Name
                FROM Fine__c
                WHERE Library_Transaction__c IN :transactions
            ];

            // Fines fatched sucussfully

        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while fetching fines');
        }

        return finesList;
    }
}
