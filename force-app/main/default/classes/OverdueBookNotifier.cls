global class OverdueBookNotifier implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Map to store emails per member
        Map<String, List<String>> memberBooksMap = new Map<String, List<String>>();

        // Get overdue transactions where the book is not returned
        List<Library_Transaction__c> overdueBooks = [
            SELECT Library_Member__r.Email_Address__c, 
                   Library_Member__r.Member_Name__c, 
                   Book__r.Name, Due_Date__c 
            FROM Library_Transaction__c
            WHERE Due_Date__c < TODAY AND Return_Date__c = NULL
        ];

        for (Library_Transaction__c bookTransaction : overdueBooks) {
            if (bookTransaction.Library_Member__r.Email_Address__c != null) {
                String email = bookTransaction.Library_Member__r.Email_Address__c;
                String bookDetails = '📖 "' + bookTransaction.Book__r.Name + '" (Due: ' + bookTransaction.Due_Date__c + ')';

                if (!memberBooksMap.containsKey(email)) {
                    memberBooksMap.put(email, new List<String>());
                }
                memberBooksMap.get(email).add(bookDetails);
            }
        }

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (String email : memberBooksMap.keySet()) {
            List<String> books = memberBooksMap.get(email);
            String body = 'Dear Library Member,\n\n' +
                          'You have the following overdue books:\n\n' +
                          String.join(books, '\n') +
                          '\n\nPlease return them as soon as possible to avoid penalties.\n\n' +
                          'Thank you,\nLibrary Management System';

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{email});
            mail.setSubject('Library Overdue Book Reminder 📚');
            mail.setPlainTextBody(body);

            emails.add(mail);
        }

        // Send emails in bulk (avoid hitting limit)
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}
