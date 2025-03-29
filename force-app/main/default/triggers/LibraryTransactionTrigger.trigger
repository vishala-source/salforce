trigger LibraryTransactionTrigger on Library_Transaction__c (before insert, before update) {
    for (Library_Transaction__c txn : Trigger.new) {
        if (txn.Issue_Date__c != null && txn.Due_Date__c != null) {
            if (txn.Return_Date__c == null && txn.Due_Date__c < System.today()) {
                txn.Status__c = 'Overdue';
            } else if (txn.Return_Date__c != null) {
                txn.Status__c = 'Returned';
            } else {
                txn.Status__c = 'Borrowed';
            }
        }
    }
}
