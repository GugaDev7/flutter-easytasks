/// Representa uma tarefa no aplicativo
class Task {
  final String id; // Identificador único baseado no timestamp
  final String title; // Título descritivo da tarefa
  final String priority; // Nível de prioridade: 'Alta', 'Média', 'Baixa' ou 'Sem Prioridade'
  bool isCompleted; // Status de conclusão (true/false)

  /// Construtor principal
  Task({
    required this.title,
    this.priority = 'Sem Prioridade', // Valor padrão se não fornecido
    this.isCompleted = false,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Converte uma string do SharedPreferences em um objeto Task
  factory Task.fromString(String taskString) {
    final parts = taskString.split('|');
    return Task(id: parts[0], title: parts[1], priority: parts[2], isCompleted: parts[3] == 'true');
  }

  /// Converte a Task em string para armazenamento
  @override
  String toString() {
    return '$id|$title|$priority|$isCompleted';
  }

  /// Cria uma cópia da tarefa com possíveis alterações
  Task copyWith({String? title, String? priority, bool? isCompleted}) {
    return Task(
      id: id, // Mantém o mesmo ID
      title: title ?? this.title,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
