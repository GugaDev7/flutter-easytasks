/// Representa uma tarefa no aplicativo
class Task {
  final String id; // Identificador único baseado no timestamp
  final String title; // Título descritivo da tarefa
  final String priority; // Nível de prioridade: 'Alta', 'Média' ou 'Baixa'
  bool isCompleted; // Status de conclusão (true/false)

  /// Construtor principal
  Task({
    required this.title,
    this.priority = 'Baixa', // Valor padrão se não fornecido
    this.isCompleted = false,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(); // Gera ID único

  /// Converte uma string do SharedPreferences em um objeto Task
  factory Task.fromString(String taskString) {
    final parts = taskString.split('|');
    return Task(
      id: parts[0],
      title: parts[1],
      priority: parts[2],
      isCompleted: parts[3] == 'true', // Converte string para boolean
    );
  }

  /// Converte a Task em string para armazenamento
  @override
  String toString() {
    return '$id|$title|$priority|$isCompleted';
  }
}
