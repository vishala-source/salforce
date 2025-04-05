public without sharing class LibraryLoginController {
    @AuraEnabled(cacheable=false) 
    public static String verifyMemberLogin(String email, String password) {
        try {
            System.debug('LOGIN ATTEMPT: Email = ' + email);

            List<Library_Member__c> members = [
                SELECT Id, Email_Address__c, Password__c, Membership_Expiry_Date__c, Status__c
                FROM Library_Member__c 
                WHERE Email_Address__c = :email 
                LIMIT 1
            ];
            // Login credentail

            if (members.isEmpty()) {
                System.debug('LOGIN FAILED: No user found.');
                return 'INVALID';
            }

            Library_Member__c member = members[0];
            System.debug('MEMBER FOUND: ' + member);

            if (member.Status__c != 'Active') {
                System.debug('LOGIN FAILED: Member is inactive.');
                return 'INACTIVE';
            }

            if (member.Password__c != password) {
                System.debug('LOGIN FAILED: Incorrect password.');
                return 'INVALID';
            }

            if (member.Membership_Expiry_Date__c < Date.today()) {
                System.debug('LOGIN FAILED: Membership expired.');
                return 'EXPIRED';
            }

            System.debug('LOGIN SUCCESS');
            return 'SUCCESS';

            // Login Successfully

        } catch (Exception e) {
            System.debug('ERROR: ' + e.getMessage());
            return 'ERROR: ' + e.getMessage();
        }
    }
}
// end of the code