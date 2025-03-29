public class Vishala {
    public static void updateEnrollmentYear(String studentId, Integer newEnrollmentYear) {
        Student__c student = [SELECT Id, Enrollment_Year__c FROM Student__c WHERE Id = :studentId LIMIT 1];
        student.Enrollment_Year__c = newEnrollmentYear;
        update student;
    }
}