import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';
import 'task_section.dart';
import '../../models/task.dart';

//// Widget que representa o corpo da tela inicial, exibindo as tarefas ativas e concluídas.
class HomeBody extends StatelessWidget {
  /// Lista selecionada atualmente, ou null se nenhuma lista estiver selecionada.
  final String? selectedList;

  /// Lista de tarefas ativas.
  final List<Task> activeTasks;

  /// Lista de tarefas concluídas.
  final List<Task> completedTasks;

  /// Função chamada quando uma tarefa é marcada como concluída ou não concluída.
  final void Function(Task) onToggleTask;

  /// Função chamada para deletar uma tarefa.
  final void Function(Task) onDeleteTask;

  /// Função chamada para editar uma tarefa.
  final void Function(Task) onEditTask;

  /// Indica se o modo de seleção está ativo.
  final bool selectionMode;

  /// Conjunto de IDs de tarefas selecionadas.
  final Set<String> selectedTaskIds;

  /// Função chamada quando uma tarefa é tocada.
  final Function(Task) onTaskTap;

  /// Função chamada quando uma tarefa é pressionada longamente.
  final Function(Task) onTaskLongPress;

  /// Função chamada para deletar as tarefas selecionadas.
  final VoidCallback onDeleteSelected;

  /// Função chamada para selecionar todas as tarefas.
  final VoidCallback onSelectAll;

  /// Construtor do widget HomeBody.
  const HomeBody({
    super.key,
    required this.selectedList,
    required this.activeTasks,
    required this.completedTasks,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onEditTask,
    required this.selectionMode,
    required this.selectedTaskIds,
    required this.onTaskTap,
    required this.onTaskLongPress,
    required this.onDeleteSelected,
    required this.onSelectAll,
  });

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
              /// Se uma lista estiver selecionada, exibe as tarefas ativas e concluídas.
              /// As tarefas são organizadas em seções, cada uma com seu título e lista de tarefas.
              : ListView(
                children: [
                  if (activeTasks.isNotEmpty)
                    TaskSection(
                      title: 'Tarefas Ativas',
                      tasks: activeTasks,
                      onToggle: onToggleTask,
                      onDelete: onDeleteTask,
                      onTaskTap: onTaskTap,
                      onTaskLongPress: onTaskLongPress,
                      selectionMode: selectionMode,
                      selectedTaskIds: selectedTaskIds,
                    ),

                  /// Se não houver tarefas ativas, exibe uma mensagem informando que não há tarefas ativas.
                  if (completedTasks.isNotEmpty)
                    TaskSection(
                      title: 'Tarefas Concluídas',
                      tasks: completedTasks,
                      onToggle: onToggleTask,
                      onDelete: onDeleteTask,
                      onTaskTap: onTaskTap,
                      onTaskLongPress: onTaskLongPress,
                      selectionMode: selectionMode,
                      selectedTaskIds: selectedTaskIds,
                    ),
                ],
              ),
    );
  }
}
