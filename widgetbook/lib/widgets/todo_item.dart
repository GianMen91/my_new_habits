import 'package:flutter/material.dart';
import 'package:my_new_habits/models/todo.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:my_new_habits/widgets/todo_item.dart';

@widgetbook.UseCase(name: 'Default', type: ToDoItem)
Widget buildToDoItemUseCase(BuildContext context) {

  // Mock data for testing
  final todo = ToDo(
    id: 1,
    todoText: 'Complete the task',
    recordDate: '',
  );

  void onToDoTapped(ToDo todo) { }

  return ToDoItem(todo: todo, onToDoTapped: onToDoTapped);
}
