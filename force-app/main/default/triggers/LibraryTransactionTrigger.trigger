trigger LibraryTransactionTrigger on Library_Transaction__c (before insert, before update) {
    List<Fine__c> finesToInsert = new List<Fine__c>();

    for (Library_Transaction__c txn : Trigger.new) { // Changed 'transaction' to 'txn'
        if (txn.Return_Date__c != null) {
            if (txn.Due_Date__c != null && txn.Return_Date__c > txn.Due_Date__c) {
                // Book returned late: Change status to "Returned" and generate a fine
                txn.Status__c = 'Returned';

                Fine__c fine = new Fine__c();
                fine.Library_Transaction__c = txn.Id;
                fine.User__c = txn.Library_Member__c;
                fine.Fine_Amount__c = LibraryTransactionHelper.calculateFine(txn.Due_Date__c, txn.Return_Date__c);
                fine.Fine_Status__c = 'Unpaid';

                finesToInsert.add(fine);
            } else {
                // Book returned on time: Just update status to "Returned"
                txn.Status__c = 'Returned';
            }
        } else if (txn.Due_Date__c != null && txn.Due_Date__c < System.today()) {
            // Book is overdue (past due date and not returned)
            txn.Status__c = 'Overdue';
        }
    }

    if (!finesToInsert.isEmpty()) {
        insert finesToInsert;
    }
}
