import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../costants/constants.dart';
import '../models/todo_test.dart';
import '../models/todo_history_test.dart';

class MainContentSection extends StatefulWidget {
  final List<ToDo> favouriteHabitsList;
  final List<ToDo> todosList;
  final List<ToDoHistory> toDoHistory;
  final Function(ToDo) handleToDoChange;

  const MainContentSection(
    this.favouriteHabitsList,
    this.todosList,
    this.toDoHistory,
    this.handleToDoChange, {
    Key? key,
  }) : super(key: key);

  @override
  State<MainContentSection> createState() => _MainContentSectionState();
}

class _MainContentSectionState extends State<MainContentSection> {
  int touchedIndex = -1;

  // Use a static color to reduce the cost of re-creating colors.
  final Color barBackgroundColor = Colors.grey.withOpacity(0.3);

  @override
  Widget build(BuildContext context) {
    var percentageValueOfAchieveDailyGoals = calculateDailyGoalPercentage();

    return SingleChildScrollView(
      child: widget.favouriteHabitsList.isNotEmpty
          ? Column(
              children: [
                _buildDailyGoalSection(percentageValueOfAchieveDailyGoals),
                _buildGoalAchievementBarChart(),
              ],
            )
          : _buildEmptyTodoMessage(),
    );
  }

  // Break down into smaller methods to increase readability.
  Widget _buildDailyGoalSection(int percentage) {
    return Container(
      height: 131,
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDailyGoalText(percentage),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyGoalText(int percentage) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DAILY GOAL'),
          Text(
            '$percentage%',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalAchievementBarChart() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('GOAL ACHIEVED THIS WEEK'),
            const SizedBox(height: 36),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BarChart(mainBarData()),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTodoMessage() {
    return const Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Your todo list is empty!",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  // Refactor to keep mainBarData clean and maintainable.
  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return _buildTooltipItem(group.x, rod);
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
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  BarTooltipItem _buildTooltipItem(int x, BarChartRodData rod) {
    String weekDay = _getWeekDayName(x);
    return BarTooltipItem(
      '$weekDay\n',
      const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      children: <TextSpan>[
        TextSpan(
          text:
              '${(rod.toY - 1).round()} / ${widget.favouriteHabitsList.length}',
          style: const TextStyle(
            color: touchedBarColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getWeekDayName(int index) {
    const weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekDays[index];
  }

  List<BarChartGroupData> showingGroups() {
    final completedCounts = _calculateCompletedTasksPerDayForWeek();

    return List.generate(7, (i) {
      return makeGroupData(i, completedCounts[i].toDouble(),
          isTouched: i == touchedIndex);
    });
  }

  List<int> _calculateCompletedTasksPerDayForWeek() {
    var completedCounts = List<int>.filled(7, 0);

    final now = DateTime.now();
    final lastMonday = now.subtract(Duration(days: now.weekday - 1));
    final nextSunday = lastMonday.add(const Duration(days: 6));

    for (var day = lastMonday;
        day.isBefore(nextSunday.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      completedCounts[day.weekday - 1] = calculateCompletedTaskPerDay(day);
    }

    return completedCounts;
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
    int completedTasks = calculateCompletedTaskPerDay(DateTime.now());
    int totalTasks = widget.favouriteHabitsList.length;
    double percentage =
        (totalTasks > 0) ? (completedTasks / totalTasks) * 100 : 0;
    return percentage.isFinite ? percentage.round() : 0;
  }

  int calculateCompletedTaskPerDay(DateTime day) {
    var uniqueIds = <int>{};

    for (var todo in widget.toDoHistory) {
      bool containSameID =
          widget.favouriteHabitsList.any((favTodo) => favTodo.id == todo.id);
      if (containSameID) {
        var todoDate = DateTime.parse(todo.changeDate);
        var normalizedTodoDate =
            DateTime(todoDate.year, todoDate.month, todoDate.day);
        var normalizedDay = DateTime(day.year, day.month, day.day);

        if (normalizedTodoDate == normalizedDay) {
          uniqueIds.add(todo.id);
        }
      }
    }

    return uniqueIds.length;
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Color(0xff7589a2),
    );
    String text = '';
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
    }
    return Text(text, style: style);
  }
}
