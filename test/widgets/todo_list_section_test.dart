import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_new_habits/widgets/todo_item.dart';
import 'package:my_new_habits/widgets/todo_list_section.dart'; // Adjust according to your file structure
import 'package:my_new_habits/models/todo.dart';

void main() {
  testWidgets(
      'ToDoListSection displays correct number of items and triggers onTap callback',
      (tester) async {
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

    bool isTapped = false;
    ToDo tappedToDo = todo1;

    // Function to mock the onTap callback
    void handleToDoTapped(ToDo todo) {
      isTapped = true;
      tappedToDo = todo; // Set tappedToDo to the tapped item
    }

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToDoListSection(favouriteHabitsList, handleToDoTapped),
        ),
      ),
    );

    // Verify that the correct number of to-do items is displayed
    expect(find.byType(ToDoItem), findsNWidgets(favouriteHabitsList.length));

    // Verify that the text displaying the number of to-dos is correct
    expect(find.text('You have 2 to do'), findsOneWidget);

    // Tap on the first ToDoItem
    await tester.tap(find.byType(ToDoItem).first);
    await tester.pump();

    // Verify that the onToDoTapped callback was triggered with the correct ToDo item
    expect(isTapped, true);
    expect(tappedToDo.todoText, 'Complete the task 1');
  });

  testWidgets(
      'ToDoListSection displays empty message when the to-do list is empty',
      (tester) async {
    // Empty list for testing
    final favouriteHabitsList = <ToDo>[];

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToDoListSection(favouriteHabitsList, (_) {}),
        ),
      ),
    );

    // Verify that the "Your todo list is empty!" message is displayed
    expect(find.text("Your todo list is empty!"), findsOneWidget);
  });
}
