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

            // ✅ Fetch the Library Member associated with the logged-in user
            List<Library_Member__c> members = [
                SELECT Id FROM Library_Member__c WHERE User__c = :loggedInUserId
            ];

            if (members.isEmpty()) {
                return transactions; // No transactions if no Library Member found
            }

            // ✅ Fetch Library Transactions linked to this Library Member
            transactions = [
                SELECT Id, Name, Status__c, Issue_Date__c, Due_Date__c, Return_Date__c,
                       Book__c, Book__r.Book_Name__c,
                       (SELECT Fine_Amount__c, Fine_Status__c FROM Fines__r) // Fetch fine details
                FROM Library_Transaction__c
                WHERE Library_Member__c IN :members
            ];

            System.debug('=== Retrieved Transactions: ' + transactions);

        } catch (Exception e) {
            System.debug('=== ERROR: ' + e.getMessage());
            throw new AuraHandledException('Error fetching transactions: ' + e.getMessage());
        }

        return transactions;
    }
}
