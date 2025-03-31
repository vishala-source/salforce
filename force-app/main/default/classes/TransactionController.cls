public with sharing class TransactionController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getTransactions() {
        List<Map<String, Object>> transactionList = new List<Map<String, Object>>();
        Id currentUserId = UserInfo.getUserId(); // Get the logged-in User ID

        for (Library_Transaction__c txn : [
            SELECT Id, Name, 
                   Book__c, Book__r.Book_Name__c,  
                   User__c, 
                   Issue_Date__c, Due_Date__c, Return_Date__c 
            FROM Library_Transaction__c 
            WHERE User__c = :currentUserId // Filter for logged-in user
        ]) {
            Map<String, Object> transactionMap = new Map<String, Object>();
            transactionMap.put('Id', txn.Id);
            transactionMap.put('Name', txn.Name);
            transactionMap.put('BookId', txn.Book__c);
            transactionMap.put('BookName', (txn.Book__r != null) ? txn.Book__r.Book_Name__c : 'N/A');
            transactionMap.put('Issue_Date__c', txn.Issue_Date__c);
            transactionMap.put('Due_Date__c', txn.Due_Date__c);
            transactionMap.put('Return_Date__c', txn.Return_Date__c);

            transactionList.add(transactionMap);
        }
        return transactionList;
    }
}
