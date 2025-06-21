import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/widgets/reusable_widgets.dart'; // Import reusable widgets

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the TodoProvider to react to changes in the To-Do list or filter.
    final todoProvider = Provider.of<TodoProvider>(context);
    final filteredTodos = todoProvider.filteredTodos;

    // Use MediaQuery to get screen size for responsiveness.
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My To-Do List',
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            tooltip: 'View Statistics',
            onPressed: () {
              Navigator.pushNamed(context, '/statistics');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter buttons at the top
          _buildFilterBar(context, todoProvider),
          Expanded(
            child: filteredTodos.isEmpty
                ? Center(
              child: Text(
                'No To-Dos found. Add one!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
                : LayoutBuilder(
              builder: (context, constraints) {
                // Adjust grid/list layout based on screen width
                if (constraints.maxWidth > 600) {
                  // For wider screens, show a grid
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns for tablets/desktops
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 3 / 2, // Adjust aspect ratio as needed
                    ),
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return TodoListItem(
                        todo: todo,
                        onToggle: () => todoProvider.toggleTodoStatus(todo.id),
                        onEdit: () {
                          Navigator.pushNamed(
                            context,
                            '/add_edit_todo',
                            arguments: todo, // Pass the To-Do object for editing
                          );
                        },
                        onDelete: () => _confirmDelete(context, todoProvider, todo.id),
                      );
                    },
                  );
                } else {
                  // For narrower screens (phones), show a list
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return TodoListItem(
                        todo: todo,
                        onToggle: () => todoProvider.toggleTodoStatus(todo.id),
                        onEdit: () {
                          Navigator.pushNamed(
                            context,
                            '/add_edit_todo',
                            arguments: todo,
                          );
                        },
                        onDelete: () => _confirmDelete(context, todoProvider, todo.id),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add/edit screen without arguments for adding a new To-Do.
          Navigator.pushNamed(context, '/add_edit_todo');
        },
        tooltip: 'Add New To-Do',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Builds the filter bar with buttons for 'All', 'Pending', 'Completed'.
  Widget _buildFilterBar(BuildContext context, TodoProvider todoProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: TodoFilter.values.map((filter) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () => todoProvider.setFilter(filter),
                style: ElevatedButton.styleFrom(
                  foregroundColor: todoProvider.currentFilter == filter
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                  backgroundColor: todoProvider.currentFilter == filter
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  _getFilterText(filter),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Helper function to get display text for each filter.
  String _getFilterText(TodoFilter filter) {
    switch (filter) {
      case TodoFilter.all:
        return 'All';
      case TodoFilter.completed:
        return 'Completed';
      case TodoFilter.pending:
        return 'Pending';
    }
  }

  // Shows a confirmation dialog before deleting a To-Do.
  void _confirmDelete(BuildContext context, TodoProvider todoProvider, String todoId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this To-Do?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                todoProvider.deleteTodo(todoId);
                Navigator.of(dialogContext).pop(); // Dismiss dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('To-Do deleted successfully!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
