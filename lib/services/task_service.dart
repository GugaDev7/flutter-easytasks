import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

/// Classe que cuida de salvar e carregar dados no Firebase
class TaskService {
  /// Instância do Firestore para acessar o banco
  final _firestore = FirebaseFirestore.instance;

  /// Instância do Auth para pegar o usuário logado
  final _auth = FirebaseAuth.instance;

  /// Pega o ID do usuário logado
  String get _userId {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');
    return user.uid;
  }

  /// Carrega os nomes de todas as listas do usuário
  Future<List<String>> loadTaskLists() async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('lists')
            .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  /// Salva os nomes das listas do usuário
  Future<void> saveTaskLists(List<String> taskLists) async {
    for (final listName in taskLists) {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('lists')
          .doc(listName)
          .set({});
    }
  }

  /// Carrega todas as tarefas de uma lista
  Future<Map<String, List<TaskModel>>> loadTasks(String listName) async {
    /// Busca as tarefas no Firebase
    final snapshot =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('lists')
            .doc(listName)
            .collection('tasks')
            .get();

    /// Separa as tarefas em ativas e concluídas
    final activeTasks = <TaskModel>[];

    /// Lista de tarefas não concluídas
    final completedTasks = <TaskModel>[];

    /// Lista de tarefas concluídas

    /// Coloca cada tarefa na lista correta
    for (final doc in snapshot.docs) {
      final task = TaskModel.fromMap(doc.data());
      task.isCompleted ? completedTasks.add(task) : activeTasks.add(task);
    }

    return {'active': activeTasks, 'completed': completedTasks};
  }

  /// Salva todas as tarefas de uma lista
  Future<void> saveTasks(String listName, List<TaskModel> allTasks) async {
    /// Pega a coleção de tarefas no Firebase
    final tasksCollection = _firestore
        .collection('users')
        .doc(_userId)
        .collection('lists')
        .doc(listName)
        .collection('tasks');

    /// Carrega as tarefas que já existem
    final oldTasks = await tasksCollection.get();

    /// Pega os IDs das novas tarefas
    final newIds = allTasks.map((t) => t.id).toSet();

    /// Apaga as tarefas que não existem mais
    for (final doc in oldTasks.docs) {
      if (!newIds.contains(doc.id)) {
        await doc.reference.delete();
      }
    }

    /// Salva ou atualiza cada tarefa
    for (final task in allTasks) {
      await tasksCollection.doc(task.id).set(task.toMap());
    }
  }

  /// Deleta uma lista e todas suas tarefas
  Future<void> deleteTaskList(String listName) async {
    /// Pega o documento da lista
    final listDoc = _firestore
        .collection('users')
        .doc(_userId)
        .collection('lists')
        .doc(listName);

    /// Apaga todas as tarefas da lista
    final tasksSnapshot = await listDoc.collection('tasks').get();
    for (final doc in tasksSnapshot.docs) {
      await doc.reference.delete();
    }

    /// Apaga a lista
    await listDoc.delete();
  }
}
