import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easytasks/controllers/task_controller.dart';
import 'package:flutter_easytasks/controllers/task_list_controller.dart';
import 'package:flutter_easytasks/screens/auth/auth_screen.dart';
import 'package:flutter_easytasks/screens/home/home_body.dart';
import 'package:flutter_easytasks/screens/home/home_drawer.dart';
import 'package:flutter_easytasks/screens/load_screen.dart';
import 'package:flutter_easytasks/services/auth_service.dart';
import 'package:flutter_easytasks/services/dialog_service.dart';
import 'package:flutter_easytasks/utils/snackbar_utils.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';
import '../../models/task_model.dart';

/// Tela principal do aplicativo, responsável por gerenciar listas e tarefas.
class HomeScreen extends StatefulWidget {
  HomeScreen(BuildContext context, {super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// Estado da tela principal, com lógica de manipulação das listas e tarefas.
class _HomeScreenState extends State<HomeScreen> {
  final TaskListController _listController = TaskListController();
  final TaskController _taskController = TaskController();
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: AppTheme.backgroundColor));
    _initializeData();
  }

  /// Inicializa os dados, carregando listas e tarefas.
  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    await _listController.loadTaskLists(context);
    if (_listController.selectedList != null) {
      await _listController.loadTasks(_listController.selectedList!, context);
    }
    setState(() => _isLoading = false);
  }

  /// Alterna o status de conclusão de uma tarefa.
  void _toggleTask(TaskModel task) {
    setState(() {
      _taskController.toggleTask(
        task: task,
        activeTasks: _listController.activeTasks[_listController.selectedList!]!,
        completedTasks: _listController.completedTasks[_listController.selectedList!]!,
      );
    });
    _listController.saveTasks(_listController.selectedList!, context);
  }

  /// Exibe um diálogo de confirmação para apagar uma tarefa.
  Future<void> _confirmDelete(TaskModel task) async {
    final confirm = await DialogService.showDeleteConfirmation(
      context,
      customMessage: 'Deseja realmente apagar esta tarefa?',
    );

    if (confirm == true) {
      setState(() {
        if (!task.isCompleted) {
          _taskController.removeTask(_listController.activeTasks[_listController.selectedList!]!, task);
        } else {
          _taskController.removeTask(_listController.completedTasks[_listController.selectedList!]!, task);
        }
      });
      await _listController.saveTasks(_listController.selectedList!, context);
    }
  }

  /// Exibe um diálogo para adicionar uma nova lista de tarefas.
  Future<void> _addTaskList() async {
    final newListName = await DialogService.showAddListDialog(context, _listController.taskLists);

    if (newListName != null && newListName.isNotEmpty) {
      setState(() {
        _listController.taskLists.add(newListName);
        _listController.activeTasks[newListName] = [];
        _listController.completedTasks[newListName] = [];
        _listController.selectedList = newListName;
      });
      await _listController.saveTaskLists(context);
      await _listController.saveTasks(newListName, context);
    }
  }

  /// Exibe um diálogo de confirmação para apagar uma lista de tarefas.
  Future<void> _confirmDeleteList(String listName) async {
    final confirm = await DialogService.showDeleteConfirmation(
      context,
      customMessage: 'Deseja apagar a lista "$listName"?',
    );

    if (confirm == true) {
      await _listController.deleteTaskList(listName, context);
      setState(() {});
      await _listController.saveTaskLists(context);
    }
  }

  /// Exibe um diálogo para editar o nome de uma lista de tarefas.
  Future<void> _editListName(String currentListName) async {
    final newName = await DialogService.showEditListDialog(context, currentListName, _listController.taskLists);

    if (newName != null && newName != currentListName) {
      setState(() {
        final index = _listController.taskLists.indexOf(currentListName);
        _listController.taskLists[index] = newName;

        if (_listController.activeTasks.containsKey(currentListName)) {
          _listController.activeTasks[newName] = _listController.activeTasks.remove(currentListName)!;
        }
        if (_listController.completedTasks.containsKey(currentListName)) {
          _listController.completedTasks[newName] = _listController.completedTasks.remove(currentListName)!;
        }

        if (_listController.selectedList == currentListName) {
          _listController.selectedList = newName;
        }
      });

      await _listController.saveTaskLists(context);
      await _listController.saveTasks(newName, context);
    }
  }

  /// Exibe um diálogo para editar uma tarefa.
  Future<void> _editTask(TaskModel task) async {
    final result = await DialogService.showEditTaskDialog(context, task);
    if (result != null && result['title']!.isNotEmpty) {
      final updatedTask = task.copyWith(title: result['title'], priority: result['priority']);
      setState(() {
        if (!task.isCompleted) {
          _taskController.updateTask(_listController.activeTasks[_listController.selectedList!]!, updatedTask);
        } else {
          _taskController.updateTask(_listController.completedTasks[_listController.selectedList!]!, updatedTask);
        }
      });
      await _listController.saveTasks(_listController.selectedList!, context);
    }
  }

  /// Exibe um diálogo para adicionar uma nova tarefa.
  Future<void> _addTask() async {
    if (_listController.selectedList == null) {
      SnackbarUtils.showError(context, 'Crie uma lista primeiro!');
      return;
    }

    final result = await DialogService.showAddTaskDialog(context);
    if (result != null && result['title']!.isNotEmpty) {
      setState(() {
        _taskController.addTask(
          _listController.activeTasks[_listController.selectedList!]!,
          TaskModel(title: result['title']!, priority: result['priority']!),
        );
      });
      await _listController.saveTasks(_listController.selectedList!, context);
    }
  }

  /// Seleciona uma lista de tarefas.
  void _selectList(String listName) {
    setState(() => _listController.selectedList = listName);
    _listController.loadTasks(listName, context);
    Navigator.pop(context);
  }

  /// Manipula o toque em uma tarefa, alternando entre seleção e edição.
  void _onTaskTap(TaskModel task) {
    setState(() {
      _taskController.onTaskTap(task, () => _editTask(task));
    });
  }

  /// Manipula o pressionamento longo em uma tarefa, ativando o modo de seleção.
  void _onTaskLongPress(TaskModel task) {
    setState(() {
      _taskController.onTaskLongPress(task);
    });
  }

  /// Deleta as tarefas selecionadas.
  Future<void> _deleteSelectedTasks() async {
    final confirm = await DialogService.showDeleteConfirmation(
      context,
      customMessage: 'Deseja apagar as tarefas selecionadas?',
    );
    if (confirm == true) {
      setState(() {
        _taskController.deleteSelectedTasks(
          _listController.activeTasks[_listController.selectedList!]!,
          _listController.completedTasks[_listController.selectedList!]!,
        );
      });
      await _listController.saveTasks(_listController.selectedList!, context);
    }
  }

  /// Seleciona ou desseleciona todas as tarefas da lista atual.
  void _selectAllTasks() {
    setState(() {
      _taskController.selectAllTasks(
        _listController.activeTasks[_listController.selectedList!]!,
        _listController.completedTasks[_listController.selectedList!]!,
      );
    });
  }

  /// Método para sair do aplicativo, realizando logout do usuário.
  void _exit() async {
    await AuthService().logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthScreen()), (route) => false);
    }
  }

  ///Construção da tela principal.
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadScreen();
    }
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          _listController.selectedList ?? 'Easy Tasks',
          style: const TextStyle(color: Colors.white, fontSize: 33),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        actions:
            _taskController.selectionMode
                ? [
                  IconButton(
                    icon: Icon(Icons.select_all),
                    tooltip: "Selecionar/Deselecionar todas",
                    onPressed: _selectAllTasks,
                  ),
                  IconButton(icon: Icon(Icons.delete), tooltip: "Apagar selecionadas", onPressed: _deleteSelectedTasks),
                ]
                : [],
      ),

      drawer: HomeDrawer(
        taskLists: _listController.taskLists,
        selectedList: _listController.selectedList,
        onSelectList: _selectList,
        onAddTaskList: _addTaskList,
        onEditListName: _editListName,
        onDeleteList: _confirmDeleteList,
        onExit: _exit,
      ),

      body: HomeBody(
        selectedList: _listController.selectedList,
        activeTasks: _listController.activeTasks[_listController.selectedList] ?? [],
        completedTasks: _listController.completedTasks[_listController.selectedList] ?? [],
        onToggleTask: _toggleTask,
        onDeleteTask: _confirmDelete,
        onEditTask: _editTask,
        selectionMode: _taskController.selectionMode,
        selectedTaskIds: _taskController.selectedTaskIds,
        onTaskTap: _onTaskTap,
        onTaskLongPress: _onTaskLongPress,
        onDeleteSelected: _deleteSelectedTasks,
        onSelectAll: _selectAllTasks,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
