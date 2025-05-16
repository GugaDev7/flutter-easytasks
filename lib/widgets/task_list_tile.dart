import 'package:flutter/material.dart';
import '../models/task.dart';

/// Widget que representa um item de lista de tarefas.
class TaskListTile extends StatelessWidget {
  /// Tarefa a ser exibida no item da lista.
  final Task task;

  /// Função chamada ao alternar o estado da tarefa (ativa/concluída).
  final Function(Task) onToggle;

  /// Função chamada ao deletar a tarefa.
  final Function(Task) onDelete;

  /// Função chamada ao tocar na tarefa, permitindo ações adicionais (ex: abrir detalhes).
  final VoidCallback? onTap;

  /// Construtor do TaskListTile.
  const TaskListTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  /// Constrói o widget TaskListTile.
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
