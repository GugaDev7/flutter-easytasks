import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';

/// Widget que representa o menu lateral (Drawer) da tela inicial, exibindo as listas de tarefas.
class HomeDrawer extends StatelessWidget {
  /// Lista de nomes das listas de tarefas.
  final List<String> taskLists;

  /// Nome da lista de tarefas atualmente selecionada.
  final String? selectedList;

  /// Função chamada ao selecionar uma lista de tarefas.
  final Function(String) onSelectList;

  /// Função chamada ao adicionar uma nova lista de tarefas.
  final VoidCallback onAddTaskList;

  /// Função chamada ao editar o nome de uma lista de tarefas.
  final Function(String) onEditListName;

  /// Função chamada ao deletar uma lista de tarefas.
  final Function(String) onDeleteList;

  /// Construtor do HomeDrawer.
  const HomeDrawer({
    super.key,
    required this.taskLists,
    required this.selectedList,
    required this.onSelectList,
    required this.onAddTaskList,
    required this.onEditListName,
    required this.onDeleteList,
  });

  /// Constrói o widget HomeDrawer.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(color: AppTheme.primaryColor),
              padding: const EdgeInsets.all(0),
              margin: EdgeInsets.zero,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Minhas Listas',
                  style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          ...taskLists
              .map(
                (listName) => ListTile(
                  trailing: IconButton(
                    onPressed: () => onEditListName(listName),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  title: Text(listName),
                  selected: listName == selectedList,
                  onTap: () => onSelectList(listName),
                  onLongPress: () => onDeleteList(listName),
                ),
              )
              .toList(),
          ListTile(
            leading: const Icon(Icons.add, color: AppTheme.primaryColor),
            title: const Text('Criar Nova Lista', style: TextStyle(color: AppTheme.primaryColor)),
            onTap: onAddTaskList,
          ),
        ],
      ),
    );
  }
}
