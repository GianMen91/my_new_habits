import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'costants/constants.dart';
import 'todo.dart';
import 'todo_history.dart';

class MainContentSection extends StatefulWidget {

  final List<ToDo> favouriteHabitsList;
  final List<ToDo> todosList;
  final List<ToDoHistory> toDoHistory;


  MainContentSection(this.favouriteHabitsList, this.todosList, this.toDoHistory);

  @override
  State<MainContentSection> createState() => _MainContentSectionState();
}

class _MainContentSectionState extends State<MainContentSection> {
  int touchedIndex = -1;

  final Color barBackgroundColor = Colors.grey.withOpacity(0.3);

  final Color touchedBarColor = Colors.yellow;

  final Color touchedBarColorDarker = const Color(0x165318FF);

  @override
  Widget build(BuildContext context) {
    var percentageValueOfAchieveDailyGoals = calculateDailyGoalPercentage();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 131,
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DAILY GOAL',
                            ),
                            RichText(
                              textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: percentageValueOfAchieveDailyGoals
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 60,
                                        color: Colors.black),
                                  ),
                                  const TextSpan(
                                    text: '%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 32,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 300, // Adjust the height as needed
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'GOAL ACHIEVED THIS WEEK',
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: BarChart(mainBarData()),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Monday';
                break;
              case 1:
                weekDay = 'Tuesday';
                break;
              case 2:
                weekDay = 'Wednesday';
                break;
              case 3:
                weekDay = 'Thursday';
                break;
              case 4:
                weekDay = 'Friday';
                break;
              case 5:
                weekDay = 'Saturday';
                break;
              case 6:
                weekDay = 'Sunday';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).round().toString() +
                      " / " +
                      widget.favouriteHabitsList.length.round().toString(),
                  style: TextStyle(
                    color: touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  List<BarChartGroupData> showingGroups() {
    // Initialize a list to hold completed todo counts for each day
    var completedCounts = List<int>.filled(7, 0);

    // Calculate the start and end dates for the past week (Monday to Sunday)
    final now = DateTime.now();
    final today = now.weekday;
    final lastMonday =
    now.subtract(Duration(days: today - 1 + (today == 7 ? 6 : 0)));
    final nextSunday = lastMonday.add(const Duration(days: 6));

    // Iterate through todos history and calculate completed tasks for each day of the past week
    for (var day = lastMonday;
    day.isBefore(nextSunday.add(const Duration(days: 1)));
    day = day.add(const Duration(days: 1))) {
      completedCounts[day.weekday - 1]  = calculateCompletedTaskPerDay(day);
    }

    // Generate BarChartGroupData list based on completedCounts
    var list = List.generate(7, (i) {
      return makeGroupData(i, completedCounts[i].toDouble(),
          isTouched: i == touchedIndex);
    });

    return list;
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color? barColor,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    barColor ??= selectedColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: touchedBarColorDarker)
              : const BorderSide(color: selectedColor, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: widget.favouriteHabitsList.length.toDouble(),
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  int calculateDailyGoalPercentage() {
    // Calculate the current day index (0 for Monday, 1 for Tuesday, ..., 6 for Sunday)
    //int currentDayIndex = DateTime.now().weekday - 1;

    // Get the completed task count for the current day
    int completedTasks = calculateCompletedTaskPerDay(DateTime.now());

    // Get the total number of tasks for the current day
    int totalTasks = widget.favouriteHabitsList.length;

    // Calculate the percentage
    double percentage =
    (totalTasks > 0) ? (completedTasks / totalTasks) * 100 : 0;

    // Check if percentage is finite before rounding
    if (percentage.isFinite) {
      return percentage.round();
    } else {
      return 0; // or any default value you prefer
    }
  }

  int calculateCompletedTaskPerDay(DateTime day) {
    var uniqueIds = <int>{};

    for (var todo in widget.toDoHistory) {
      var todoDate = DateTime.parse(todo.changeDate);
      var normalizedTodoDate =
      DateTime(todoDate.year, todoDate.month, todoDate.day);
      var normalizedDay = DateTime(day.year, day.month, day.day);

      if (normalizedTodoDate == normalizedDay) {
        uniqueIds.add(todo.id);
      }
    }

    return uniqueIds.length;
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: selectedColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
