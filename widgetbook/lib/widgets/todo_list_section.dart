import 'package:flutter/material.dart';
import 'package:my_new_habits/models/todo.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:my_new_habits/widgets/todo_list_section.dart';

@widgetbook.UseCase(name: 'Default', type: ToDoListSection)
Widget buildToDoListSectionUseCase(BuildContext context) {
  // Mock data for testing
  final todo1 = ToDo(
    id: 1,
    todoText: 'Complete the task 1',
    recordDate: '',
  );
  final todo2 = ToDo(
    id: 2,
    todoText: 'Complete the task 2',
    recordDate: '',
  );
  final favouriteHabitsList = [todo1, todo2];


  // Function to mock the onTap callback
  void handleToDoTapped(ToDo todo) {  }

  return ToDoListSection(favouriteHabitsList, handleToDoTapped);
}
