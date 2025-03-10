import 'package:flutter/material.dart';
import 'package:my_new_habits/models/todo.dart';
import 'package:my_new_habits/models/todo_history.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:my_new_habits/widgets/main_content_section.dart';

@widgetbook.UseCase(name: 'Default', type: MainContentSection)
Widget buildMainContentSectionUseCase(BuildContext context) {

  // Prepare mock data for testing
  List<ToDo> favouriteHabitsList = [
    ToDo(id: 1, todoText: 'Exercise', recordDate: ''),
    ToDo(id: 2, todoText: 'Meditate', recordDate: ''),
    ToDo(id: 3, todoText: 'Read', recordDate: ''),
  ];

  List<ToDoHistory> toDoHistory = [
    ToDoHistory(id: 1, changeDate: DateTime.now().toIso8601String()),
    // Assume completed task
    ToDoHistory(id: 2, changeDate: DateTime.now().toIso8601String()),
  ];

  // Mock function to handle ToDo change (for testing purposes)
  handleToDoChange(ToDo todo) {}

  return MainContentSection(
    favouriteHabitsList,
    const [],
    toDoHistory,
    handleToDoChange,
  );
}
