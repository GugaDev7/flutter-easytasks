import 'package:flutter/material.dart';
import 'package:flutter_easytasks/components/dropdownbutton_decoration.dart';
import 'package:flutter_easytasks/components/textformfield_decoration.dart';
import 'package:flutter_easytasks/screens/home/home_body.dart';
import 'package:flutter_easytasks/screens/home/home_drawer.dart';
import 'package:flutter_easytasks/utils/theme.dart';
import 'package:flutter_easytasks/widgets/confirmation_dialog.dart';
import '../../services/task_service.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../models/task.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  List<String> _taskLists = [];
  String? _selectedList;
  final Map<String, List<Task>> _activeTasks = {};
  final Map<String, List<Task>> _completedTasks = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadTaskLists();
    if (_selectedList != null) await _loadTasks(_selectedList!);
  }

  Future<void> _loadTaskLists() async {
    try {
      final lists = await _taskService.loadTaskLists();
      setState(() {
        _taskLists = lists;
        _selectedList = _taskLists.isNotEmpty ? _taskLists[0] : null;
      });
    } catch (e) {
      _showSnackBar('Erro ao carregar listas: $e');
    }
  }

  Future<void> _loadTasks(String listName) async {
    try {
      final tasks = await _taskService.loadTasks(listName);
      setState(() {
        _activeTasks[listName] = tasks['active']!;
        _completedTasks[listName] = tasks['completed']!;
        _sortTasks(_activeTasks[listName]!);
      });
    } catch (e) {
      _showSnackBar('Erro ao carregar tarefas: $e');
    }
  }

  Future<void> _saveTaskLists() async {
    try {
      await _taskService.saveTaskLists(_taskLists);
    } catch (e) {
      _showSnackBar('Erro ao salvar listas: $e');
    }
  }

  Future<void> _saveTasks(String listName) async {
    try {
      final allTasks = [...?_activeTasks[listName], ...?_completedTasks[listName]];
      await _taskService.saveTasks(listName, allTasks);
    } catch (e) {
      _showSnackBar('Erro ao salvar tarefas: $e');
    }
  }

  Future<void> _addTask(String title, String priority) async {
    if (_selectedList == null) return;

    setState(() {
      _activeTasks[_selectedList!]!.add(Task(title: title, priority: priority));
      _sortTasks(_activeTasks[_selectedList!]!);
    });
    await _saveTasks(_selectedList!);
  }

  Future<void> _removeTask(Task task) async {
    setState(() {
      _activeTasks[_selectedList!]?.remove(task);
      _completedTasks[_selectedList!]?.remove(task);
    });
    await _saveTasks(_selectedList!);
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        _activeTasks[_selectedList!]!.remove(task);
        _completedTasks[_selectedList!]!.add(task);
      } else {
        _completedTasks[_selectedList!]!.remove(task);
        _activeTasks[_selectedList!]!.add(task);
        _sortTasks(_activeTasks[_selectedList!]!);
      }
    });
    _saveTasks(_selectedList!);
  }

  void _sortTasks(List<Task> tasks) {
    tasks.sort((a, b) => _priorityValue(b.priority) - _priorityValue(a.priority));
  }

  int _priorityValue(String priority) {
    return switch (priority) {
      'Alta' => 4,
      'Média' => 3,
      'Baixa' => 2,
      _ => 1,
    };
  }

  Future<void> _confirmDelete(Task task) async {
    final confirm = await ConfirmationDialog.show(
      context: context,
      title: 'Apagar Tarefa',
      content: 'Deseja realmente apagar esta tarefa?',
      confirmText: 'Apagar',
    );

    if (confirm == true) await _removeTask(task);
  }

  Future<void> _addTaskList() async {
    final _formKey = GlobalKey<FormState>();
    String listName = '';

    final newListName = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Nova Lista'),
              content: Form(
                key: _formKey, // ①
                child: TextFormField(
                  onChanged: (value) => listName = value,
                  decoration: getInputDecoration("Insira o nome da Lista."),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Este campo não pode estar vazio.";
                    }
                    if (_taskLists.contains(value.trim())) {
                      return "Essa Lista já existe!";
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, listName.trim());
                    }
                  },
                  child: const Text('Criar'),
                ),
              ],
            );
          },
        );
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

  Future<void> _confirmDeleteList(String listName) async {
    final confirm = await ConfirmationDialog.show(
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

  Future<void> _editListNameDialog(String currentListName) async {
    final _formKey = GlobalKey<FormState>();
    String newName = currentListName;
    final _controller = TextEditingController(text: currentListName);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Renomear Lista'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) => newName = value,
              decoration: getInputDecoration("Insira o nome da Lista."),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Este campo não pode estar vazio.";
                }
                if (_taskLists.contains(value.trim())) {
                  return "Essa Lista já existe!";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
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

  Future<void> _editTaskDialog(Task task) async {
    final _controller = TextEditingController(text: task.title);
    String editedPriority = task.priority;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _controller, decoration: getInputDecoration('Título')),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: getInputDecoration(""),
                value: editedPriority,
                items:
                    const [
                      'Alta',
                      'Média',
                      'Baixa',
                      'Sem Prioridade',
                    ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (value) {
                  if (value != null) {
                    editedPriority = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                final editedTitle = _controller.text.trim();
                if (editedTitle.isNotEmpty) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final editedTitle = _controller.text.trim();

      final updatedTask = task.copyWith(title: editedTitle, priority: editedPriority);

      setState(() {
        _activeTasks[_selectedList!] =
            _activeTasks[_selectedList!]!.map((t) => t.id == task.id ? updatedTask : t).toList();
        _sortTasks(_activeTasks[_selectedList!]!);
      });

      _saveTasks(_selectedList!);
    }
  }

  void _selectTaskList(String listName) {
    setState(() => _selectedList = listName);
    _loadTasks(listName);
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(_selectedList ?? 'Minhas Tarefas', style: const TextStyle(color: Colors.white, fontSize: 33)),

        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
      ),
      drawer: HomeDrawer(
        taskLists: _taskLists,
        selectedList: _selectedList,
        onSelectList: _selectTaskList,
        onAddTaskList: _addTaskList,
        onEditListName: _editListNameDialog,
        onDeleteList: _confirmDeleteList,
      ),
      body: HomeBody(
        selectedList: _selectedList,
        activeTasks: _activeTasks[_selectedList] ?? [],
        completedTasks: _completedTasks[_selectedList] ?? [],
        onToggleTask: _toggleTask,
        onDeleteTask: _confirmDelete,
        onEditTask: _editTaskDialog,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskButton,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addTaskButton() {
    if (_selectedList == null) {
      _showSnackBar('Crie uma lista primeiro!');
    } else {
      // Diálogo para nova tarefa
      showDialog(
        context: context,
        builder: (context) {
          String title = '';
          String priority = 'Sem Prioridade';
          return AlertDialog(
            title: const Text('Nova Tarefa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(onChanged: (value) => title = value, decoration: getInputDecoration('Título')),

                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: getDropdownDecoration(""),
                  value: priority,
                  items:
                      [
                        'Alta',
                        'Média',
                        'Baixa',
                        'Sem Prioridade',
                      ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (value) => priority = value!,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              TextButton(
                onPressed: () {
                  if (title.isEmpty) {
                    Navigator.pop(context);
                    _showSnackBar("A Tarefa precisa de um nome!");
                    return;
                  }

                  if (title.isNotEmpty) {
                    _addTask(title, priority);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Adicionar'),
              ),
            ],
          );
        },
      );
    }
  }
}
