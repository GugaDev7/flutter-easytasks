import '../models/task_model.dart';

/// Classe para manipulação de tarefas.
class TaskManager {
  /// Ordena as tarefas por prioridade.
  static void sortTasks(List<TaskModel> tasks) {
    tasks.sort((a, b) => _priorityValue(b.priority) - _priorityValue(a.priority));
  }

  /// Retorna o valor numérico da prioridade.
  static int _priorityValue(String priority) {
    switch (priority) {
      case 'Alta':
        return 4;
      case 'Média':
        return 3;
      case 'Baixa':
        return 2;
      default:
        return 1;
    }
  }

  /// Adiciona uma tarefa à lista e ordena.
  static void addTask(List<TaskModel> tasks, TaskModel task) {
    tasks.add(task);
    sortTasks(tasks);
  }

  /// Remove uma tarefa da lista.
  static void removeTask(List<TaskModel> tasks, TaskModel task) {
    tasks.remove(task);
  }

  /// Atualiza uma tarefa na lista e ordena.
  static void updateTask(List<TaskModel> tasks, TaskModel updatedTask) {
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      sortTasks(tasks);
    }
  }

  /// Alterna o status de conclusão de uma tarefa.
  static void toggleTask({
    required TaskModel task,
    required List<TaskModel> activeTasks,
    required List<TaskModel> completedTasks,
  }) {
    task.isCompleted = !task.isCompleted;
    if (task.isCompleted) {
      activeTasks.remove(task);
      completedTasks.add(task);
    } else {
      completedTasks.remove(task);
      activeTasks.add(task);
      sortTasks(activeTasks);
    }
  }
}
