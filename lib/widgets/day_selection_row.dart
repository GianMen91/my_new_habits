import 'package:flutter/material.dart';
import '../costants/constants.dart';

// This widget represents a row of buttons corresponding to the days of the week,
// allowing users to select the current day by highlighting it.
class DaySelectionRow extends StatelessWidget {
  final int
      currentDayOfWeek; // The current day of the week (1 for Monday, 7 for Sunday)

  const DaySelectionRow({super.key, required this.currentDayOfWeek});

  @override
  Widget build(BuildContext context) {
    // Calculate the start date of the week (Monday)
    DateTime startDate =
        DateTime.now().subtract(Duration(days: currentDayOfWeek - 1));

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0), // Top padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Space out the days equally
        children: List.generate(7, (index) {
          int dayOfWeek = index + 1; // Days range from 1 (Monday) to 7 (Sunday)
          bool isSelected = currentDayOfWeek ==
              dayOfWeek; // Check if this day is the selected one

          return Container(
            width: 43, // Width of each day box
            height: 71, // Height of each day box
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              // Circular edges for the day box
              color: isSelected
                  ? selectedColor
                  : null, // Highlight the selected day with a color
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Distribute items vertically
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    getDayName(dayOfWeek),
                    // Display the short name of the day (e.g., Mon, Tue)
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.black, // White text for selected day
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                  child: Container(
                    width: 35,
                    // Width of the circular number container
                    height: 35,
                    // Height of the circular number container
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Circle shape for the number container
                      color: isSelected
                          ? Colors.white
                          : null, // White background for the selected day
                    ),
                    alignment: Alignment.center,
                    // Center the number in the circle
                    child: Text(
                      getDayNumber(startDate, dayOfWeek).toString(),
                      // Display the day number (e.g., 1, 2, 3)
                      style: TextStyle(
                        color: isSelected
                            ? selectedColor
                            : Colors.black, // Color for the number
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Method to calculate the day number for a given day of the week (e.g., 1, 2, 3,...)
  int getDayNumber(DateTime startDate, int dayOfWeek) {
    DateTime targetDate = startDate
        .add(Duration(days: dayOfWeek - 1)); // Add days to get the target date
    return targetDate.day; // Return the day of the month (e.g., 1, 2, 3,...)
  }

  // Method to get the short name of the day of the week (Mon, Tue, Wed,...)
  String getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Mon'; // Monday
      case 2:
        return 'Tue'; // Tuesday
      case 3:
        return 'Wed'; // Wednesday
      case 4:
        return 'Thu'; // Thursday
      case 5:
        return 'Fri'; // Friday
      case 6:
        return 'Sat'; // Saturday
      case 7:
        return 'Sun'; // Sunday
      default:
        return ''; // Return an empty string for invalid day
    }
  }
}
