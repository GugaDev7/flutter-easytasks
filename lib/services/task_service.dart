import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskService {
  Future<List<String>> loadTaskLists() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('taskLists') ?? [];
  }

  Future<void> saveTaskLists(List<String> taskLists) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('taskLists', taskLists);
  }

  Future<Map<String, List<Task>>> loadTasks(String listName) async {
    final prefs = await SharedPreferences.getInstance();
    final taskStrings = prefs.getStringList(listName) ?? [];

    final activeTasks = <Task>[];
    final completedTasks = <Task>[];

    for (final taskString in taskStrings) {
      final task = Task.fromString(taskString);
      task.isCompleted ? completedTasks.add(task) : activeTasks.add(task);
    }

    return {'active': activeTasks, 'completed': completedTasks};
  }

  Future<void> saveTasks(String listName, List<Task> allTasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(listName, allTasks.map((task) => task.toString()).toList());
  }
}
