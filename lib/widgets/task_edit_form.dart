import 'package:flutter/material.dart';
import 'package:propaper/models/task.dart';

class TaskEditForm extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;
  final VoidCallback onCancel;

  const TaskEditForm({
    Key? key,
    this.task,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  _TaskEditFormState createState() => _TaskEditFormState();
}

class _TaskEditFormState extends State<TaskEditForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _timeController;
  late Priority _priority;
  late Category _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _timeController = TextEditingController(text: widget.task?.time ?? '');
    _priority = widget.task?.priority ?? Priority.medium;
    _category = widget.task?.category ?? Category.personal;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task == null ? 'Add New Task' : 'Edit Task',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Time field
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                hintText: 'e.g. 3:30 PM',
                prefixIcon: Icon(Icons.access_time),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a time';
                }
                // Could add more validation for time format
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Priority dropdown
            DropdownButtonFormField<Priority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                prefixIcon: Icon(Icons.flag),
              ),
              items: Priority.values.map((priority) {
                String label;
                IconData icon;
                Color color;
                
                switch (priority) {
                  case Priority.high:
                    label = 'High';
                    icon = Icons.arrow_upward;
                    color = Colors.red;
                    break;
                  case Priority.medium:
                    label = 'Medium';
                    icon = Icons.remove;
                    color = Colors.orange;
                    break;
                  case Priority.low:
                    label = 'Low';
                    icon = Icons.arrow_downward;
                    color = Colors.green;
                    break;
                }
                
                return DropdownMenuItem<Priority>(
                  value: priority,
                  child: Row(
                    children: [
                      Icon(icon, color: color, size: 18),
                      const SizedBox(width: 8),
                      Text(label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Category dropdown
            DropdownButtonFormField<Category>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
              items: Category.values.map((category) {
                String label;
                IconData icon;
                
                switch (category) {
                  case Category.work:
                    label = 'Work';
                    icon = Icons.work;
                    break;
                  case Category.personal:
                    label = 'Personal';
                    icon = Icons.person;
                    break;
                  case Category.health:
                    label = 'Health';
                    icon = Icons.favorite;
                    break;
                  case Category.education:
                    label = 'Education';
                    icon = Icons.school;
                    break;
                }
                
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(icon, size: 18),
                      const SizedBox(width: 8),
                      Text(label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            
            // Form buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final task = Task(
                          id: widget.task?.id,
                          title: _titleController.text,
                          time: _timeController.text,
                          priority: _priority,
                          category: _category,
                          completed: widget.task?.completed ?? false,
                        );
                        widget.onSave(task);
                      }
                    },
                    child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
