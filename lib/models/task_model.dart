/// Classe que representa uma tarefa no app
class TaskModel {
  /// ID único da tarefa (gerado automaticamente)
  final String id;

  /// Título da tarefa
  final String title;

  /// Prioridade (Sem Prioridade, Baixa, Média, Alta)
  String priority;

  /// Se a tarefa está concluída ou não
  bool isCompleted;

  /// Construtor principal
  /// Se não passar ID, gera um novo baseado no timestamp atual
  TaskModel({
    required this.title,
    this.priority = 'Sem Prioridade',
    this.isCompleted = false,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Cria uma tarefa a partir de um mapa de dados
  /// Usado para carregar do Firebase
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? '',
      priority: map['priority'] ?? 'Sem Prioridade',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  /// Converte a tarefa em um mapa de dados
  /// Usado para salvar no Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  /// Cria uma cópia da tarefa com alguns campos alterados
  /// Útil para editar uma tarefa existente
  TaskModel copyWith({String? title, String? priority, bool? isCompleted}) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
