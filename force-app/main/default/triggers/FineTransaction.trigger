trigger LibraryTransactionTrigger on Library_Transaction__c (before insert, before update) {
    Decimal fineRatePerDay = 1.0; // Fine amount per overdue day
    
    for (Library_Transaction__c trans : Trigger.new) {
        if (trans.Return_Date__c != null && trans.Due_Date__c != null) {
            Integer overdueDays = trans.Due_Date__c.daysBetween(trans.Return_Date__c); // Correct order
            
            if (overdueDays > 0) {  // Only apply fine if overdue
                trans.Fine_Amount__c = (overdueDays * fineRatePerDay).setScale(2); // Ensure two decimal places
                
                // Check if payment has been made
                if (trans.Fine_Paid__c >= trans.Fine_Amount__c) {
                    trans.Fine_Status__c = 'Paid';
                } else {
                    trans.Fine_Status__c = 'Unpaid';
                }
            } else {
                trans.Fine_Amount__c = 0.00;
                trans.Fine_Status__c = null; // No fine needed
            }
        }
    }
}
