trigger UpdateBookAvailability on Library_Transaction__c (after insert, after update) {
    // Get the list of Book IDs from the transactions
    Set<Id> bookIds = new Set<Id>();

    for (Library_Transaction__c txn : Trigger.new) {
        if (txn.Book__c != null) {
            bookIds.add(txn.Book__c);
        }
    }

    // Fetch the Books that are referenced in the transactions
    List<Book__c> booksToUpdate = [SELECT Id, Available_Copies__c, Status__c FROM Book__c WHERE Id IN :bookIds];

    // Map to store the number of borrowed books per Book ID
    Map<Id, Integer> borrowedCounts = new Map<Id, Integer>();

    for (Library_Transaction__c txn : Trigger.new) {
        if (txn.Book__c != null) {
            if (!borrowedCounts.containsKey(txn.Book__c)) {
                borrowedCounts.put(txn.Book__c, 0);
            }
            borrowedCounts.put(txn.Book__c, borrowedCounts.get(txn.Book__c) + 1);
        }
    }

    // Update Available Copies and Status for each book
    for (Book__c book : booksToUpdate) {
        if (borrowedCounts.containsKey(book.Id)) {
            book.Available_Copies__c = book.Available_Copies__c - borrowedCounts.get(book.Id);
            
            // If Available Copies reach 0, set status as 'Unavailable'
            if (book.Available_Copies__c <= 0) {
                book.Available_Copies__c = 0; // Ensuring it doesn’t go negative
                book.Status__c = 'Unavailable';
            } else {
                book.Status__c = 'Available';
            }
        }
    }

    // Perform update operation
    update booksToUpdate;
}