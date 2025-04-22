import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/theme.dart';

void showHomeModal(BuildContext context, Function(String) addTask) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.primaryColor,
    isDismissible: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    builder: (context) {
      return ExerciceModal(addTask: addTask);
    },
  );
}

class ExerciceModal extends StatelessWidget {
  final Function(String) addTask;

  const ExerciceModal({super.key, required this.addTask});

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameCtrl = TextEditingController();

    return Container(
      padding: EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nova Tarefa",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                ),
                const Divider(),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: "Qual o nome da Tarefa?",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.isNotEmpty) {
                  addTask(_nameCtrl.text); // Chama o callback
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: const Text("Adicionar Tarefa", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
