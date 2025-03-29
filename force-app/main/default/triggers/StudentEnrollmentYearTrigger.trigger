trigger StudentEnrollmentYearTrigger on Student__c (before insert, before update) {
    // Get the current year
    Integer currentYear = System.today().year();
    
    // Loop through the Student records
    for (Student__c student : Trigger.new) {
        // Check if the Enrollment Year is blank or before the current year
        if (student.Enrollment_Year__c == null || student.Enrollment_Year__c < currentYear) {
            // Set the Enrollment Year to the current year if it's not provided
            student.Enrollment_Year__c = currentYear;
        }
    }
}