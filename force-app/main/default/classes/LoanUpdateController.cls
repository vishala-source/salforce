public without sharing class LoanUpdateController {

    @AuraEnabled(cacheable=true)
    public static List<Library_Transaction__c> getTransactionsByUser() {
        List<Library_Transaction__c> transactions = new List<Library_Transaction__c>();

        try {
            // ✅ Get the currently logged-in User
            String loggedInUserId = UserInfo.getUserId();
            
            if (String.isBlank(loggedInUserId)) {
                throw new AuraHandledException('User not logged in');
            }

            System.debug('=== Logged-In User ID: ' + loggedInUserId);

            // ✅ Fetch transactions associated with the logged-in User
            transactions = [
                SELECT Id, Status__c, Issue_Date__c, Due_Date__c, Return_Date__c, 
                       Book__c, Book__r.Name  
                FROM Library_Transaction__c 
                WHERE User__c = :loggedInUserId
            ];
            // Loan is updated

            System.debug('=== Retrieved Transactions: ' + transactions);

        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            throw new AuraHandledException('Error fetching transactions: ' + e.getMessage());
        }

        return transactions;
    }
}
