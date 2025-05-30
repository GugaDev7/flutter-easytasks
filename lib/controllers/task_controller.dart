import '../models/task_model.dart';
import 'interfaces/i_task_controller.dart';

/// Controlador responsável por gerenciar operações relacionadas às tarefas individuais.
///
/// Este controlador implementa [ITaskController] e fornece funcionalidades para:
/// * Gerenciamento do modo de seleção de tarefas
/// * Manipulação do estado de conclusão das tarefas
/// * Operações CRUD (Criar, Ler, Atualizar, Deletar) em tarefas
/// * Gerenciamento de seleção múltipla de tarefas
class TaskController implements ITaskController {
  /// Indica se o modo de seleção múltipla está ativo
  @override
  bool selectionMode = false;

  /// Conjunto de IDs das tarefas atualmente selecionadas
  ///
  /// Usa [Set] para garantir unicidade e operações O(1) de adição/remoção
  @override
  final Set<String> selectedTaskIds = {};

  /// Alterna o estado de conclusão de uma tarefa entre ativa e completada.
  ///
  /// Move a tarefa entre as listas [activeTasks] e [completedTasks] de acordo
  /// com seu novo estado.
  ///
  /// Parâmetros:
  /// * [task] - A tarefa a ser alternada
  /// * [activeTasks] - Lista de tarefas ativas
  /// * [completedTasks] - Lista de tarefas completadas
  @override
  void toggleTask({
    required TaskModel task,
    required List<TaskModel> activeTasks,
    required List<TaskModel> completedTasks,
  }) {
    final newTask = task.copyWith(isCompleted: !task.isCompleted);
    if (task.isCompleted) {
      completedTasks.remove(task);
      activeTasks.add(newTask);
    } else {
      activeTasks.remove(task);
      completedTasks.add(newTask);
    }
  }

  /// Atualiza uma tarefa existente na lista.
  ///
  /// Localiza a tarefa pelo ID e substitui com a versão atualizada.
  ///
  /// Parâmetros:
  /// * [tasks] - Lista de tarefas onde a atualização será feita
  /// * [updatedTask] - Nova versão da tarefa com as alterações
  @override
  void updateTask(List<TaskModel> tasks, TaskModel updatedTask) {
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
    }
  }

  /// Adiciona uma nova tarefa à lista especificada.
  ///
  /// Parâmetros:
  /// * [tasks] - Lista onde a tarefa será adicionada
  /// * [task] - Nova tarefa a ser adicionada
  @override
  void addTask(List<TaskModel> tasks, TaskModel task) {
    tasks.add(task);
  }

  /// Remove uma tarefa da lista especificada.
  ///
  /// Parâmetros:
  /// * [tasks] - Lista de onde a tarefa será removida
  /// * [task] - Tarefa a ser removida
  @override
  void removeTask(List<TaskModel> tasks, TaskModel task) {
    tasks.remove(task);
  }

  /// Gerencia o toque em uma tarefa.
  ///
  /// Se estiver em modo de seleção, alterna a seleção da tarefa.
  /// Caso contrário, chama o callback de edição.
  ///
  /// Parâmetros:
  /// * [task] - Tarefa que recebeu o toque
  /// * [editCallback] - Função a ser chamada para editar a tarefa
  @override
  void onTaskTap(TaskModel task, Function editCallback) {
    if (selectionMode) {
      _toggleTaskSelection(task.id);
    } else {
      editCallback();
    }
  }

  /// Inicia o modo de seleção ao receber um toque longo em uma tarefa.
  ///
  /// Parâmetros:
  /// * [task] - Tarefa que recebeu o toque longo
  @override
  void onTaskLongPress(TaskModel task) {
    selectionMode = true;
    selectedTaskIds.add(task.id);
  }

  /// Alterna entre selecionar todas as tarefas ou limpar a seleção.
  ///
  /// Se todas as tarefas já estiverem selecionadas, limpa a seleção.
  /// Caso contrário, seleciona todas as tarefas.
  ///
  /// Parâmetros:
  /// * [activeTasks] - Lista de tarefas ativas
  /// * [completedTasks] - Lista de tarefas completadas
  @override
  void selectAllTasks(List<TaskModel> activeTasks, List<TaskModel> completedTasks) {
    final totalTasks = activeTasks.length + completedTasks.length;
    if (selectedTaskIds.length == totalTasks) {
      _clearSelection();
    } else {
      selectedTaskIds
        ..clear()
        ..addAll(activeTasks.map((t) => t.id))
        ..addAll(completedTasks.map((t) => t.id));
      selectionMode = true;
    }
  }

  /// Remove todas as tarefas selecionadas das listas.
  ///
  /// Parâmetros:
  /// * [activeTasks] - Lista de tarefas ativas
  /// * [completedTasks] - Lista de tarefas completadas
  @override
  void deleteSelectedTasks(List<TaskModel> activeTasks, List<TaskModel> completedTasks) {
    activeTasks.removeWhere((t) => selectedTaskIds.contains(t.id));
    completedTasks.removeWhere((t) => selectedTaskIds.contains(t.id));
    _clearSelection();
  }

  /// Alterna a seleção de uma tarefa específica.
  ///
  /// Se a tarefa já estiver selecionada, remove a seleção.
  /// Caso contrário, adiciona à seleção.
  void _toggleTaskSelection(String taskId) {
    if (selectedTaskIds.contains(taskId)) {
      selectedTaskIds.remove(taskId);
      if (selectedTaskIds.isEmpty) selectionMode = false;
    } else {
      selectedTaskIds.add(taskId);
    }
  }

  /// Limpa todas as seleções e desativa o modo de seleção.
  void _clearSelection() {
    selectedTaskIds.clear();
    selectionMode = false;
  }
}
