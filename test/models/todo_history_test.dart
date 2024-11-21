import 'package:flutter_test/flutter_test.dart';
import 'package:my_new_habits/models/todo_history.dart';


void main() {
  group('ToDoHistory Model Tests', () {
    test('toMap() should convert ToDoHistory object to Map', () {
      // Arrange
      final history = ToDoHistory(
        id: 1,
        changeDate: '2023-11-21',
      );

      // Act
      final historyMap = history.toMap();

      // Assert
      expect(historyMap, {
        'id': 1,
        'changeDate': '2023-11-21',
      });
    });

    test('fromMap() should convert Map to ToDoHistory object', () {
      // Arrange
      final historyMap = {
        'id': 1,
        'changeDate': '2023-11-21',
      };

      // Act
      final history = ToDoHistory.fromMap(historyMap);

      // Assert
      expect(history.id, 1);
      expect(history.changeDate, '2023-11-21');
    });

    test('toMap() and fromMap() should maintain data integrity', () {
      // Arrange
      final originalHistory = ToDoHistory(
        id: 2,
        changeDate: '2023-11-22',
      );

      // Act
      final historyMap = originalHistory.toMap();
      final recreatedHistory = ToDoHistory.fromMap(historyMap);

      // Assert
      expect(recreatedHistory.id, originalHistory.id);
      expect(recreatedHistory.changeDate, originalHistory.changeDate);
    });
  });
}
