import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_easytasks/models/task.dart';

void main() {
  // grupo de testes relacionados ao modelo Task
  group('Task Model Tests', () {
    // testa se a tarefa é criada com os valores corretos
    test('Task should be created with correct values', () {
      final now = DateTime.now(); // pega a data/hora atual
      final task = Task(
        // cria uma tarefa de teste
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        priority: TaskPriority.high,
        createdAt: now,
      );

      // verifica se cada campo tem o valor esperado
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.completed, false); // deve começar como não completada
      expect(task.priority, TaskPriority.high);
      expect(task.createdAt, now);
      expect(task.updatedAt, null); // não deve ter data de atualização ainda
    });

    // testa se consegue marcar uma tarefa como completada
    test('Task should be marked as completed', () {
      // cria uma tarefa simples
      final task = Task(id: '1', title: 'Test Task', createdAt: DateTime.now());

      // cria uma cópia da tarefa marcando como completada
      final completedTask = task.copyWith(completed: true);

      // verifica se a tarefa foi marcada como completada
      expect(completedTask.completed, true);
      // verifica se os outros campos continuam iguais
      expect(completedTask.title, task.title);
      expect(completedTask.id, task.id);
    });

    // testa se consegue converter a tarefa pra JSON e voltar
    test('Task should be converted to and from JSON', () {
      final now = DateTime.now();
      // cria uma tarefa pra teste
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        priority: TaskPriority.high,
        createdAt: now,
      );

      // converte pra JSON e depois volta pra Task
      final json = task.toJson();
      final taskFromJson = Task.fromJson(json);

      // verifica se a tarefa voltou igual
      expect(taskFromJson, task);
    });
  });
}
