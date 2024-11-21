import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_new_habits/widgets/todo_item.dart'; // Adjust according to your file structure
import 'package:my_new_habits/models/todo.dart';

void main() {
  testWidgets('ToDoItem displays correctly and triggers onTap callback', (tester) async {
    // Mock data for testing
    final todo = ToDo(
      id: 1,
      todoText: 'Complete the task',
      isDone: false, recordDate: '',
    );

    bool isTapped = false;

    // Function to mock the onTap callback
    void onToDoTapped(ToDo todo) {
      isTapped = true; // Set to true when the callback is triggered
    }

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToDoItem(todo: todo, onToDoTapped: onToDoTapped),
        ),
      ),
    );

    // Verify that the text of the ToDoItem is displayed correctly
    expect(find.text('Complete the task'), findsOneWidget);

    // Verify that the checkbox is unchecked (because isDone is false)
    expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);

    // Verify that the text is not decorated with a line-through (because isDone is false)
    Text textWidget = tester.widget(find.text('Complete the task'));
    expect(textWidget.style?.decoration, isNull);

    // Tap on the ToDoItem
    await tester.tap(find.byType(ListTile));
    await tester.pump();

    // Verify that the onToDoTapped callback was triggered
    expect(isTapped, true);
  });

  testWidgets('ToDoItem shows checked checkbox and line-through when isDone is true', (tester) async {
    // Mock data for testing
    final todo = ToDo(
      id: 2,
      todoText: 'Completed task',
      isDone: true, recordDate: '',
    );

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToDoItem(todo: todo, onToDoTapped: (_) {}),
        ),
      ),
    );

    // Verify that the text of the ToDoItem is displayed correctly
    expect(find.text('Completed task'), findsOneWidget);

    // Verify that the checkbox is checked (because isDone is true)
    expect(find.byIcon(Icons.check_box), findsOneWidget);

    // Verify that the text is decorated with a line-through (because isDone is true)
    Text textWidget = tester.widget(find.text('Completed task'));
    expect(textWidget.style?.decoration, TextDecoration.lineThrough);
  });
}
