import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/home_modal.dart';
import 'package:flutter_easytasks/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = prefs.getStringList('tasks') ?? [];
    setState(() {
      _tasks = taskStrings.map((task) => Task(title: task)).toList();
    });
  }

  Future<void> _addTask(String task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks.add(Task(title: task));
    });
    await prefs.setStringList('tasks', _tasks.map((task) => task.title).toList());
  }

  Future<void> _removeTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks.removeAt(index);
    });
    await prefs.setStringList('tasks', _tasks.map((task) => task.title).toList());
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        _tasks.remove(task);
        _tasks.add(task);
      }
    });
  }

  Future<void> _confirmDelete(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Apagar Tarefa'),
            content: Text('Você realmente deseja apagar esta tarefa?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Não')),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Sim')),
            ],
          ),
    );

    if (confirm == true) {
      _removeTask(index);
    }
  }

  void _openModal() {
    showHomeModal(context, _addTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openModal,
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
                    child: ListTile(
                      title: Text(
                        _tasks[index].title,
                        style: TextStyle(
                          decoration: _tasks[index].isCompleted ? TextDecoration.lineThrough : null,
                          color: _tasks[index].isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      trailing: Checkbox(
                        value: _tasks[index].isCompleted,
                        onChanged: (bool? value) {
                          _toggleTask(_tasks[index]);
                        },
                      ),
                      onLongPress: () => _confirmDelete(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}
