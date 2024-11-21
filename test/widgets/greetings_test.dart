import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_new_habits/widgets/greetings.dart';

void main() {
  testWidgets('GreetingSection displays the correct greeting based on time of day', (tester) async {
    // Test for "Good Morning" (hours 5-11)
    await testGreeting(tester, 8, 'Good Morning');  // Mocking 8 AM
    await testGreeting(tester, 5, 'Good Morning');  // Mocking 5 AM (boundary)
    await testGreeting(tester, 11, 'Good Morning'); // Mocking 11 AM (boundary)

    // Test for "Good Afternoon" (hours 12-17)
    await testGreeting(tester, 14, 'Good Afternoon'); // Mocking 2 PM
    await testGreeting(tester, 12, 'Good Afternoon'); // Mocking 12 PM (boundary)
    await testGreeting(tester, 17, 'Good Afternoon'); // Mocking 5 PM (boundary)

    // Test for "Good Evening" (hours 18-4)
    await testGreeting(tester, 18, 'Good Evening');  // Mocking 6 PM
    await testGreeting(tester, 20, 'Good Evening');  // Mocking 8 PM
    await testGreeting(tester, 23, 'Good Evening');  // Mocking 11 PM
    await testGreeting(tester, 4, 'Good Evening');   // Mocking 4 AM (boundary)
  });
}

// Helper function to test the greeting message
Future<void> testGreeting(WidgetTester tester, int hour, String expectedGreeting) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: GreetingSection(currentHour: hour),
      ),
    ),
  );

  // Verify if the correct greeting message is displayed
  expect(find.text(expectedGreeting), findsOneWidget);
}
