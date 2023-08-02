// habit_tracking_screen.dart
import 'package:flutter/material.dart';

class HabitTrackingScreen extends StatefulWidget {
  final String habitTitle;

  HabitTrackingScreen({required this.habitTitle});

  @override
  _HabitTrackingScreenState createState() => _HabitTrackingScreenState();
}

class _HabitTrackingScreenState extends State<HabitTrackingScreen> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habitTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Did you complete this habit today?',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Checkbox(
              value: isCompleted,
              onChanged: (value) {
                setState(() {
                  isCompleted = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Save the completion status here to your data source
                // You can use a database, shared preferences, or any other storage method
                // For simplicity, we'll just show a snackbar indicating the completion status
                String message = isCompleted ? 'Habit completed!' : 'Habit not completed.';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
