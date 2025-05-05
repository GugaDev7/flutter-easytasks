class Task {
  final String id;
  final String title;
  final String priority;
  bool isCompleted;

  Task({required this.title, this.priority = 'Sem Prioridade', this.isCompleted = false, String? id})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  factory Task.fromString(String taskString) {
    final parts = taskString.split('|');
    return Task(id: parts[0], title: parts[1], priority: parts[2], isCompleted: parts[3] == 'true');
  }

  @override
  String toString() {
    return '$id|$title|$priority|$isCompleted';
  }

  Task copyWith({String? title, String? priority, bool? isCompleted}) {
    return Task(
      id: id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
