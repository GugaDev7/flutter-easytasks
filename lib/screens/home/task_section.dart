import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../widgets/task_list_tile.dart';

class TaskSection extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final void Function(Task) onToggle;
  final void Function(Task) onDelete;
  final void Function(Task) onTap;

  const TaskSection({
    super.key,
    required this.title,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        ),
        ...tasks
            .map((task) => TaskListTile(task: task, onToggle: onToggle, onDelete: onDelete, onTap: () => onTap(task)))
            .toList(),
      ],
    );
  }
}
