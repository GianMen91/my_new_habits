import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class ExerciseTrackerScreen extends StatefulWidget {
  const ExerciseTrackerScreen({Key? key}) : super(key: key);

  @override
  _ExerciseTrackerScreenState createState() => _ExerciseTrackerScreenState();
}

class _ExerciseTrackerScreenState extends State<ExerciseTrackerScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ExerciseActivity> _exerciseActivities = [];
  int totalMinutes = 0;
  int exerciseGoal = 60; // Replace with the user's exercise goal (in minutes)

  @override
  void initState() {
    super.initState();
    _loadExerciseActivitiesFromDatabase();
  }

  void _loadExerciseActivitiesFromDatabase() async {
    List<ExerciseActivity> exerciseActivities =
        await _databaseHelper.getExerciseActivities();
    setState(() {
      _exerciseActivities = exerciseActivities;
    });
  }

  void _saveExerciseActivity(String activityType, int duration) async {
    String timestamp = DateTime.now().toIso8601String();
    ExerciseActivity exerciseActivity = ExerciseActivity(
      activityType: activityType,
      duration: duration,
      timestamp: timestamp,
    );
    await _databaseHelper.insertExerciseActivity(exerciseActivity);
    _loadExerciseActivitiesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Total Exercise Minutes Today',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$totalMinutes min',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Increment the total exercise minutes (for testing purposes)
                setState(() {
                  totalMinutes += 30;
                });
              },
              child: const Text('Log 30 Minutes'),
            ),
            const SizedBox(height: 16),
            Text(
              'Exercise Goal: $exerciseGoal min',
              style: const TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                // Reset the total exercise minutes (for testing purposes)
                setState(() {
                  totalMinutes = 0;
                });
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
