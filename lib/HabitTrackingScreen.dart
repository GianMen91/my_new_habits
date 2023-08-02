import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class HabitTrackingScreen extends StatefulWidget {
  final String habitTitle;

  const HabitTrackingScreen({Key? key, required this.habitTitle, required bool isCompleted}) : super(key: key);

  @override
  _HabitTrackingScreenState createState() => _HabitTrackingScreenState();
}

class _HabitTrackingScreenState extends State<HabitTrackingScreen> {
  bool isCompleted = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabitsFromDatabase();
  }

  void _loadHabitsFromDatabase() async {
    List<Habit> habits = await _databaseHelper.getHabits();
    setState(() {
      _habits = habits;
      // Find the habit corresponding to the habit title
      Habit? selectedHabit = habits.firstWhere((habit) => habit.name == widget.habitTitle, orElse: () => Habit(name: widget.habitTitle, isCompleted: false));
      isCompleted = selectedHabit.isCompleted;
    });
  }

  void _updateHabitCompletionStatus(int habitId, bool isCompleted) async {
    await _databaseHelper.updateHabitCompletionStatus(habitId, isCompleted);
    _loadHabitsFromDatabase();

    // Pass the updated isCompleted status back to the DashboardScreen
    Navigator.pop(context, isCompleted);
  }

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
            const Text(
              'Did you complete this habit today?',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
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

                // Call the callback to update the isCompleted status in DashboardScreen
                _updateHabitCompletionStatus(0, isCompleted);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
