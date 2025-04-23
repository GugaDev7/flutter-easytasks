import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

/// Gerencia operações de persistência de dados usando SharedPreferences
class TaskService {
  /// Carrega todas as listas de tarefas salvas
  Future<List<String>> loadTaskLists() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('taskLists') ?? []; // Retorna lista vazia se null
  }

  /// Salva os nomes das listas de tarefas
  Future<void> saveTaskLists(List<String> taskLists) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('taskLists', taskLists); // Persiste no dispositivo
  }

  /// Carrega tarefas de uma lista específica
  Future<Map<String, List<Task>>> loadTasks(String listName) async {
    final prefs = await SharedPreferences.getInstance();
    final taskStrings = prefs.getStringList(listName) ?? [];

    // Separa tarefas ativas e concluídas
    final activeTasks = <Task>[];
    final completedTasks = <Task>[];

    for (final taskString in taskStrings) {
      final task = Task.fromString(taskString);
      task.isCompleted ? completedTasks.add(task) : activeTasks.add(task);
    }

    return {'active': activeTasks, 'completed': completedTasks};
  }

  /// Salva todas as tarefas de uma lista (ativas + concluídas)
  Future<void> saveTasks(String listName, List<Task> allTasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      listName,
      allTasks.map((task) => task.toString()).toList(), // Converte para strings
    );
  }
}
