import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/models/todo.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/widgets/reusable_widgets.dart'; // Import CustomAppBar

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    // Responsive layout for statistics
    return Scaffold(
      appBar: const CustomAppBar(title: 'To-Do Statistics'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Summary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              _buildOverallSummaryCard(context, todoProvider),
              const SizedBox(height: 20),

              Text(
                'Category-wise Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              _buildCategorySummary(context, todoProvider),
              const SizedBox(height: 20),

              Text(
                'Weekly To-Dos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              _buildWeeklySummary(context, todoProvider),
              const SizedBox(height: 20),

              Text(
                'Monthly To-Dos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              _buildMonthlySummary(context, todoProvider),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build overall summary card
  Widget _buildOverallSummaryCard(BuildContext context, TodoProvider todoProvider) {
    final totalTodos = todoProvider.todos.length;
    final completedTodos = todoProvider.todos.where((todo) => todo.isCompleted).length;
    final pendingTodos = totalTodos - completedTodos;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(context, 'Total', totalTodos, Icons.checklist),
            _buildSummaryItem(context, 'Completed', completedTodos, Icons.check_circle_outline, color: Colors.green),
            _buildSummaryItem(context, 'Pending', pendingTodos, Icons.pending_actions, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  // Helper to build individual summary items within a card
  Widget _buildSummaryItem(BuildContext context, String title, int count, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color ?? Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Helper to build category-wise summary
  Widget _buildCategorySummary(BuildContext context, TodoProvider todoProvider) {
    final categorySummary = todoProvider.categoryCompletionSummary;

    if (categorySummary.isEmpty || todoProvider.todos.isEmpty) {
      return const Text('No categories found or no todos yet.');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2; // Responsive grid
        return GridView.builder(
          shrinkWrap: true, // Important for nested scroll views
          physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5, // Adjust aspect ratio as needed
          ),
          itemCount: TodoCategory.values.length,
          itemBuilder: (context, index) {
            final category = TodoCategory.values[index];
            final summary = categorySummary[category] ?? {'completed': 0, 'pending': 0};
            final completed = summary['completed']!;
            final pending = summary['pending']!;
            final total = completed + pending;

            if (total == 0) return const SizedBox.shrink(); // Hide empty categories

            return Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text('Total: $total', style: Theme.of(context).textTheme.bodyMedium),
                    Text('Completed: $completed', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green)),
                    Text('Pending: $pending', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.orange)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper to build weekly summary
  Widget _buildWeeklySummary(BuildContext context, TodoProvider todoProvider) {
    final todosByWeek = todoProvider.todosByWeek;

    if (todosByWeek.isEmpty) {
      return const Text('No weekly To-Dos found.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: todosByWeek.entries.map((entry) {
        final week = entry.key;
        final todos = entry.value;
        final completedCount = todos.where((todo) => todo.isCompleted).length;
        final pendingCount = todos.length - completedCount;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionTile(
            title: Text(week, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text('Total: ${todos.length} | Completed: $completedCount | Pending: $pendingCount'),
            children: todos.map((todo) => ListTile(
              title: Text(todo.title, style: TextStyle(decoration: todo.isCompleted ? TextDecoration.lineThrough : null)),
              subtitle: Text('${todo.category.name} - ${DateFormat.yMMMd().format(todo.dueDate)}'),
              trailing: Icon(todo.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: todo.isCompleted ? Colors.green : Colors.grey),
            )).toList(),
          ),
        );
      }).toList(),
    );
  }

  // Helper to build monthly summary
  Widget _buildMonthlySummary(BuildContext context, TodoProvider todoProvider) {
    final todosByMonth = todoProvider.todosByMonth;

    if (todosByMonth.isEmpty) {
      return const Text('No monthly To-Dos found.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: todosByMonth.entries.map((entry) {
        final month = entry.key;
        final todos = entry.value;
        final completedCount = todos.where((todo) => todo.isCompleted).length;
        final pendingCount = todos.length - completedCount;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionTile(
            title: Text(month, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text('Total: ${todos.length} | Completed: $completedCount | Pending: $pendingCount'),
            children: todos.map((todo) => ListTile(
              title: Text(todo.title, style: TextStyle(decoration: todo.isCompleted ? TextDecoration.lineThrough : null)),
              subtitle: Text('${todo.category.name} - ${DateFormat.yMMMd().format(todo.dueDate)}'),
              trailing: Icon(todo.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: todo.isCompleted ? Colors.green : Colors.grey),
            )).toList(),
          ),
        );
      }).toList(),
    );
  }
}
