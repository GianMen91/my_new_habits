import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_new_habits/helpers/database_helper.dart';
import 'package:my_new_habits/models/todo.dart';
import 'package:my_new_habits/models/todo_history.dart';
import 'package:my_new_habits/views/homepage_view.dart';
import 'package:my_new_habits/views/settings_view.dart';
import 'package:my_new_habits/widgets/main_content_section.dart';
import 'package:my_new_habits/widgets/todo_list_section.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper mockDbHelper;

  // Register fallback value for ToDo before tests run
  setUpAll(() {
    registerFallbackValue(ToDo(id: 0, todoText: '', recordDate: ''));
  });

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
  });

  testWidgets('Changing selected index navigates to Todo List', (tester) async {
    // Mock data
    final todos = [
      ToDo(
          id: 1,
          todoText: 'Test ToDo',
          isFavourite: true,
          recordDate: '2023-11-21'),
    ];
    final todoHistory = [
      ToDoHistory(id: 1, changeDate: '2023-11-21'),
    ];

    when(() => mockDbHelper.getTodos()).thenAnswer((_) async => todos);
    when(() => mockDbHelper.getToDoHistory())
        .thenAnswer((_) async => todoHistory);

    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePageView(),
      ),
    );

    // Initial state is home page (selected index = 0)
    expect(find.byType(MainContentSection), findsOneWidget);
    expect(find.byType(ToDoListSection), findsNothing);

    // Tap the "To-do List" bottom navigation bar item (index = 1)
    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();

    // Verify that the "To-do List" section is displayed
    expect(find.byType(MainContentSection), findsNothing);
    expect(find.byType(ToDoListSection), findsOneWidget);
  });

  testWidgets('Navigate to Settings View when settings icon is tapped',
      (tester) async {
    // Mock data
    final todos = [
      ToDo(
          id: 1,
          todoText: 'Test ToDo',
          isFavourite: true,
          recordDate: '2023-11-21'),
    ];
    final todoHistory = [
      ToDoHistory(id: 1, changeDate: '2023-11-21'),
    ];

    when(() => mockDbHelper.getTodos()).thenAnswer((_) async => todos);
    when(() => mockDbHelper.getToDoHistory())
        .thenAnswer((_) async => todoHistory);

    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePageView(),
      ),
    );

    // Tap the settings icon
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verify that the SettingsView is pushed onto the navigation stack
    expect(find.byType(SettingsView), findsOneWidget);
  });
}
