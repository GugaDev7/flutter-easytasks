/// Representa uma tarefa individual com título, prioridade e status de conclusão.
class Task {
  /// Identificador único da tarefa.
  final String id;

  /// Título da tarefa.
  final String title;

  /// Prioridade da tarefa (Alta, Média, Baixa, Sem Prioridade).
  final String priority;

  /// Indica se a tarefa está concluída.
  bool isCompleted;

  /// Cria uma nova tarefa.
  Task({required this.title, this.priority = 'Sem Prioridade', this.isCompleted = false, String? id})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Cria uma tarefa a partir de uma string serializada.
  factory Task.fromString(String taskString) {
    final parts = taskString.split('|');
    return Task(id: parts[0], title: parts[1], priority: parts[2], isCompleted: parts[3] == 'true');
  }

  @override
  String toString() {
    return '$id|$title|$priority|$isCompleted';
  }

  /// Retorna uma cópia da tarefa com novos valores.
  Task copyWith({String? title, String? priority, bool? isCompleted}) {
    return Task(
      id: id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
