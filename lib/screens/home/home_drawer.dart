import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/theme.dart';

class HomeDrawer extends StatelessWidget {
  final List<String> taskLists;
  final String? selectedList;
  final Function(String) onSelectList;
  final VoidCallback onAddTaskList;
  final Function(String) onEditListName; // Adicionado
  final Function(String) onDeleteList;

  const HomeDrawer({
    super.key,
    required this.taskLists,
    required this.selectedList,
    required this.onSelectList,
    required this.onAddTaskList,
    required this.onEditListName, // Adicionado
    required this.onDeleteList,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroudColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100, // Altura ajustada
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
                  selected: listName == selectedList, // Destaca selecionada
                  onTap: () => onSelectList(listName),
                  onLongPress: () => onDeleteList(listName), // Exclui lista
                ),
              )
              .toList(),
          ListTile(leading: const Icon(Icons.add), title: const Text('Criar Nova Lista'), onTap: onAddTaskList),
        ],
      ),
    );
  }
}
