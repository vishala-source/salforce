global class LibraryTransactionReminderScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        System.debug('Entered LibraryTransactionReminderScheduler.');

        // Query Library Transactions that are due tomorrow
        List<Library_Transaction__c> transactionsToRemind = [
            SELECT Id, Name, Due_Date__c, Library_Member__r.Email_Address__c
            FROM Library_Transaction__c
            WHERE Due_Date__c = :Date.today().addDays(1)
        ];
        // comment added

        if (!transactionsToRemind.isEmpty()) {
            List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

            for (Library_Transaction__c libraryTransaction : transactionsToRemind) { // Fixed variable name
                String memberEmail = libraryTransaction.Library_Member__r.Email_Address__c;

                if (String.isNotBlank(memberEmail)) { // Ensure email exists before sending
                    // Creating email content
                    String subject = 'Reminder: Your Library Book is Due Tomorrow';
                    String body = 'Dear Member,\n\n'
                                + 'This is a reminder that your borrowed book transaction with ID ' + libraryTransaction.Name + ' is due tomorrow, '
                                + libraryTransaction.Due_Date__c.format() + '.\n\n'
                                + 'Please return the book on time to avoid fines.\n\n'
                                + 'Thank you for using our library service.\n\n'
                                + 'Best regards,\n'
                                + 'Library Management Team';

                    // Creating and sending the email
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] { memberEmail });
                    email.setSubject(subject);
                    email.setPlainTextBody(body);
                    emailMessages.add(email);
                }
            }

            // Sending all emails if there are valid recipients
            if (!emailMessages.isEmpty()) {
                Messaging.sendEmail(emailMessages);
                System.debug('Reminder emails sent successfully.');
            } else {
                System.debug('No valid email addresses found for transactions.');
            }
        } else {
            System.debug('No library transactions found that are due tomorrow.');
        }
    }
}
