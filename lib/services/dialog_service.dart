import 'package:flutter/material.dart';
import '../widgets/app_dialog.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

/// Serviço responsável por gerenciar os diálogos da aplicação
class DialogService {
  /// Exibe um diálogo para adicionar uma nova lista de tarefas
  ///
  /// [context] é o contexto do BuildContext
  /// [existingLists] é a lista de nomes de listas já existentes
  /// Retorna o nome da nova lista ou null se cancelado
  static Future<String?> showAddListDialog(
    BuildContext context,
    List<String> existingLists,
  ) async {
    return await AppDialog.showEditText(
      context: context,
      title: Titles.newList,
      labelText: DialogTexts.enterListName,
      confirmText: ActionLabels.create,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return ErrorMessages.emptyField;
        }
        if (existingLists.contains(value.trim())) {
          return ErrorMessages.listExists;
        }
        return null;
      },
    );
  }

  /// Exibe um diálogo para editar o nome de uma lista existente
  ///
  /// [context] é o contexto do BuildContext
  /// [currentListName] é o nome atual da lista
  /// [existingLists] é a lista de nomes de listas já existentes
  /// Retorna o novo nome da lista ou null se cancelado
  static Future<String?> showEditListDialog(
    BuildContext context,
    String currentListName,
    List<String> existingLists,
  ) async {
    return await AppDialog.showEditText(
      context: context,
      title: Titles.editList,
      initialValue: currentListName,
      labelText: DialogTexts.enterListName,
      confirmText: ActionLabels.save,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return ErrorMessages.emptyField;
        }
        if (existingLists.contains(value.trim()) &&
            value.trim() != currentListName) {
          return ErrorMessages.listExists;
        }
        return null;
      },
    );
  }

  /// Exibe um diálogo para adicionar uma nova tarefa
  ///
  /// [context] é o contexto do BuildContext
  /// Retorna um mapa com o título e prioridade da tarefa ou null se cancelado
  static Future<Map<String, dynamic>?> showAddTaskDialog(
    BuildContext context,
  ) async {
    return await AppDialog.showTaskDialog(
      context: context,
      title: Titles.newTask,
      confirmText: ActionLabels.add,
    );
  }

  /// Exibe um diálogo para editar uma tarefa existente
  ///
  /// [context] é o contexto do BuildContext
  /// [task] é a tarefa a ser editada
  /// Retorna um mapa com o novo título e prioridade da tarefa ou null se cancelado
  static Future<Map<String, dynamic>?> showEditTaskDialog(
    BuildContext context,
    TaskModel task,
  ) async {
    return await AppDialog.showTaskDialog(
      context: context,
      title: Titles.editTask,
      initialTitle: task.title,
      initialPriority: task.priority,
      confirmText: ActionLabels.save,
    );
  }

  /// Exibe um diálogo de confirmação para exclusão
  ///
  /// [context] é o contexto do BuildContext
  /// [customMessage] é uma mensagem personalizada opcional
  /// Retorna true se confirmado, false se cancelado
  static Future<bool?> showDeleteConfirmation(
    BuildContext context, {
    String? customMessage,
  }) async {
    return await AppDialog.showConfirmation(
      context: context,
      title: Titles.delete,
      content: customMessage ?? DialogTexts.confirmDelete,
      confirmText: ActionLabels.delete,
    );
  }
}
