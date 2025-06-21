import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/models/todo.dart';
import 'package:todo_app/utils/constants.dart';

/// A custom AppBar for consistent look and feel across the app.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// A reusable button widget with consistent styling.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget to display a single To-Do item.
class TodoListItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = todo.isCompleted;

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onToggle, // Tap anywhere on the card to toggle status
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      todo.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? theme.disabledColor : theme.textTheme.titleMedium?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Checkbox(
                    value: isCompleted,
                    onChanged: (bool? value) => onToggle(),
                    activeColor: theme.primaryColor,
                  ),
                ],
              ),
              if (todo.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    todo.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isCompleted ? theme.disabledColor : theme.textTheme.bodyMedium?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    context,
                    Icons.calendar_today,
                    DateFormat.yMMMd().format(todo.dueDate),
                    isCompleted,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    context,
                    Icons.category,
                    todo.category.name,
                    isCompleted,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.edit, color: theme.colorScheme.secondary),
                    onPressed: onEdit,
                    tooltip: 'Edit To-Do',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: theme.colorScheme.error),
                    onPressed: onDelete,
                    tooltip: 'Delete To-Do',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      BuildContext context, IconData icon, String text, bool isCompleted) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(icon, size: 18, color: isCompleted ? theme.disabledColor : theme.primaryColor),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isCompleted ? theme.disabledColor : theme.textTheme.bodySmall?.color,
        ),
      ),
      backgroundColor: isCompleted ? theme.disabledColor.withOpacity(0.1) : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isCompleted ? theme.disabledColor : theme.primaryColor.withOpacity(0.5)),
      ),
    );
  }
}

/// A custom widget for picking dates.
class DatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final String labelText;

  const DatePickerField({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    this.labelText = 'Select Date',
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: _selectedDate != null ? DateFormat.yMMMd().format(_selectedDate!) : '',
    );
  }

  @override
  void didUpdateWidget(covariant DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _selectedDate = widget.initialDate;
      _controller.text = _selectedDate != null ? DateFormat.yMMMd().format(_selectedDate!) : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat.yMMMd().format(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          readOnly: true, // Prevent direct text input
        ),
      ),
    );
  }
}

/// A custom dropdown for selecting To-Do categories.
class CategoryDropdown extends StatelessWidget {
  final TodoCategory selectedCategory;
  final ValueChanged<TodoCategory?> onChanged;
  final String labelText;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
    this.labelText = 'Category',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TodoCategory>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: AppConstants.allCategories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Row(
            children: [
              Icon(_getCategoryIcon(category), size: 20),
              const SizedBox(width: 10),
              Text(category.name),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  IconData _getCategoryIcon(TodoCategory category) {
    switch (category) {
      case TodoCategory.personal: return Icons.person;
      case TodoCategory.work: return Icons.business_center;
      case TodoCategory.study: return Icons.school;
      case TodoCategory.health: return Icons.medical_services;
      case TodoCategory.shopping: return Icons.shopping_cart;
      case TodoCategory.finance: return Icons.account_balance;
      case TodoCategory.other: return Icons.more_horiz;
    }
  }
}
