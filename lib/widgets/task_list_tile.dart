import 'package:flutter/material.dart';
import '../models/task.dart';

/// Widget que representa um item de tarefa na lista de tarefas.
class TaskListTile extends StatelessWidget {
  /// Tarefa a ser exibida, contendo título e estado de conclusão.
  final Task task;

  /// Função chamada quando a tarefa é marcada como concluída ou não concluída.
  final Function(Task) onToggle;

  /// Função chamada para deletar a tarefa.
  final Function(Task) onDelete;

  /// Função chamada quando a tarefa é tocada.
  final VoidCallback? onTap;

  /// Função chamada quando a tarefa é pressionada longamente.
  final VoidCallback? onLongPress;

  /// Indica se o modo de seleção está ativo.
  final bool selectionMode;

  /// Indica se a tarefa está selecionada.
  final bool isSelected;

  /// Construtor do widget TaskListTile.
  const TaskListTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.onTap,
    this.onLongPress,
    required this.selectionMode,
    required this.isSelected,
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
        trailing:
            /// Exibe o botão de deletar apenas se não estiver no modo de seleção.
            selectionMode ? null : Checkbox(value: task.isCompleted, onChanged: (_) => onToggle(task)),
        onLongPress: onLongPress,
        onTap: onTap,
        leading: selectionMode ? Checkbox(value: isSelected, onChanged: (_) => onTap?.call()) : null,
      ),
    );
  }
}
