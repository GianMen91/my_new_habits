import 'package:flutter_test/flutter_test.dart';
import 'package:my_new_habits/models/todo.dart';

void main() {
  group('ToDo Model Tests', () {
    test('toMap() should convert ToDo object to Map', () {
      // Arrange
      final todo = ToDo(
        id: 1,
        todoText: 'Test ToDo',
        isDone: true,
        recordDate: '2023-11-21',
      );

      // Act
      final todoMap = todo.toMap();

      // Assert
      expect(todoMap, {
        'id': 1,
        'todoText': 'Test ToDo',
        'isDone': 1, // Boolean should be converted to int
        'isFavourite': 0,
        'recordDate': '2023-11-21',
      });
    });

    test('fromMap() should convert Map to ToDo object', () {
      // Arrange
      final todoMap = {
        'id': 1,
        'todoText': 'Test ToDo',
        'isDone': 1, // Integer representing true
        'isFavourite': 0, // Integer representing false
        'recordDate': '2023-11-21',
      };

      // Act
      final todo = ToDo.fromMap(todoMap);

      // Assert
      expect(todo.id, 1);
      expect(todo.todoText, 'Test ToDo');
      expect(todo.isDone, true); // Integer 1 should be converted to true
      expect(todo.isFavourite, false); // Integer 0 should be converted to false
      expect(todo.recordDate, '2023-11-21');
    });

    test('toMap() and fromMap() should maintain data integrity', () {
      // Arrange
      final originalToDo = ToDo(
        id: 2,
        todoText: 'Another Test ToDo',
        isFavourite: true,
        recordDate: '2023-11-22',
      );

      // Act
      final todoMap = originalToDo.toMap();
      final recreatedToDo = ToDo.fromMap(todoMap);

      // Assert
      expect(recreatedToDo.id, originalToDo.id);
      expect(recreatedToDo.todoText, originalToDo.todoText);
      expect(recreatedToDo.isDone, originalToDo.isDone);
      expect(recreatedToDo.isFavourite, originalToDo.isFavourite);
      expect(recreatedToDo.recordDate, originalToDo.recordDate);
    });
  });
}
