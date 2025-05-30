import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task_model.dart';
import '../utils/snackbar_utils.dart';
import '../utils/constants.dart';
import 'interfaces/i_task_list_controller.dart';

/// Implementação do controlador de listas de tarefas
class TaskListController implements ITaskListController {
  /// Serviço responsável pela persistência das tarefas
  final TaskService _taskService;

  /// Construtor que permite injeção do serviço de tarefas
  TaskListController({TaskService? taskService}) : _taskService = taskService ?? TaskService();

  @override
  List<String> taskLists = [];

  @override
  String? selectedList;

  @override
  final Map<String, List<TaskModel>> activeTasks = {};

  @override
  final Map<String, List<TaskModel>> completedTasks = {};

  @override
  Future<void> loadTaskLists(BuildContext context) async {
    try {
      final lists = await _taskService.loadTaskLists();
      taskLists = lists;
      selectedList = taskLists.isNotEmpty ? taskLists[0] : null;
    } catch (e) {
      SnackbarUtils.showError(context, '${ErrorMessages.loadListsError}$e');
    }
  }

  @override
  Future<void> loadTasks(String listName, BuildContext context) async {
    try {
      final tasks = await _taskService.loadTasks(listName);
      activeTasks[listName] = tasks['active']!;
      completedTasks[listName] = tasks['completed']!;
    } catch (e) {
      SnackbarUtils.showError(context, '${ErrorMessages.loadTasksError}$e');
    }
  }

  @override
  Future<void> saveTaskLists(BuildContext context) async {
    try {
      await _taskService.saveTaskLists(taskLists);
    } catch (e) {
      SnackbarUtils.showError(context, '${ErrorMessages.saveListsError}$e');
    }
  }

  @override
  Future<void> saveTasks(String listName, BuildContext context) async {
    try {
      final allTasks = [...?activeTasks[listName], ...?completedTasks[listName]];
      await _taskService.saveTasks(listName, allTasks);
    } catch (e) {
      SnackbarUtils.showError(context, '${ErrorMessages.saveTasksError}$e');
    }
  }

  @override
  Future<void> deleteTaskList(String listName, BuildContext context) async {
    try {
      await _taskService.deleteTaskList(listName);
      taskLists.remove(listName);
      activeTasks.remove(listName);
      completedTasks.remove(listName);
      selectedList = taskLists.isNotEmpty ? taskLists[0] : null;
    } catch (e) {
      SnackbarUtils.showError(context, '${ErrorMessages.deleteListError}$e');
    }
  }
}
