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

            // Collect user IDs to fetch their email addresses
            Set<Id> userIds = new Set<Id>();
            for (Library_Transaction__c trans : overdueTransactions) {
                if (trans.User__c != null) {
                    userIds.add(trans.User__c);
                }
            }

            // Fetch user emails
            Map<Id, String> userEmails = new Map<Id, String>();
            for (User u : [SELECT Id, Email FROM User WHERE Id IN :userIds]) {
                userEmails.put(u.Id, u.Email);
            }

            // Prepare email messages
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (Library_Transaction__c trans : overdueTransactions) {
                if (userEmails.containsKey(trans.User__c)) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[]{ userEmails.get(trans.User__c) });
                    email.setSubject('Library Loan Overdue Reminder');
                    email.setPlainTextBody('Dear Library Member,\n\n' +
                        'This is a reminder that your book loan is overdue. Please return the book as soon as possible to avoid penalties.\n\n' +
                        'Due Date: ' + trans.Due_Date__c + '\n' +
                        'Status: ' + trans.Status__c + '\n\n' +
                        'Thank you,\nLibrary Management System');

                    emails.add(email);
                }
            }

            // Send emails
            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
                System.debug('✅ Overdue loan reminder emails sent successfully.');
            }

        } catch (Exception e) {
            System.debug('❌ Error sending overdue loan reminders: ' + e.getMessage());
        }
    }
}
