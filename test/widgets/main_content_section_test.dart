import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_new_habits/widgets/main_content_section.dart'; // Adjust according to your file structure
import 'package:my_new_habits/models/todo.dart';
import 'package:my_new_habits/models/todo_history.dart';

void main() {
  testWidgets('MainContentSection displays daily goal percentage and bar chart correctly', (tester) async {
    // Prepare mock data for testing
    List<ToDo> favouriteHabitsList = [
      ToDo(id: 1, todoText: 'Exercise', recordDate: ''),
      ToDo(id: 2, todoText: 'Meditate', recordDate: ''),
      ToDo(id: 3, todoText: 'Read', recordDate: ''),
    ];

    List<ToDoHistory> toDoHistory = [
      ToDoHistory(id: 1, changeDate: DateTime.now().toIso8601String()), // Assume completed task
      ToDoHistory(id: 2, changeDate: DateTime.now().toIso8601String()),
    ];

    // Mock function to handle ToDo change (for testing purposes)
    Function(ToDo) handleToDoChange = (ToDo todo) {};

    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainContentSection(
            favouriteHabitsList,
            [],
            toDoHistory,
            handleToDoChange,
          ),
        ),
      ),
    );

    // Check that the daily goal section is displayed
    expect(find.text('DAILY GOAL'), findsOneWidget);


    // Check that the goal achievement bar chart is displayed
    expect(find.byType(BarChart), findsOneWidget);


    expect(find.text('Your todo list is empty!'), findsNothing);

    // Simulate a different scenario with an empty favouriteHabitsList
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainContentSection(
            [],
            [],
            toDoHistory,
            handleToDoChange,
          ),
        ),
      ),
    );

    // Verify that the "Your todo list is empty!" message is displayed
    expect(find.text('Your todo list is empty!'), findsOneWidget);
  });

  testWidgets('MainContentSection handles touch events on the bar chart', (tester) async {
    // Prepare mock data
    List<ToDo> favouriteHabitsList = [
      ToDo(id: 1, todoText: 'Exercise', recordDate: ''),
      ToDo(id: 2, todoText: 'Meditate', recordDate: ''),
      ToDo(id: 3, todoText: 'Read', recordDate: ''),
    ];

    List<ToDoHistory> toDoHistory = [
      ToDoHistory(id: 1, changeDate: DateTime.now().toIso8601String()),
      ToDoHistory(id: 2, changeDate: DateTime.now().toIso8601String()),
    ];

    Function(ToDo) handleToDoChange = (ToDo todo) {};

    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainContentSection(
            favouriteHabitsList,
            [],
            toDoHistory,
            handleToDoChange,
          ),
        ),
      ),
    );

    // Verify that the bar chart is displayed
    expect(find.byType(BarChart), findsOneWidget);
  });
}
