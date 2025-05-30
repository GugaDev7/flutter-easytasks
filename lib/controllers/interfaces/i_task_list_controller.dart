import 'package:flutter/material.dart';
import '../../models/task_model.dart';

/// Interface que define o contrato para o controlador de listas de tarefas
abstract class ITaskListController {
  /// Lista de nomes das listas de tarefas
  List<String> get taskLists;

  /// Lista atualmente selecionada
  String? get selectedList;
  set selectedList(String? value);

  /// Mapa de tarefas ativas por lista
  Map<String, List<TaskModel>> get activeTasks;

  /// Mapa de tarefas concluídas por lista
  Map<String, List<TaskModel>> get completedTasks;

  /// Carrega todas as listas de tarefas do armazenamento
  Future<void> loadTaskLists(BuildContext context);

  /// Carrega as tarefas de uma lista específica
  Future<void> loadTasks(String listName, BuildContext context);

  /// Salva todas as listas de tarefas no armazenamento
  Future<void> saveTaskLists(BuildContext context);

  /// Salva as tarefas de uma lista específica
  Future<void> saveTasks(String listName, BuildContext context);

  /// Remove uma lista de tarefas e suas tarefas associadas
  Future<void> deleteTaskList(String listName, BuildContext context);
}
