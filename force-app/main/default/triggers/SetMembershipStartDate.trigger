trigger SetMembershipStartDate on Library_Member__c (before insert) {
    for (Library_Member__c member : Trigger.new) {
        if (member.Membership_Start_Date__c == null) {
            member.Membership_Start_Date__c = Date.today();
        }
    }
}
