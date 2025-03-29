trigger Assign_Course_To_Student on Student__c (before insert) {
    for (Student__c stu : Trigger.new) {
        if (stu.Course__c == null) {
            stu.Course__c = 'General Studies'; // Assign default course
        }
    }
}