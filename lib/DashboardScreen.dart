import 'package:flutter/material.dart';
import 'HabitTrackingScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Replace this with your actual data for habit progress
  List<bool> habitsProgress = [false, false, false, false, false, false, false, false, false];

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

  // Function to update the habit completion status when navigating back from HabitTrackingScreen
  void _updateHabitCompletionStatus(int index, bool isCompleted) {
    setState(() {
      habitsProgress[index] = isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: habitsProgress.length, // Replace with the actual number of habits
                itemBuilder: (context, index) {
                  String habitTitle = getHabitTitle(index); // Replace this with your habit titles
                  bool isCompleted = habitsProgress[index]; // Replace this with your actual habit data
                  return HabitCard(
                    habitTitle: habitTitle,
                    isCompleted: isCompleted,
                    onHabitCompletionChanged: (updatedCompletionStatus) {
                      // Update the habit completion status in DashboardScreen
                      _updateHabitCompletionStatus(index, updatedCompletionStatus);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final String habitTitle;
  final bool isCompleted;
  final ValueChanged<bool> onHabitCompletionChanged;

  const HabitCard({
    Key? key,
    required this.habitTitle,
    required this.isCompleted,
    required this.onHabitCompletionChanged,
  }) : super(key: key);

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
        onTap: () async {
          // Navigate to the HabitTrackingScreen and wait for the result (updated isCompleted status)
          bool? updatedIsCompleted = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => HabitTrackingScreen(
                habitTitle: habitTitle,
                isCompleted: isCompleted,
              ),
            ),
          );

          // Call the callback to update the isCompleted status in DashboardScreen
          if (updatedIsCompleted != null) {
            onHabitCompletionChanged(updatedIsCompleted);
          }
        },
      ),
    );
  }
}
