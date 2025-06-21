/// Enum to define different categories for To-Do items.
enum TodoCategory {
  personal,
  work,
  study,
  health,
  shopping,
  finance,
  other,
}

/// Extension on TodoCategory to provide a user-friendly string representation.
extension TodoCategoryExtension on TodoCategory {
  String get name {
    switch (this) {
      case TodoCategory.personal:
        return 'Personal';
      case TodoCategory.work:
        return 'Work';
      case TodoCategory.study:
        return 'Study';
      case TodoCategory.health:
        return 'Health';
      case TodoCategory.shopping:
        return 'Shopping';
      case TodoCategory.finance:
        return 'Finance';
      case TodoCategory.other:
        return 'Other';
    }
  }
}

/// A data model representing a single To-Do item.
class Todo {
  final String id;
  String title;
  String description;
  DateTime dueDate;
  TodoCategory category;
  bool isCompleted;

  /// Constructor for creating a new To-Do item.
  Todo({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.category = TodoCategory.other,
    this.isCompleted = false,
  });

  /// Creates a copy of the current To-Do item with updated values.
  /// This is useful for immutability and state updates in Providers.
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TodoCategory? category,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
