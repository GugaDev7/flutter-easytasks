import 'package:flutter/material.dart';
import 'task_section.dart';
import '../../models/task.dart';

class HomeBody extends StatelessWidget {
  final String? selectedList;
  final List<Task> activeTasks;
  final List<Task> completedTasks;
  final void Function(Task) onToggleTask;
  final void Function(Task) onDeleteTask;
  final void Function(Task) onEditTask;

  const HomeBody({
    super.key,
    required this.selectedList,
    required this.activeTasks,
    required this.completedTasks,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onEditTask,
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
                    const Text('Nenhuma lista selecionada', style: TextStyle(fontSize: 18)),
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
