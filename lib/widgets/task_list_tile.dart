import 'package:flutter/material.dart';
import '../models/task.dart';

/// Widget personalizado para exibir uma tarefa em formato de ListTile
class TaskListTile extends StatelessWidget {
  final Task task; // Tarefa a ser exibida
  final Function(Task) onToggle; // Callback para alternar status
  final Function(Task) onDelete; // Callback para exclusão

  const TaskListTile({super.key, required this.task, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0), // Borda arredondada
      ),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
                task.isCompleted
                    ? TextDecoration
                        .lineThrough // Risca texto se concluída
                    : null,
            color:
                task.isCompleted
                    ? Colors
                        .grey // Texto cinza para concluídas
                    : Colors.black,
          ),
        ),
        subtitle: Text('Prioridade: ${task.priority}'), // Exibe prioridade
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(task), // Chama callback ao alterar
        ),
        onLongPress: () => onDelete(task), // Exclui com pressão longa
      ),
    );
  }
}
