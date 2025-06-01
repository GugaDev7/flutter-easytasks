import 'package:equatable/equatable.dart';

// aqui define os níveis de prioridade que uma tarefa pode ter
enum TaskPriority { high, medium, low, none }

// essa é a classe que representa uma tarefa
// usa Equatable pra poder comparar se duas tarefas são iguais
class Task extends Equatable {
  // aqui são as informações que cada tarefa tem
  final String id; // id único da tarefa
  final String title; // título da tarefa
  final String description; // descrição mais detalhada
  final bool completed; // se já foi completada ou não
  final TaskPriority priority; // prioridade da tarefa
  final DateTime createdAt; // quando foi criada
  final DateTime?
  updatedAt; // quando foi atualizada pela última vez (pode ser nulo)

  // construtor da tarefa
  // os campos com required precisam ser informados sempre
  // os outros têm valores padrão se não forem informados
  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    this.priority = TaskPriority.none,
    required this.createdAt,
    this.updatedAt,
  });

  // esse método cria uma cópia da tarefa
  // útil quando quer mudar só algumas informações
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    TaskPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id, // se não passar novo id, mantém o atual
      title: title ?? this.title, // se não passar novo título, mantém o atual
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // converte a tarefa para um formato que pode ser salvo no banco
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'priority':
          priority.toString().split('.').last, // pega só o nome da prioridade
      'createdAt': createdAt.toIso8601String(), // converte data pra texto
      'updatedAt':
          updatedAt
              ?.toIso8601String(), // converte data pra texto se não for nula
    };
  }

  // cria uma tarefa a partir dos dados do banco
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description:
          json['description'] as String? ??
          '', // se não tiver descrição, usa vazio
      completed:
          json['completed'] as bool? ??
          false, // se não tiver completed, usa false
      priority: TaskPriority.values.firstWhere(
        // procura a prioridade pelo nome
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => TaskPriority.none, // se não achar, usa none
      ),
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ), // converte texto pra data
      updatedAt:
          json['updatedAt'] !=
                  null // se tiver data de atualização
              ? DateTime.parse(json['updatedAt'] as String) // converte pra data
              : null, // senão deixa nulo
    );
  }

  // lista de campos usados pra comparar se duas tarefas são iguais
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    completed,
    priority,
    createdAt,
    updatedAt,
  ];
}
