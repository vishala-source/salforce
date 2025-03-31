trigger LoanStatusUpdateTrigger on Library_Transaction__c (after update) {
    // Get the updated transaction record
    Library_Transaction__c libraryTransaction = Trigger.new[0];  
    Library_Transaction__c oldLibraryTransaction = Trigger.oldMap.get(libraryTransaction.Id);
    
    // Check if Loan Status changed to 'Returned'
    if (libraryTransaction.Status__c == 'Returned' && oldLibraryTransaction.Status__c != 'Returned') {
        try {
            System.debug('Transaction ID: ' + libraryTransaction.Id + ' status changed to Returned.');

            // Update the Book's Availability Status
            Book__c book = [SELECT Id, Status__c FROM Book__c WHERE Id = :libraryTransaction.Book__c LIMIT 1];
            book.Status__c = 'Available';
            update book;
            
            System.debug('Book ID: ' + book.Id + ' updated to Available.');
            
        } catch (Exception e) {
            System.debug('Error in LoanStatusUpdateTrigger: ' + e.getMessage());
        }
    }
}
