import 'package:flutter/material.dart';
import 'package:flutter_easytasks/controllers/task_manager.dart';
import 'package:flutter_easytasks/screens/home/home_body.dart';
import 'package:flutter_easytasks/screens/home/home_drawer.dart';
import 'package:flutter_easytasks/utils/snackbar_utils.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';
import 'package:flutter_easytasks/widgets/app_dialog.dart';
import '../../services/task_service.dart';
import '../../widgets/app_dialog.dart';
import '../../models/task.dart';

/// Tela principal do aplicativo, responsável por gerenciar listas e tarefas.
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// Estado da tela principal, com lógica de manipulação das listas e tarefas.
class _HomeScreenState extends State<HomeScreen> {
  /// Serviço para persistência das tarefas.
  final TaskService _taskService = TaskService();

  /// Lista de nomes das listas de tarefas.
  List<String> _taskLists = [];

  /// Nome da lista atualmente selecionada.
  String? _selectedList;

  /// Mapa de tarefas ativas por lista.
  final Map<String, List<Task>> _activeTasks = {};

  /// Mapa de tarefas concluídas por lista.
  final Map<String, List<Task>> _completedTasks = {};

  /// Inicializa o estado da tela principal.
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Inicializa os dados, carregando listas e tarefas.
  Future<void> _initializeData() async {
    await _loadTaskLists();
    if (_selectedList != null) await _loadTasks(_selectedList!);
  }

  /// Carrega as listas de tarefas do armazenamento.
  Future<void> _loadTaskLists() async {
    try {
      final lists = await _taskService.loadTaskLists();
      setState(() {
        _taskLists = lists;
        _selectedList = _taskLists.isNotEmpty ? _taskLists[0] : null;
      });
    } catch (e) {
      SnackbarUtils.showError(context, 'Erro ao carregar listas: $e');
    }
  }

  ///Alterna o status de conclusão de uma tarefa.
  void _toggleTask(Task task) {
    setState(() {
      TaskManager.toggleTask(
        task: task,
        activeTasks: _activeTasks[_selectedList!]!,
        completedTasks: _completedTasks[_selectedList!]!,
      );
    });
    _saveTasks(_selectedList!);
  }

  /// Carrega as tarefas de uma lista específica.
  Future<void> _loadTasks(String listName) async {
    try {
      final tasks = await _taskService.loadTasks(listName);
      setState(() {
        _activeTasks[listName] = tasks['active']!;
        _completedTasks[listName] = tasks['completed']!;
        TaskManager.sortTasks(_activeTasks[listName]!);
      });
    } catch (e) {
      SnackbarUtils.showError(context, 'Erro ao carregar tarefas: $e');
    }
  }

  /// Salva as listas de tarefas no armazenamento.
  Future<void> _saveTaskLists() async {
    try {
      await _taskService.saveTaskLists(_taskLists);
    } catch (e) {
      SnackbarUtils.showError(context, 'Erro ao salvar listas: $e');
    }
  }

  /// Salva as tarefas de uma lista específica no armazenamento.
  Future<void> _saveTasks(String listName) async {
    try {
      final allTasks = [...?_activeTasks[listName], ...?_completedTasks[listName]];
      await _taskService.saveTasks(listName, allTasks);
    } catch (e) {
      SnackbarUtils.showError(context, 'Erro ao salvar tarefas: $e');
    }
  }

  /// Exibe um diálogo de confirmação para apagar uma tarefa.
  Future<void> _confirmDelete(Task task) async {
    final confirm = await AppDialog.showConfirmation(
      context: context,
      title: 'Apagar Tarefa',
      content: 'Deseja realmente apagar esta tarefa?',
    );

    if (confirm == true) {
      setState(() {
        if (!task.isCompleted) {
          TaskManager.removeTask(_activeTasks[_selectedList!]!, task);
        } else {
          TaskManager.removeTask(_completedTasks[_selectedList!]!, task);
        }
      });
      await _saveTasks(_selectedList!);
    }
  }

  /// Exibe um diálogo para adicionar uma nova lista de tarefas.
  Future<void> _addTaskList() async {
    final newListName = await AppDialog.showEditText(
      context: context,
      title: 'Nova Lista',
      labelText: 'Insira o nome da Lista.',
      confirmText: 'Criar',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo não pode estar vazio.";
        }
        if (_taskLists.contains(value.trim())) {
          return "Essa Lista já existe!";
        }
        return null;
      },
    );

    if (newListName != null && newListName.isNotEmpty) {
      setState(() {
        _taskLists.add(newListName);
        _activeTasks[newListName] = [];
        _completedTasks[newListName] = [];
        _selectedList = newListName;
      });
      await _saveTaskLists();
      await _saveTasks(newListName);
    }
  }

  /// Exibe um diálogo de confirmação para apagar uma lista de tarefas.
  Future<void> _confirmDeleteList(String listName) async {
    final confirm = await AppDialog.showConfirmation(
      context: context,
      title: 'Apagar Lista',
      content: 'Deseja apagar a lista "$listName"?',
      confirmText: 'Apagar',
    );

    if (confirm == true) {
      setState(() {
        _taskLists.remove(listName);
        _activeTasks.remove(listName);
        _completedTasks.remove(listName);
        _selectedList = _taskLists.isNotEmpty ? _taskLists[0] : null;
      });
      await _saveTaskLists();
      if (_selectedList != null) await _saveTasks(_selectedList!);
    }
  }

  /// Exibe um diálogo para editar o nome de uma lista de tarefas.
  Future<void> _editListNameDialog(String currentListName) async {
    final newName = await AppDialog.showEditText(
      context: context,
      title: 'Renomear Lista',
      initialValue: currentListName,
      labelText: 'Insira o nome da Lista.',
      confirmText: 'Salvar',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo não pode estar vazio.";
        }
        if (_taskLists.contains(value.trim())) {
          return "Essa Lista já existe!";
        }
        return null;
      },
    );

    if (newName != null && newName != currentListName) {
      setState(() {
        final index = _taskLists.indexOf(currentListName);
        _taskLists[index] = newName;

        if (_activeTasks.containsKey(currentListName)) {
          _activeTasks[newName] = _activeTasks.remove(currentListName)!;
        }
        if (_completedTasks.containsKey(currentListName)) {
          _completedTasks[newName] = _completedTasks.remove(currentListName)!;
        }

        if (_selectedList == currentListName) {
          _selectedList = newName;
        }
      });

      await _saveTaskLists();
      await _saveTasks(newName);
    }
  }

  /// Exibe um diálogo para editar uma tarefa.
  Future<void> _editTaskDialog(Task task) async {
    final result = await AppDialog.showTaskDialog(
      context: context,
      title: 'Editar Tarefa',
      initialTitle: task.title,
      initialPriority: task.priority,
      confirmText: 'Salvar',
    );
    if (result != null && result['title']!.isNotEmpty) {
      final updatedTask = task.copyWith(title: result['title'], priority: result['priority']);
      setState(() {
        TaskManager.updateTask(_activeTasks[_selectedList!]!, updatedTask);
      });
      await _saveTasks(_selectedList!);
    }
  }

  /// Exibe um diálogo para adicionar uma nova tarefa.
  Future<void> _addTaskButton() async {
    if (_selectedList == null) {
      SnackbarUtils.showError(context, 'Crie uma lista primeiro!');
    } else {
      final result = await AppDialog.showTaskDialog(context: context, title: 'Nova Tarefa', confirmText: 'Adicionar');
      if (result != null && result['title']!.isNotEmpty) {
        setState(() {
          TaskManager.addTask(
            _activeTasks[_selectedList!]!,
            Task(title: result['title']!, priority: result['priority']!),
          );
        });
        await _saveTasks(_selectedList!);
      } else if (result != null && result['title']!.isEmpty) {
        SnackbarUtils.showError(context, "A Tarefa precisa de um nome!");
      }
    }
  }

  /// Exibe um diálogo para selecionar uma lista de tarefas.
  void _selectTaskList(String listName) {
    setState(() => _selectedList = listName);
    _loadTasks(listName);
    Navigator.pop(context);
  }

  /// Chave global para o Scaffold, usada para exibir o Snackbar.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ///Construção da tela principal.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      /// AppBar com título e ícone de menu.
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(_selectedList ?? 'Easy Tasks', style: const TextStyle(color: Colors.white, fontSize: 33)),

        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
      ),

      /// Drawer com listas de tarefas.
      drawer: HomeDrawer(
        taskLists: _taskLists,
        selectedList: _selectedList,
        onSelectList: _selectTaskList,
        onAddTaskList: _addTaskList,
        onEditListName: _editListNameDialog,
        onDeleteList: _confirmDeleteList,
      ),

      /// Corpo da tela com tarefas ativas e concluídas.
      body: HomeBody(
        selectedList: _selectedList,
        activeTasks: _activeTasks[_selectedList] ?? [],
        completedTasks: _completedTasks[_selectedList] ?? [],
        onToggleTask: _toggleTask,
        onDeleteTask: _confirmDelete,
        onEditTask: _editTaskDialog,
      ),

      /// Botão flutuante para adicionar nova tarefa.
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskButton,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
