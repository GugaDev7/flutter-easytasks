import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/theme.dart';
import '../services/task_service.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/confirmation_dialog.dart';
import '../models/task.dart';

/// Tela principal do aplicativo com todas as funcionalidades
class HomeScreen extends StatefulWidget {
  final String name; // Nome do usuário (pode ser usado futuramente)

  HomeScreen({super.key, required this.name});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService(); // Instância do serviço
  List<String> _taskLists = []; // Nomes das listas ("Trabalho", "Casa", etc.)
  String? _selectedList; // Lista atualmente selecionada
  final Map<String, List<Task>> _activeTasks = {}; // Tarefas não concluídas
  final Map<String, List<Task>> _completedTasks = {}; // Tarefas concluídas

  // ================ CICLO DE VIDA ================
  @override
  void initState() {
    super.initState();
    _initializeData(); // Carrega dados ao iniciar
  }

  /// Inicializa dados necessários
  Future<void> _initializeData() async {
    await _loadTaskLists(); // Carrega listas
    if (_selectedList != null) await _loadTasks(_selectedList!); // Carrega tarefas
  }

  // ================ OPERAÇÕES DE DADOS ================
  /// Carrega todas as listas salvas
  Future<void> _loadTaskLists() async {
    try {
      final lists = await _taskService.loadTaskLists();
      setState(() {
        _taskLists = lists;
        // Seleciona primeira lista se existir
        _selectedList = _taskLists.isNotEmpty ? _taskLists[0] : null;
      });
    } catch (e) {
      _showSnackBar('Erro ao carregar listas: $e'); // Feedback visual
    }
  }

  /// Carrega tarefas de uma lista específica
  Future<void> _loadTasks(String listName) async {
    try {
      final tasks = await _taskService.loadTasks(listName);
      setState(() {
        _activeTasks[listName] = tasks['active']!; // Atribui tarefas ativas
        _completedTasks[listName] = tasks['completed']!; // Atribui concluídas
        _sortTasks(_activeTasks[listName]!); // Ordena por prioridade
      });
    } catch (e) {
      _showSnackBar('Erro ao carregar tarefas: $e');
    }
  }

  /// Salva os nomes das listas
  Future<void> _saveTaskLists() async {
    try {
      await _taskService.saveTaskLists(_taskLists);
    } catch (e) {
      _showSnackBar('Erro ao salvar listas: $e');
    }
  }

  /// Salva todas as tarefas da lista atual
  Future<void> _saveTasks(String listName) async {
    try {
      // Combina tarefas ativas e concluídas
      final allTasks = [...?_activeTasks[listName], ...?_completedTasks[listName]];
      await _taskService.saveTasks(listName, allTasks);
    } catch (e) {
      _showSnackBar('Erro ao salvar tarefas: $e');
    }
  }

  // ================ LÓGICA DE NEGÓCIO ================
  /// Adiciona nova tarefa à lista atual
  Future<void> _addTask(String title, String priority) async {
    if (_selectedList == null) return; // Valida lista selecionada

    setState(() {
      _activeTasks[_selectedList!]!.add(Task(title: title, priority: priority));
      _sortTasks(_activeTasks[_selectedList!]!); // Reordena
    });
    await _saveTasks(_selectedList!); // Persiste
  }

  /// Remove uma tarefa específica
  Future<void> _removeTask(Task task) async {
    setState(() {
      // Remove de ambas as listas (ativa/concluída)
      _activeTasks[_selectedList!]?.remove(task);
      _completedTasks[_selectedList!]?.remove(task);
    });
    await _saveTasks(_selectedList!);
  }

  /// Alterna status de conclusão da tarefa
  void _toggleTask(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted; // Inverte status
      if (task.isCompleted) {
        // Move para concluídas
        _activeTasks[_selectedList!]!.remove(task);
        _completedTasks[_selectedList!]!.add(task);
      } else {
        // Move para ativas
        _completedTasks[_selectedList!]!.remove(task);
        _activeTasks[_selectedList!]!.add(task);
        _sortTasks(_activeTasks[_selectedList!]!); // Reordena
      }
    });
    _saveTasks(_selectedList!);
  }

  /// Ordena tarefas por prioridade (Alta > Média > Baixa)
  void _sortTasks(List<Task> tasks) {
    tasks.sort((a, b) => _priorityValue(b.priority) - _priorityValue(a.priority));
  }

  /// Retorna valor numérico para prioridades
  int _priorityValue(String priority) {
    return switch (priority) {
      'Alta' => 4,
      'Média' => 3,
      'Baixa' => 2,
      _ => 1,
    };
  }

  // ================ INTERAÇÕES/DIÁLOGOS ================
  /// Solicita confirmação para excluir tarefa
  Future<void> _confirmDelete(Task task) async {
    final confirm = await ConfirmationDialog.show(
      context: context,
      title: 'Apagar Tarefa',
      content: 'Deseja realmente apagar esta tarefa?',
      confirmText: 'Apagar',
    );

    if (confirm == true) await _removeTask(task);
  }

  /// Diálogo para criar nova lista
  Future<void> _addTaskList() async {
    final newListName = await showDialog<String>(
      context: context,
      builder: (context) {
        String listName = '';
        return AlertDialog(
          title: const Text('Nova Lista'),
          content: TextField(
            onChanged: (value) => listName = value,
            decoration: const InputDecoration(hintText: "Nome da lista", border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(context, listName), child: const Text('Criar')),
          ],
        );
      },
    );

    if (_taskLists.contains(newListName)) {
      Navigator.pop(context);
      _showSnackBar("Já existe uma tarefa com esse nome!");
      return;
    }

    if (newListName != null && newListName.isNotEmpty) {
      setState(() {
        _taskLists.add(newListName);
        _activeTasks[newListName] = []; // Inicializa lista vazia
        _completedTasks[newListName] = [];
        _selectedList = newListName; // Seleciona nova lista
      });
      await _saveTaskLists();
      await _saveTasks(newListName);
    }
  }

  /// Confirma exclusão de lista
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
        // Seleciona nova lista ou define como null
        _selectedList = _taskLists.isNotEmpty ? _taskLists[0] : null;
      });
      await _saveTaskLists();
      if (_selectedList != null) await _saveTasks(_selectedList!);
    }
  }

  /// Seleciona lista pelo menu
  void _selectTaskList(String listName) {
    setState(() => _selectedList = listName);
    _loadTasks(listName); // Carrega tarefas da nova lista
    Navigator.pop(context); // Fecha o drawer
  }

  /// Exibe mensagem temporária na parte inferior
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ================ CONSTRUÇÃO DA UI ================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: FittedBox(
          fit: BoxFit.scaleDown, // Reduz o texto para caber
          child: Text(
            _selectedList ?? 'Minhas Tarefas',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 33, // Tamanho máximo (será reduzido se necessário)
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleFABPress,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Constrói o menu lateral (Drawer)
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppTheme.backgroudColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100, // Altura ajustada
            child: DrawerHeader(
              decoration: BoxDecoration(color: AppTheme.primaryColor),
              padding: const EdgeInsets.all(20),
              margin: EdgeInsets.zero,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Listas de Tarefas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: const Color.fromARGB(87, 0, 0, 0), offset: const Offset(1, 1), blurRadius: 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Lista de listas existentes
          ..._taskLists.map(
            (listName) => ListTile(
              title: Text(listName),
              selected: listName == _selectedList, // Destaca selecionada
              onTap: () => _selectTaskList(listName),
              onLongPress: () => _confirmDeleteList(listName), // Exclui lista
            ),
          ),
          const Divider(),
          // Botão para nova lista
          ListTile(leading: const Icon(Icons.add), title: const Text('Criar Nova Lista'), onTap: _addTaskList),
        ],
      ),
    );
  }

  /// Constrói o corpo principal da tela
  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child:
          _selectedList == null
              ? _buildEmptyState() // Tela vazia
              : _buildTaskLists(), // Lista de tarefas
    );
  }

  /// Tela quando nenhuma lista está selecionada
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Nenhuma lista selecionada', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            child: const Text('Selecionar Lista'),
          ),
        ],
      ),
    );
  }

  /// Lista de tarefas dividida em seções
  Widget _buildTaskLists() {
    final active = _activeTasks[_selectedList] ?? [];
    final completed = _completedTasks[_selectedList] ?? [];

    return ListView(
      children: [
        if (active.isNotEmpty) _buildTaskSection('Tarefas Ativas', active),
        if (completed.isNotEmpty) _buildTaskSection('Tarefas Concluídas', completed),
      ],
    );
  }

  /// Seção de tarefas com título
  Widget _buildTaskSection(String title, List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        ),
        // Lista de tarefas usando o widget personalizado
        ...tasks.map((task) => TaskListTile(task: task, onToggle: _toggleTask, onDelete: _confirmDelete)),
      ],
    );
  }

  /// Manipula clique no botão de adicionar
  void _handleFABPress() {
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
                TextField(
                  onChanged: (value) => title = value,
                  decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
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
