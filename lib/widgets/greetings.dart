import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  final int
      currentHour; // The current hour of the day (e.g., 8 for 8 AM, 15 for 3 PM)

  const GreetingSection({Key? key, required this.currentHour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the appropriate greeting message based on the current hour
    final greetingMessage = getGreeting(currentHour);

    return Text(
      greetingMessage, // Display the greeting message
      style: const TextStyle(
        fontFamily: 'Niconne',
        // Use the custom 'Niconne' font for the greeting text
        fontSize: 32,
        // Font size for the greeting
        fontWeight: FontWeight.bold, // Make the text bold
      ),
    );
  }

  // Get the appropriate greeting message based on the current hour
  String getGreeting(int hour) {
    // Return different greeting based on the time of day
    if (hour >= 5 && hour < 12) {
      return 'Good Morning'; // Morning (5 AM - 12 PM)
    } else if (hour >= 12 && hour < 18) {
      return 'Good Afternoon'; // Afternoon (12 PM - 6 PM)
    } else {
      return 'Good Evening'; // Evening (6 PM - 5 AM)
    }
  }
}
