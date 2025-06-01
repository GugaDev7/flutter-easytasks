import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task_model.dart';
import '../utils/snackbar_utils.dart';
import '../utils/constants.dart';
import 'interfaces/i_task_list_controller.dart';

// Classe que controla todas as operações com listas de tarefas
class TaskListController implements ITaskListController {
  // Serviço que salva e carrega as tarefas
  final TaskService _taskService;

  // Permite criar o controlador com um serviço personalizado
  TaskListController({TaskService? taskService})
    : _taskService = taskService ?? TaskService();

  // Lista com os nomes de todas as listas
  @override
  List<String> taskLists = [];

  // Nome da lista selecionada no momento
  @override
  String? selectedList;

  // Mapeia cada lista para suas tarefas ativas
  @override
  final Map<String, List<TaskModel>> activeTasks = {};

  // Mapeia cada lista para suas tarefas concluídas
  @override
  final Map<String, List<TaskModel>> completedTasks = {};

  // Carrega todas as listas do armazenamento
  @override
  Future<void> loadTaskLists(BuildContext context) async {
    try {
      // Carrega as listas e seleciona a primeira
      final lists = await _taskService.loadTaskLists();
      taskLists = lists;
      selectedList = taskLists.isNotEmpty ? taskLists[0] : null;
    } catch (e) {
      // Se der erro, mostra mensagem
      SnackbarUtils.showError(context, '${ErrorMessages.loadListsError}$e');
    }
  }

  // Carrega as tarefas de uma lista específica
  @override
  Future<void> loadTasks(String listName, BuildContext context) async {
    try {
      // Carrega e separa em ativas e concluídas
      final tasks = await _taskService.loadTasks(listName);
      activeTasks[listName] = tasks['active']!;
      completedTasks[listName] = tasks['completed']!;
    } catch (e) {
      // Se der erro, mostra mensagem
      SnackbarUtils.showError(context, '${ErrorMessages.loadTasksError}$e');
    }
  }

  // Salva todas as listas no armazenamento
  @override
  Future<void> saveTaskLists(BuildContext context) async {
    try {
      await _taskService.saveTaskLists(taskLists);
    } catch (e) {
      // Se der erro, mostra mensagem
      SnackbarUtils.showError(context, '${ErrorMessages.saveListsError}$e');
    }
  }

  // Salva as tarefas de uma lista específica
  @override
  Future<void> saveTasks(String listName, BuildContext context) async {
    try {
      // Junta as tarefas ativas e concluídas para salvar
      final allTasks = [
        ...?activeTasks[listName],
        ...?completedTasks[listName],
      ];
      await _taskService.saveTasks(listName, allTasks);
    } catch (e) {
      // Se der erro, mostra mensagem
      SnackbarUtils.showError(context, '${ErrorMessages.saveTasksError}$e');
    }
  }

  // Deleta uma lista e todas suas tarefas
  @override
  Future<void> deleteTaskList(String listName, BuildContext context) async {
    try {
      // Apaga do armazenamento e da memória
      await _taskService.deleteTaskList(listName);
      taskLists.remove(listName);
      activeTasks.remove(listName);
      completedTasks.remove(listName);
      // Seleciona a primeira lista que sobrou
      selectedList = taskLists.isNotEmpty ? taskLists[0] : null;
    } catch (e) {
      // Se der erro, mostra mensagem
      SnackbarUtils.showError(context, '${ErrorMessages.deleteListError}$e');
    }
  }
}
