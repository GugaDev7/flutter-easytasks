import '../models/task.dart';

/// Classe para manipulação de tarefas.
class TaskManager {
  /// Ordena as tarefas por prioridade.
  static void sortTasks(List<Task> tasks) {
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
  static void addTask(List<Task> tasks, Task task) {
    tasks.add(task);
    sortTasks(tasks);
  }

  /// Remove uma tarefa da lista.
  static void removeTask(List<Task> tasks, Task task) {
    tasks.remove(task);
  }

  /// Atualiza uma tarefa na lista e ordena.
  static void updateTask(List<Task> tasks, Task updatedTask) {
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      sortTasks(tasks);
    }
  }

  /// Alterna o status de conclusão de uma tarefa.
  static void toggleTask({required Task task, required List<Task> activeTasks, required List<Task> completedTasks}) {
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
