trigger SetReturnDateTrigger on Library_Transaction__c (before update) {
    for (Library_Transaction__c trans : Trigger.new) {  // Changed 'transaction' to 'trans'
        if (trans.Status__c == 'Returned' && trans.Return_Date__c == null) {
            trans.Return_Date__c = Date.today();
        }
    }
}
