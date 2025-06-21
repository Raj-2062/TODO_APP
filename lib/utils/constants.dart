import 'package:todo_app/models/todo.dart'; // Import the TodoCategory enum

/// Utility class for application-wide constants.
class AppConstants {
  // List of all available To-Do categories.
  // This can be used for dropdowns or category selections.
  static const List<TodoCategory> allCategories = TodoCategory.values;
}

