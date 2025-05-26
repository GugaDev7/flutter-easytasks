import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../widgets/task_list_tile.dart';

/// Widget que representa uma seção de tarefas, exibindo uma lista de tarefas ativas ou concluídas.
class TaskSection extends StatelessWidget {
  // Título da seção, como "Tarefas Ativas" ou "Tarefas Concluídas".
  final String title;

  // Lista de tarefas a serem exibidas nesta seção.
  final List<TaskModel> tasks;

  // Funções de callback para manipulação de tarefas.
  final void Function(TaskModel) onToggle;

  // Função para deletar uma tarefa.
  final void Function(TaskModel) onDelete;

  // Função chamada quando uma tarefa é tocada.
  final void Function(TaskModel) onTaskTap;

  // Função chamada quando uma tarefa é pressionada longamente.
  final void Function(TaskModel) onTaskLongPress;

  // Indica se o modo de seleção está ativo.
  final bool selectionMode;

  // Conjunto de IDs de tarefas selecionadas.
  final Set<String> selectedTaskIds;

  /// Construtor do widget TaskSection.
  const TaskSection({
    super.key,
    required this.title,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onTaskTap,
    required this.onTaskLongPress,
    required this.selectionMode,
    required this.selectedTaskIds,
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

        /// Lista de tarefas, exibindo cada tarefa como um item de lista.
        ...tasks.map(
          (task) => TaskListTile(
            task: task,
            onToggle: onToggle,
            onDelete: onDelete,
            onTap: () => onTaskTap(task),
            onLongPress: () => onTaskLongPress(task),
            selectionMode: selectionMode,
            isSelected: selectedTaskIds.contains(task.id),
          ),
        ),
      ],
    );
  }
}
