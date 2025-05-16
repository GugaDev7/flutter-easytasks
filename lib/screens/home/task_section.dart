import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../widgets/task_list_tile.dart';

/// Widget que representa uma seção de tarefas, exibindo uma lista de tarefas ativas ou concluídas.
class TaskSection extends StatelessWidget {
  /// Título da seção (ex: "Ativas" ou "Concluídas").
  final String title;

  /// Lista de tarefas a serem exibidas nesta seção.
  final List<Task> tasks;

  /// Função chamada ao alternar o estado de uma tarefa (ativa/concluída).
  final void Function(Task) onToggle;

  /// Função chamada ao deletar uma tarefa.
  final void Function(Task) onDelete;

  /// Função chamada ao tocar em uma tarefa, permitindo ações adicionais (ex: abrir detalhes).
  final void Function(Task) onTap;

  /// Construtor da seção de tarefas.
  const TaskSection({
    super.key,
    required this.title,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  });

  /// Constrói a seção de tarefas.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        ),
        ...tasks //'spread operator' => '...' serve para inserir todos os itens da lista (tasks).
            .map((task) => TaskListTile(task: task, onToggle: onToggle, onDelete: onDelete, onTap: () => onTap(task)))
            .toList(),
      ],
    );
  }
}
