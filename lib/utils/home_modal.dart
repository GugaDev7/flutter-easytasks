import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/theme.dart';

void showHomeModal(BuildContext context, Function(String, String) addTask) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.primaryColor,
    isDismissible: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    builder: (context) {
      return AddTaskModal(addTask: addTask);
    },
  );
}

class AddTaskModal extends StatelessWidget {
  final Function(String, String) addTask;

  const AddTaskModal({super.key, required this.addTask});

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameCtrl = TextEditingController();
    String _selectedPriority = 'Baixa';
    List<String> _priorities = ['Baixa', 'Média', 'Alta'];

    return Container(
      padding: EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Nova Tarefa", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, color: Colors.black),
                ),
              ],
            ),
            const Divider(),
            // Nome da Tarefa
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
            SizedBox(height: 10),
            // Dropdown de Prioridade
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              items:
                  _priorities.map((String priority) {
                    return DropdownMenuItem<String>(value: priority, child: Text(priority));
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _selectedPriority = newValue;
                }
              },
              decoration: InputDecoration(
                labelText: "Prioridade",
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.isNotEmpty) {
                  addTask(_nameCtrl.text, _selectedPriority);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(backgroundColor: Colors.red, content: Text("Por favor, insira um nome para a tarefa.")),
                  );
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
