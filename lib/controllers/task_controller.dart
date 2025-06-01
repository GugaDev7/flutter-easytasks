import '../models/task_model.dart';
import 'interfaces/i_task_controller.dart';

/// Classe que controla todas as operações com tarefas individuais
class TaskController implements ITaskController {
  /// Indica se está no modo de selecionar várias tarefas
  @override
  bool selectionMode = false;

  /// Guarda os IDs das tarefas selecionadas
  /// Usa Set para não ter IDs repetidos e ser mais rápido
  @override
  final Set<String> selectedTaskIds = {};

  /// Marca/desmarca uma tarefa como concluída
  /// Move a tarefa entre as listas de ativas e concluídas
  @override
  void toggleTask({
    required TaskModel task,
    required List<TaskModel> activeTasks,
    required List<TaskModel> completedTasks,
  }) {
    /// Cria uma cópia da tarefa com o estado invertido
    final newTask = task.copyWith(isCompleted: !task.isCompleted);
    if (task.isCompleted) {
      /// Se estava concluída, move para ativas
      completedTasks.remove(task);
      activeTasks.add(newTask);
    } else {
      /// Se estava ativa, move para concluídas
      activeTasks.remove(task);
      completedTasks.add(newTask);
    }
  }

  /// Atualiza os dados de uma tarefa existente
  @override
  void updateTask(List<TaskModel> tasks, TaskModel updatedTask) {
    /// Procura a tarefa pelo ID e substitui
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
    }
  }

  /// Adiciona uma nova tarefa na lista
  @override
  void addTask(List<TaskModel> tasks, TaskModel task) {
    tasks.add(task);
  }

  /// Remove uma tarefa da lista
  @override
  void removeTask(List<TaskModel> tasks, TaskModel task) {
    tasks.remove(task);
  }

  /// Trata o toque em uma tarefa
  @override
  void onTaskTap(TaskModel task, Function editCallback) {
    if (selectionMode) {
      /// Se estiver selecionando, marca/desmarca a tarefa
      _toggleTaskSelection(task.id);
    } else {
      /// Se não, abre para editar
      editCallback();
    }
  }

  /// Trata o toque longo em uma tarefa
  @override
  void onTaskLongPress(TaskModel task) {
    /// Ativa o modo de seleção e marca a tarefa
    selectionMode = true;
    selectedTaskIds.add(task.id);
  }

  /// Seleciona todas as tarefas ou limpa a seleção
  @override
  void selectAllTasks(
    List<TaskModel> activeTasks,
    List<TaskModel> completedTasks,
  ) {
    final totalTasks = activeTasks.length + completedTasks.length;
    if (selectedTaskIds.length == totalTasks) {
      /// Se todas já estão selecionadas, limpa
      _clearSelection();
    } else {
      /// Se não, seleciona todas
      selectedTaskIds
        ..clear()
        ..addAll(activeTasks.map((t) => t.id))
        ..addAll(completedTasks.map((t) => t.id));
      selectionMode = true;
    }
  }

  /// Deleta todas as tarefas selecionadas
  @override
  void deleteSelectedTasks(
    List<TaskModel> activeTasks,
    List<TaskModel> completedTasks,
  ) {
    /// Remove das duas listas todas as tarefas selecionadas
    activeTasks.removeWhere((t) => selectedTaskIds.contains(t.id));
    completedTasks.removeWhere((t) => selectedTaskIds.contains(t.id));
    _clearSelection();
  }

  /// Marca/desmarca uma tarefa como selecionada
  void _toggleTaskSelection(String taskId) {
    if (selectedTaskIds.contains(taskId)) {
      /// Se já estava selecionada, desmarca
      selectedTaskIds.remove(taskId);

      /// Se não sobrou nenhuma, desativa o modo de seleção
      if (selectedTaskIds.isEmpty) selectionMode = false;
    } else {
      /// Se não estava selecionada, marca
      selectedTaskIds.add(taskId);
    }
  }

  /// Limpa todas as seleções
  void _clearSelection() {
    selectedTaskIds.clear();
    selectionMode = false;
  }
}
