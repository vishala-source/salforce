global class OverdueLoanReminderScheduler implements Schedulable {

    global void execute(SchedulableContext SC) {
        try {
            // Fetch overdue transactions and notify users
            List<Library_Transaction__c> overdueTransactions = [
                SELECT Id, Due_Date__c, Status__c, User__c 
                FROM Library_Transaction__c 
                WHERE Due_Date__c < TODAY AND Status__c = 'Overdue'
            ];

            if (overdueTransactions.isEmpty()) {
                System.debug('No overdue transactions to remind.');
                return;
            }

            for (Library_Transaction__c trans : overdueTransactions) { // Changed variable name
                if (trans.User__c != null) {
                    sendReminder(trans.User__c);
                }
            }

            System.debug('Sent reminders for overdue transactions.');

        } catch (Exception e) {
            System.debug('Error scheduling overdue loan reminders: ' + e.getMessage());
        }
    }

    private void sendReminder(Id userId) {
        // You can implement an email or notification system here
        System.debug('Sending reminder to User ID: ' + userId);
    }
}
