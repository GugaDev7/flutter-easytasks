import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';
import 'task_section.dart';
import '../../models/task.dart';

/// Widget que representa o corpo da tela inicial, exibindo as tarefas ativas e concluídas.
class HomeBody extends StatelessWidget {
  /// Nome da lista de tarefas atualmente selecionada.
  final String? selectedList;

  /// Lista de tarefas ativas.
  final List<Task> activeTasks;

  /// Lista de tarefas concluídas.
  final List<Task> completedTasks;

  /// Função chamada ao alternar o estado de uma tarefa (ativa/concluída).
  final void Function(Task) onToggleTask;

  /// Função chamada ao deletar uma tarefa.
  final void Function(Task) onDeleteTask;

  /// Função chamada ao editar uma tarefa.
  final void Function(Task) onEditTask;

  /// Construtor do HomeBody.
  const HomeBody({
    super.key,
    required this.selectedList,
    required this.activeTasks,
    required this.completedTasks,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onEditTask,
  });

  /// Constrói o widget HomeBody.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child:
          selectedList == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Nenhuma lista selecionada',
                      style: TextStyle(fontSize: 18, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      child: const Text('Selecionar Lista'),
                    ),
                  ],
                ),
              )
              : ListView(
                children: [
                  if (activeTasks.isNotEmpty)
                    TaskSection(
                      title: 'Tarefas Ativas',
                      tasks: activeTasks,
                      onToggle: onToggleTask,
                      onDelete: onDeleteTask,
                      onTap: onEditTask,
                    ),
                  if (completedTasks.isNotEmpty)
                    TaskSection(
                      title: 'Tarefas Concluídas',
                      tasks: completedTasks,
                      onToggle: onToggleTask,
                      onDelete: onDeleteTask,
                      onTap: onEditTask,
                    ),
                ],
              ),
    );
  }
}
