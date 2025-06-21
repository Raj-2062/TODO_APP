import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; // Add uuid package to pubspec.yaml for unique IDs

import 'package:todo_app/models/todo.dart';
import 'package:todo_app/utils/date_utils.dart'; // Import custom date utility

/// Enum to define different filtering options for the To-Do list.
enum TodoFilter {
  all,
  completed,
  pending,
}

/// A [ChangeNotifier] that manages the list of To-Do items and their state.
class TodoProvider with ChangeNotifier {
  // Use a List to store To-Do items. In a real app, this would come from a database.
  final List<Todo> _todos = [];

  // Keep track of the currently selected filter.
  TodoFilter _currentFilter = TodoFilter.all;

  // UUID generator for unique To-Do IDs.
  final Uuid _uuid = const Uuid();

  /// Returns an unmodifiable list of all To-Do items.
  List<Todo> get todos => List.unmodifiable(_todos);

  /// Returns the currently active filter.
  TodoFilter get currentFilter => _currentFilter;

  /// Filtered list of To-Do items based on the current filter.
  List<Todo> get filteredTodos {
    switch (_currentFilter) {
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.pending:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.all:
      default:
        return _todos;
    }
  }

  /// Sets the current filter and notifies listeners.
  void setFilter(TodoFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  /// Adds a new To-Do item to the list.
  void addTodo(Todo todo) {
    _todos.add(todo.copyWith(id: _uuid.v4())); // Assign a unique ID
    notifyListeners();
  }

  /// Updates an existing To-Do item.
  void updateTodo(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  /// Toggles the completion status of a To-Do item.
  void toggleTodoStatus(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      notifyListeners();
    }
  }

  /// Deletes a To-Do item from the list.
  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  /// Clears all To-Do items (for testing/demo purposes).
  void clearAllTodos() {
    _todos.clear();
    notifyListeners();
  }

  /// ********************************************
  /// Methods for statistics and grouping
  /// ********************************************

  /// Groups To-Do items by category.
  Map<TodoCategory, List<Todo>> get todosByCategory {
    final Map<TodoCategory, List<Todo>> grouped = {
      for (var category in TodoCategory.values) category: []
    };
    for (var todo in _todos) {
      grouped[todo.category]?.add(todo);
    }
    return grouped;
  }

  /// Gets a summary of completed vs. pending tasks per category.
  Map<TodoCategory, Map<String, int>> get categoryCompletionSummary {
    final Map<TodoCategory, Map<String, int>> summary = {};
    for (var category in TodoCategory.values) {
      final categoryTodos = _todos.where((todo) => todo.category == category);
      final completed = categoryTodos.where((todo) => todo.isCompleted).length;
      final pending = categoryTodos.where((todo) => !todo.isCompleted).length;
      summary[category] = {'completed': completed, 'pending': pending};
    }
    return summary;
  }

  /// Groups To-Do items by week (starting from Sunday).
  /// Returns a map where keys are week identifiers (e.g., "Week 24, 2025")
  /// and values are lists of To-Do items for that week.
  Map<String, List<Todo>> get todosByWeek {
    final Map<String, List<Todo>> grouped = {};
    final now = DateTime.now();

    for (var todo in _todos) {
      final weekStart = DateUtil.findFirstDayOfWeek(todo.dueDate);
      final weekEnd = weekStart.add(const Duration(days: 6));
      final weekKey =
          '${DateFormat.MMMEd().format(weekStart)} - ${DateFormat.MMMEd().format(weekEnd)}';
      grouped.putIfAbsent(weekKey, () => []).add(todo);
    }
    // Sort by date to make sure weeks are ordered chronologically.
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat.MMMEd().parse(a.split(' - ')[0]);
        final dateB = DateFormat.MMMEd().parse(b.split(' - ')[0]);
        return dateA.compareTo(dateB);
      });

    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  /// Groups To-Do items by month.
  /// Returns a map where keys are month identifiers (e.g., "June 2025")
  /// and values are lists of To-Do items for that month.
  Map<String, List<Todo>> get todosByMonth {
    final Map<String, List<Todo>> grouped = {};
    for (var todo in _todos) {
      final monthKey = DateFormat.yMMMM().format(todo.dueDate);
      grouped.putIfAbsent(monthKey, () => []).add(todo);
    }
    // Sort by date to make sure months are ordered chronologically.
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat.yMMMM().parse(a);
        final dateB = DateFormat.yMMMM().parse(b);
        return dateA.compareTo(dateB);
      });

    return {for (var key in sortedKeys) key: grouped[key]!};
  }
}
