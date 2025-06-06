import 'package:firebase_auth/firebase_auth.dart';
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

  /// Função chamada ao sair do aplicativo.
  final VoidCallback onExit;

  /// Função chamada ao editar o nome de uma lista de tarefas.
  final Function(String) onEditListName;

  /// Função chamada ao deletar uma lista de tarefas.
  final Function(String) onDeleteList;

  /// Usuário autenticado atualmente.
  final user = FirebaseAuth.instance.currentUser;

  /// Construtor do HomeDrawer.
  HomeDrawer({
    super.key,
    required this.taskLists,
    required this.selectedList,
    required this.onSelectList,
    required this.onAddTaskList,
    required this.onEditListName,
    required this.onDeleteList,
    required this.onExit,
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
            title: const Text("Nova Lista", style: TextStyle(color: AppTheme.primaryColor)),
            onTap: onAddTaskList,
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.grey),

          /// Exibe o nome do usuário autenticado, se disponível.
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              user?.displayName ?? '',
              style: const TextStyle(color: AppTheme.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: AppTheme.primaryColor),
            title: const Text("Logout", style: TextStyle(color: AppTheme.primaryColor)),
            onTap: onExit,
          ),
        ],
      ),
    );
  }
}
