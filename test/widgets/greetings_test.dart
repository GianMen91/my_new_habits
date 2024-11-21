import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final greetingMessage = getGreeting();

    return Text(
      greetingMessage,
      style: const TextStyle(
        fontFamily: 'Niconne',
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Get the appropriate greeting based on the time of day
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
