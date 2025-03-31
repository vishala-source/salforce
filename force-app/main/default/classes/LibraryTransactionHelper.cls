public class LibraryTransactionHelper {
    public static Decimal calculateFine(Date dueDate, Date returnDate) {
        Integer daysLate = returnDate.daysBetween(dueDate);
        Decimal fineAmount = daysLate * 5; // Example: $5 per day late
        return fineAmount;
    }
}
