/// Utility class for common date operations.
class DateUtil {
  /// Returns the first day of the week for a given [date].
  /// Assumes week starts on Sunday (weekday 7 or 0 in DateTime).
  static DateTime findFirstDayOfWeek(DateTime date) {
    // Make sure to zero out time components for consistent date comparisons
    final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    return normalizedDate.subtract(Duration(days: normalizedDate.weekday % 7));
  }

  /// Returns the first day of the month for a given [date].
  static DateTime findFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Returns the last day of the month for a given [date].
  static DateTime findLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0); // Day 0 of next month is last day of current
  }

  /// Checks if two [DateTime] objects represent the same day.
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
