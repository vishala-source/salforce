trigger UpdateBookAvailabilityTrigger on Library_Transaction__c (after insert, after update) {
    for (Library_Transaction__c trans : Trigger.new) {
        if (trans.Status__c == 'Borrowed' || trans.Status__c == 'Overdue') {
            try {
                // Retrieve the associated book record
                Book__c book = [SELECT Id, Status__c FROM Book__c WHERE Id = :trans.Book__c LIMIT 1];

                // Log previous status
                System.debug('Book ID: ' + book.Id + ' | Previous Status: ' + book.Status__c);
                
                // Update book status to "Borrowed"
                book.Status__c = 'Borrowed';
                update book;

                // Log update confirmation
                System.debug('Book ID: ' + book.Id + ' | Updated Status: Borrowed');
            } catch (Exception e) {
                System.debug('Error updating book availability: ' + e.getMessage());
            }
        }
    }
}
