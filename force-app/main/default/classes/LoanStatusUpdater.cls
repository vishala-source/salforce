public without sharing class LoanStatusUpdater {
    
    public static void updateOverdueLoans() {
        try {
            // Fetch overdue transactions where return date is not set and due date has passed
            List<Library_Transaction__c> overdueTransactions = [
                SELECT Id, Due_Date__c, Status__c 
                FROM Library_Transaction__c 
                WHERE Due_Date__c < TODAY AND Status__c != 'Returned'
            ];
            // Loan status update 

            if (overdueTransactions.isEmpty()) {
                System.debug('No overdue transactions found.');
                return;
            }
            // transaction for the libary mamber

            for (Library_Transaction__c trans : overdueTransactions) { // Changed variable name
                trans.Status__c = 'Overdue';
            }

            update overdueTransactions;
            System.debug('Updated overdue transactions successfully.');

        } catch (Exception e) {
            System.debug('Error updating overdue loans: ' + e.getMessage());
        }
    }
}
