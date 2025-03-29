public without sharing class FineRestController {
    
    @AuraEnabled(cacheable=true)
    public static List<Fine__c> getFinesByUser() {
        List<Fine__c> finesList = new List<Fine__c>();

        try {
            // Get the currently logged-in user's name
            String loggedInUserName = UserInfo.getName(); 

            if (String.isBlank(loggedInUserName)) {
                return finesList; // Return empty list instead of throwing an error
            }

            // Fetch the Library Member record associated with the logged-in user's name
            List<Library_Member__c> members = [
                SELECT Id FROM Library_Member__c WHERE Member_Name__c = :loggedInUserName
            ];

            if (members.isEmpty()) {
                return finesList; // No library member found
            }

            // Fetch Library Transactions linked to this Library Member
            List<Library_Transaction__c> transactions = [
                SELECT Id FROM Library_Transaction__c WHERE Library_Member__c IN :members
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

        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while fetching fines');
        }

        return finesList;
    }
}
