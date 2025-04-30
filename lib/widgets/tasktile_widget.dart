import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String task;
  final VoidCallback onDelete;

  const TaskTile({required this.task, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(task), trailing: IconButton(icon: Icon(Icons.delete), onPressed: onDelete));
  }
}
