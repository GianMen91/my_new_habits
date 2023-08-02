// exercise_tracker_screen.dart
import 'package:flutter/material.dart';

class ExerciseTrackerScreen extends StatefulWidget {
  @override
  _ExerciseTrackerScreenState createState() => _ExerciseTrackerScreenState();
}

class _ExerciseTrackerScreenState extends State<ExerciseTrackerScreen> {
  int totalMinutes = 0;
  int exerciseGoal = 60; // Replace with the user's exercise goal (in minutes)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Exercise Minutes Today',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '$totalMinutes min',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Increment the total exercise minutes (for testing purposes)
                setState(() {
                  totalMinutes += 30;
                });
              },
              child: Text('Log 30 Minutes'),
            ),
            SizedBox(height: 16),
            Text(
              'Exercise Goal: $exerciseGoal min',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                // Reset the total exercise minutes (for testing purposes)
                setState(() {
                  totalMinutes = 0;
                });
              },
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
