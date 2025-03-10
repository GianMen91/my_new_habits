import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:my_new_habits/widgets/greetings.dart';

@widgetbook.UseCase(name: 'Default', type: GreetingSection)
Widget buildGreetingSectionUseCase(BuildContext context) {
  return GreetingSection(currentHour: 18);
}
