trigger ApplyFineOnOverdueReturn on Library_Transaction__c (after update) {
    List<Fine__c> finesToInsert = new List<Fine__c>();

    System.debug('Triggered ApplyFineOnOverdueReturn');

    for (Library_Transaction__c libraryTransaction : Trigger.new) {
        Library_Transaction__c oldTransaction = Trigger.oldMap.get(libraryTransaction.Id);

        // Ensure status changed from Overdue → Returned
        if (oldTransaction != null && oldTransaction.Status__c == 'Overdue' && libraryTransaction.Status__c == 'Returned') {
            System.debug('Processing fine for Transaction ID: ' + libraryTransaction.Id);

            // Ensure Return Date & Due Date are not null
            if (libraryTransaction.Return_Date__c != null && libraryTransaction.Due_Date__c != null) {
                Integer overdueDays = Math.max(0, libraryTransaction.Due_Date__c.daysBetween(libraryTransaction.Return_Date__c));
                System.debug('Overdue Days Calculated: ' + overdueDays);

                if (overdueDays > 0) {
                    Decimal fineAmount = overdueDays * 5; // $5 per day fine
                    System.debug('Fine Applied: ' + fineAmount + ' for ' + overdueDays + ' overdue days');

                    Fine__c fine = new Fine__c(
                        Library_Transaction__c = libraryTransaction.Id, 
                        User__c = libraryTransaction.Library_Member__c, 
                        Fine_Amount__c = fineAmount, 
                        Fine_Status__c = 'Unpaid'
                    );

                    finesToInsert.add(fine);
                }
            } else {
                System.debug('Skipping fine calculation due to null Return Date.');
            }
        }
    }

    // Insert fines outside the loop
    if (!finesToInsert.isEmpty()) {
        insert finesToInsert;
        System.debug('Fine records inserted successfully.');
    }
}
