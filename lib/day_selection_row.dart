import 'package:flutter/material.dart';

import 'costants/constants.dart';

class DaySelectionRow extends StatelessWidget {
  final int currentDayOfWeek;

  const DaySelectionRow({required this.currentDayOfWeek});



  @override
  Widget build(BuildContext context) {

    int currentDayOfWeek = DateTime.now().weekday;

    // Calculate the start and end dates for the week
    DateTime startDate =
    DateTime.now().subtract(Duration(days: currentDayOfWeek - 1));
    DateTime endDate = startDate.add(Duration(days: 6));

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < 7; i++)
          Container(
            width: 43,
            height: 71,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: (currentDayOfWeek == i + 1)
                  ? const Color(0xFFFFCCB4)
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      0, 10, 0, 0),
                  child: Text(
                    getDayName(i + 1),
                    style: TextStyle(
                      color: (currentDayOfWeek == i + 1)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0, 0, 0, 5),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (currentDayOfWeek == i + 1)
                          ? Colors.white
                          : null,
                    ),
                    alignment:
                    const AlignmentDirectional(0.00, 0.00),
                    child: Text(
                      getDayNumber(startDate, i + 1).toString(),
                      style: TextStyle(
                        color: (currentDayOfWeek == i + 1)
                            ? selectedColor
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ]
    )
    );
  }
  int getDayNumber(DateTime startDate, int dayOfWeek) {
    // Calculate the day number for the given day of the week
    int dayNumber = startDate.day + dayOfWeek - startDate.weekday;

    // If the calculated day number is less than 1, it means we are in the previous month
    // Adjust the day number accordingly
    if (dayNumber < 1) {
      DateTime previousMonth =
      startDate.subtract(Duration(days: startDate.day));
      dayNumber = previousMonth.day + dayNumber;
    }

    return dayNumber;
  }

  String getDayName(int dayNumber) {
    switch (dayNumber) {
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
