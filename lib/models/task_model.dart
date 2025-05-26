/// Modelo de Tarefa
class TaskModel {
  final String id;
  final String title;
  String priority;
  bool isCompleted;

  TaskModel({required this.title, this.priority = 'Sem Prioridade', this.isCompleted = false, String? id})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Construtor nomeado para criar uma instância de TaskModel a partir de um mapa.
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? '',
      priority: map['priority'] ?? 'Sem Prioridade',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  /// Método para converter a instância de TaskModel em um mapa.
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'priority': priority, 'isCompleted': isCompleted};
  }

  /// Método para criar uma cópia da instância de TaskModel com campos modificados.
  TaskModel copyWith({String? title, String? priority, bool? isCompleted}) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
