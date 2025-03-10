import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:my_new_habits/widgets/day_selection_row.dart';

@widgetbook.UseCase(name: 'Default', type: DaySelectionRow)
Widget buildDaySelectionRowUseCase(BuildContext context) {
  return DaySelectionRow(currentDayOfWeek:
  DateTime.now().weekday);
}
