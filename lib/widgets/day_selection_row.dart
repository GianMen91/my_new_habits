import 'package:flutter/material.dart';
import '../costants/constants.dart';

class DaySelectionRow extends StatelessWidget {
  final int currentDayOfWeek;

  const DaySelectionRow({Key? key, required this.currentDayOfWeek})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the start date of the week (Monday)
    DateTime startDate =
        DateTime.now().subtract(Duration(days: currentDayOfWeek - 1));

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          int dayOfWeek = index + 1; // Days range from 1 (Monday) to 7 (Sunday)
          bool isSelected = currentDayOfWeek == dayOfWeek;

          return Container(
            width: 43,
            height: 71,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: isSelected ? selectedColor : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    getDayName(dayOfWeek),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.white : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getDayNumber(startDate, dayOfWeek).toString(),
                      style: TextStyle(
                        color: isSelected ? selectedColor : Colors.black,
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

  // Calculate the correct day number considering the start date of the week
  int getDayNumber(DateTime startDate, int dayOfWeek) {
    DateTime targetDate = startDate.add(Duration(days: dayOfWeek - 1));
    return targetDate.day;
  }

  // Get the short name of the day of the week
  String getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
