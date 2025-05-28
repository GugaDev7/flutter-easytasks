import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easytasks/controllers/task_manager.dart';
import 'package:flutter_easytasks/screens/auth/auth_screen.dart';
import 'package:flutter_easytasks/screens/home/home_body.dart';
import 'package:flutter_easytasks/screens/home/home_drawer.dart';
import 'package:flutter_easytasks/screens/load_screen.dart';
import 'package:flutter_easytasks/services/auth_service.dart';
import 'package:flutter_easytasks/utils/snackbar_utils.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';
import 'package:flutter_easytasks/widgets/app_dialog.dart';
import '../../services/task_service.dart';
import '../../models/task_model.dart';

/// Tela principal do aplicativo, responsável por gerenciar listas e tarefas.
class HomeScreen extends StatefulWidget {
  HomeScreen(BuildContext context, {super.key});

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
  final Map<String, List<TaskModel>> _activeTasks = {};

  /// Mapa de tarefas concluídas por lista.
  final Map<String, List<TaskModel>> _completedTasks = {};

  /// Modo de seleção múltipla.
  bool _selectionMode = false;

  /// IDs das tarefas selecionadas.
  Set<String> _selectedTaskIds = {};

  /// Controlador do serviço de autenticação.
  bool _isLoading = true;

  /// Chave global para o Scaffold, usada para exibir o Snackbar.
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
    await _loadTaskLists();
    if (_selectedList != null) await _loadTasks(_selectedList!);
    setState(() => _isLoading = false);
  }

  /// Carrega as listas de tarefas do serviço.
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

  /// Salva as listas de tarefas no serviço.
  Future<void> _saveTaskLists() async {
    try {
      await _taskService.saveTaskLists(_taskLists);
    } catch (e) {
      SnackbarUtils.showError(context, 'Erro ao salvar listas: $e');
    }
  }

  /// Salva as tarefas de uma lista específica no serviço.
  Future<void> saveTasks(String listName) async {
    try {
      final allTasks = [...?_activeTasks[listName], ...?_completedTasks[listName]];
      await _taskService.saveTasks(listName, allTasks);
    } catch (e) {
      SnackbarUtils.showError(context, 'Erro ao salvar tarefas: $e');
    }
  }

  /// Alterna o status de conclusão de uma tarefa.
  void _toggleTask(TaskModel task) {
    setState(() {
      TaskManager.toggleTask(
        task: task,
        activeTasks: _activeTasks[_selectedList!]!,
        completedTasks: _completedTasks[_selectedList!]!,
      );
    });
    saveTasks(_selectedList!);
  }

  /// Exibe um diálogo de confirmação para apagar uma tarefa.
  Future<void> _confirmDelete(TaskModel task) async {
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
      await saveTasks(_selectedList!);
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
      await saveTasks(newListName);
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
      await _taskService.deleteTaskList(listName);
      setState(() {
        _taskLists.remove(listName);
        _activeTasks.remove(listName);
        _completedTasks.remove(listName);
        _selectedList = _taskLists.isNotEmpty ? _taskLists[0] : null;
      });
      await _saveTaskLists();
      if (_selectedList != null) await saveTasks(_selectedList!);
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
      await saveTasks(newName);
    }
  }

  /// Exibe um diálogo para editar uma tarefa.
  Future<void> _editTaskDialog(TaskModel task) async {
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
      if (!task.isCompleted) {
        TaskManager.updateTask(_activeTasks[_selectedList!]!, updatedTask);
      } else {
        TaskManager.updateTask(_completedTasks[_selectedList!]!, updatedTask);
      }
    });
    await saveTasks(_selectedList!);
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
            TaskModel(title: result['title']!, priority: result['priority']!),
          );
        });
        await saveTasks(_selectedList!);
      } else if (result != null && result['title']!.isEmpty) {
        SnackbarUtils.showError(context, "A Tarefa precisa de um nome!");
      }
    }
  }

  /// Seleciona uma lista de tarefas.
  void _selectTaskList(String listName) {
    setState(() => _selectedList = listName);
    _loadTasks(listName);
    Navigator.pop(context);
  }

  /// Manipula o toque em uma tarefa, alternando entre seleção e edição.
  void _onTaskTap(TaskModel task) {
    if (_selectionMode) {
      setState(() {
        if (_selectedTaskIds.contains(task.id)) {
          _selectedTaskIds.remove(task.id);
          if (_selectedTaskIds.isEmpty) _selectionMode = false;
        } else {
          _selectedTaskIds.add(task.id);
        }
      });
    } else {
      _editTaskDialog(task);
    }
  }

  /// Manipula o pressionamento longo em uma tarefa, ativando o modo de seleção.
  void _onTaskLongPress(TaskModel task) {
    setState(() {
      _selectionMode = true;
      _selectedTaskIds.add(task.id);
    });
  }

  /// Deleta as tarefas selecionadas.
  Future<void> _deleteSelectedTasks() async {
    final confirm = await AppDialog.showConfirmation(
      context: context,
      title: 'Apagar Tarefas',
      content: 'Deseja apagar as tarefas selecionadas?',
      confirmText: 'Apagar',
    );
    if (confirm == true) {
      setState(() {
        _activeTasks[_selectedList!]?.removeWhere((t) => _selectedTaskIds.contains(t.id));
        _completedTasks[_selectedList!]?.removeWhere((t) => _selectedTaskIds.contains(t.id));
        _selectedTaskIds.clear();
        _selectionMode = false;
      });
      await saveTasks(_selectedList!);
    }
  }

  /// Seleciona ou desseleciona todas as tarefas da lista atual.
  void _selectAllTasks() {
    setState(() {
      final totalTasks = (_activeTasks[_selectedList!]?.length ?? 0) + (_completedTasks[_selectedList!]?.length ?? 0);
      if (_selectedTaskIds.length == totalTasks) {
        _selectedTaskIds.clear();
        _selectionMode = false;
      } else {
        _selectedTaskIds = {
          ...?_activeTasks[_selectedList!]?.map((t) => t.id),
          ...?_completedTasks[_selectedList!]?.map((t) => t.id),
        };
        _selectionMode = true;
      }
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
        title: Text(_selectedList ?? 'Easy Tasks', style: const TextStyle(color: Colors.white, fontSize: 33)),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        actions:
            _selectionMode
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
        taskLists: _taskLists,
        selectedList: _selectedList,
        onSelectList: _selectTaskList,
        onAddTaskList: _addTaskList,
        onEditListName: _editListNameDialog,
        onDeleteList: _confirmDeleteList,
        onExit: _exit,
      ),

      body: HomeBody(
        selectedList: _selectedList,
        activeTasks: _activeTasks[_selectedList] ?? [],
        completedTasks: _completedTasks[_selectedList] ?? [],
        onToggleTask: _toggleTask,
        onDeleteTask: _confirmDelete,
        onEditTask: _editTaskDialog,
        selectionMode: _selectionMode,
        selectedTaskIds: _selectedTaskIds,
        onTaskTap: _onTaskTap,
        onTaskLongPress: _onTaskLongPress,
        onDeleteSelected: _deleteSelectedTasks,
        onSelectAll: _selectAllTasks,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskButton,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
