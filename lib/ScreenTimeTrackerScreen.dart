// screen_time_tracker_screen.dart
import 'package:flutter/material.dart';

class ScreenTimeTrackerScreen extends StatefulWidget {
  @override
  _ScreenTimeTrackerScreenState createState() => _ScreenTimeTrackerScreenState();
}

class _ScreenTimeTrackerScreenState extends State<ScreenTimeTrackerScreen> {
  // Replace these sample data with actual data from your app or device
  Map<String, Duration> _screenTimeData = {
    'App 1': Duration(hours: 2, minutes: 30),
    'App 2': Duration(hours: 1, minutes: 45),
    'App 3': Duration(hours: 3, minutes: 15),
    // Add more app data as needed
  };

  // Total daily screen time limit (replace with your preferred limit)
  Duration _dailyScreenTimeLimit = Duration(hours: 5);

  // Calculate the total daily screen time
  Duration _calculateTotalScreenTime() {
    Duration totalScreenTime = Duration.zero;
    _screenTimeData.forEach((appName, duration) {
      totalScreenTime += duration;
    });
    return totalScreenTime;
  }

  // Calculate the remaining screen time for the day
  Duration _calculateRemainingScreenTime() {
    Duration totalScreenTime = _calculateTotalScreenTime();
    Duration remainingScreenTime = _dailyScreenTimeLimit - totalScreenTime;
    return remainingScreenTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Time Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Daily Screen Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '${_calculateTotalScreenTime().inHours} hours ${(_calculateTotalScreenTime().inMinutes % 60)} minutes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text(
              'Remaining Screen Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '${_calculateRemainingScreenTime().inHours} hours ${(_calculateRemainingScreenTime().inMinutes % 60)} minutes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement setting screen time limits or any other related actions
              },
              child: Text('Set Screen Time Limit'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement viewing app-specific screen time details or any other related actions
              },
              child: Text('View App Screen Time'),
            ),
          ],
        ),
      ),
    );
  }
}
