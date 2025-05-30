import '../../models/task_model.dart';

/// Interface que define o contrato para o controlador de tarefas
abstract class ITaskController {
  /// Indica se o modo de seleção está ativo
  bool get selectionMode;
  set selectionMode(bool value);

  /// Conjunto de IDs das tarefas selecionadas
  Set<String> get selectedTaskIds;

  /// Alterna o estado de conclusão de uma tarefa
  void toggleTask({
    required TaskModel task,
    required List<TaskModel> activeTasks,
    required List<TaskModel> completedTasks,
  });

  /// Atualiza uma tarefa existente na lista
  void updateTask(List<TaskModel> tasks, TaskModel updatedTask);

  /// Adiciona uma nova tarefa à lista
  void addTask(List<TaskModel> tasks, TaskModel task);

  /// Remove uma tarefa da lista
  void removeTask(List<TaskModel> tasks, TaskModel task);

  /// Manipula o toque em uma tarefa
  void onTaskTap(TaskModel task, Function editCallback);

  /// Manipula o toque longo em uma tarefa
  void onTaskLongPress(TaskModel task);

  /// Seleciona ou desseleciona todas as tarefas
  void selectAllTasks(List<TaskModel> activeTasks, List<TaskModel> completedTasks);

  /// Remove todas as tarefas selecionadas
  void deleteSelectedTasks(List<TaskModel> activeTasks, List<TaskModel> completedTasks);
}
