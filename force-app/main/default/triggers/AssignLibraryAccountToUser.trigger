trigger AssignLibraryAccountToUser on User (after insert) { 
    // Id communityProfileId = '00egL000000v6lSQA'; // Community User Profile ID
    
    // User newUser = Trigger.new[0]; // Get the newly inserted user

    // if (newUser.ProfileId == communityProfileId) { // Ensure it's a Community User
    //     try {
    //         // Fetch the Membership Type from Library_Member__c
    //         Library_Member__c member = [
    //             SELECT Id, Membership_Type__c 
    //             FROM Library_Member__c 
    //             WHERE User__c = :newUser.Id
    //             LIMIT 1
    //         ];
            
    //         if (member != null) {
    //             // Determine the correct Library Account based on Membership Type
    //             String accountName = member.Membership_Type__c + ' Library Account';
                
    //             Account acc = [
    //                 SELECT Id FROM Account 
    //                 WHERE Name = :accountName 
    //                 LIMIT 1
    //             ];

    //             if (acc != null && newUser.ContactId != null) {
                    // Fetch the Contact associated with this User
    //                 Contact userContact = [
    //                     SELECT Id, AccountId 
    //                     FROM Contact 
    //                     WHERE Id = :newUser.ContactId 
    //                     LIMIT 1
    //                 ];
                    
    //                 if (userContact != null) {
    //                     userContact.AccountId = acc.Id; // Assign the correct Library Account
    //                     update userContact; // Update the Contact record
    //                 }
    //             }
    //         }
    //     } catch (Exception e) {
    //         System.debug('Error: ' + e.getMessage());
    //     }
    // }
}
