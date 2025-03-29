trigger EnrollStudentTrigger on Student__c (before insert) {
    for (Student__c student : Trigger.new) {
        if (student.Course__c == null) { 
            student.Course__c = 'COURSE_ID_HERE'; // Replace with actual Course ID
        }
    }
}