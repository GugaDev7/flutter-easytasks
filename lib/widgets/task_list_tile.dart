import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  final Function(Task) onToggle;
  final Function(Task) onDelete;
  final VoidCallback? onTap;

  const TaskListTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        trailing: Checkbox(value: task.isCompleted, onChanged: (_) => onToggle(task)),
        onLongPress: () => onDelete(task),
        onTap: onTap,
      ),
    );
  }
}
