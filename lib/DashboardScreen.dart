// dashboard_screen.dart
import 'package:flutter/material.dart';

import 'HabitTrackingScreen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with your actual data for habit progress
    List<bool> habitsProgress = [false, false, false, false, false, false, false, false, false];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Your Daily Habits',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 9, // Replace with the actual number of habits
                itemBuilder: (context, index) {
                  String habitTitle = getHabitTitle(index); // Replace this with your habit titles
                  bool isCompleted = habitsProgress[index]; // Replace this with your actual habit data
                  return HabitCard(habitTitle: habitTitle, isCompleted: isCompleted);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get habit titles based on index
  String getHabitTitle(int index) {
    // Replace this with your habit titles or use a list of habit titles
    List<String> habitTitles = [
      'Waking up early',
      'Journaling before bed',
      'Learning an online skill',
      'Exercising',
      'Sitting in silence',
      'Creating a proper sleep schedule',
      'Taking a 30-minute walk in nature',
      'Reading 10 pages a day',
      'Limiting screen time',
    ];
    return habitTitles[index];
  }
}

class HabitCard extends StatelessWidget {
  final String habitTitle;
  final bool isCompleted;

  const HabitCard({Key? key, required this.habitTitle, required this.isCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          isCompleted ? Icons.check_circle : Icons.circle_outlined,
          color: isCompleted ? Colors.green : Colors.grey,
        ),
        title: Text(habitTitle),
        // Add an onTap function to navigate to the habit tracking screen for more details
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitTrackingScreen(
              habitTitle: habitTitle)
            ),
          );
        },
      ),
    );
  }
}
