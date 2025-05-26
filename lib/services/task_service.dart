import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

/// Serviço para gerenciar tarefas e listas de tarefas no Firestore.
class TaskService {
  /// Construtor privado para garantir que a classe seja um singleton.
  final _firestore = FirebaseFirestore.instance;

  /// Instância do FirebaseAuth para autenticação de usuários.
  final _auth = FirebaseAuth.instance;

  /// Construtor privado para garantir que a classe seja um singleton.
  String get _userId {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');
    return user.uid;
  }

  /// Método privado para garantir que a classe seja um singleton.
  Future<List<String>> loadTaskLists() async {
    final snapshot = await _firestore.collection('users').doc(_userId).collection('lists').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /// Método para carregar as listas de tarefas do usuário autenticado.
  Future<void> saveTaskLists(List<String> taskLists) async {
    for (final listName in taskLists) {
      await _firestore.collection('users').doc(_userId).collection('lists').doc(listName).set({});
    }
  }

  /// Método para carregar as tarefas de uma lista específica.
  Future<Map<String, List<TaskModel>>> loadTasks(String listName) async {
    final snapshot =
        await _firestore.collection('users').doc(_userId).collection('lists').doc(listName).collection('tasks').get();

    /// Divide as tarefas em ativas e concluídas.
    final activeTasks = <TaskModel>[];

    /// Lista para armazenar as tarefas ativas.
    final completedTasks = <TaskModel>[];

    /// Lista para armazenar as tarefas concluídas.
    for (final doc in snapshot.docs) {
      final task = TaskModel.fromMap(doc.data());
      task.isCompleted ? completedTasks.add(task) : activeTasks.add(task);
    }

    return {'active': activeTasks, 'completed': completedTasks};
  }

  /// Método para salvar as tarefas de uma lista específica.
  Future<void> saveTasks(String listName, List<TaskModel> allTasks) async {
    final tasksCollection = _firestore
        .collection('users')
        .doc(_userId)
        .collection('lists')
        .doc(listName)
        .collection('tasks');

    /// Obtém as tarefas existentes no Firestore para comparação.
    final oldTasks = await tasksCollection.get();

    /// Converte as tarefas existentes em um conjunto de IDs para fácil comparação.
    final newIds = allTasks.map((t) => t.id).toSet();

    // Remove tarefas que não existem mais
    for (final doc in oldTasks.docs) {
      if (!newIds.contains(doc.id)) {
        await doc.reference.delete();
      }
    }

    // Adiciona ou atualiza tarefas
    for (final task in allTasks) {
      await tasksCollection.doc(task.id).set(task.toMap());
    }
  }
}
