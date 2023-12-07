import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:newmehabits2/todo_history.dart';
import 'todo.dart';
import 'widgets/todo_item.dart';
import 'database_helper.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key? key}) : super(key: key);

  final Color barBackgroundColor = Colors.grey.withOpacity(0.3);
  final Color barColor = Colors.lightBlue;
  final Color touchedBarColor = Colors.yellow;
  final Color touchedBarColorDarker = const Color(0x165318FF);
  List<ToDo> favouriteHabitsList = [];

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<ToDo> todosList = [];
  List<ToDoHistory> toDoHistory = [];
  String todayDate = '';

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  void initState() {
    _loadTodosFromDatabase();
    _loadTodayDate();
    _resetCheckboxesIfNewDay();
    super.initState();
  }

  Future<void> _loadTodosFromDatabase() async {
    final todos = await DatabaseHelper.instance.getTodos();
    final todoHistory = await DatabaseHelper.instance.getToDoHistory();
    setState(() {
      todosList = todos;
      toDoHistory = todoHistory;
    });
  }

  Future<void> _loadTodayDate() async {
    final now = DateTime.now();
    todayDate =
        "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year.toString()}";
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current day of the week (Monday is 1, Sunday is 7)
    int currentDayOfWeek = DateTime.now().weekday;

    // Calculate the start and end dates for the week
    DateTime startDate =
        DateTime.now().subtract(Duration(days: currentDayOfWeek - 1));
    DateTime endDate = startDate.add(Duration(days: 6));

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFFFFBF5),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          getGreeting(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
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
                                            ? const Color(0xFFFFCCB4)
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedIndex == 0) // Show main content only when index is 0
              Expanded(child: _buildMainContent()),
            if (_selectedIndex == 1) // Show to-do list only when index is 1
              Expanded(child: _buildToDoList()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.amber,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            backgroundColor: Colors.amber,
            label: 'To do List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1468b3),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildMainContent() {
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
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: '65',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 60,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
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
                    height: 16,
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

  Widget _buildToDoList() {
    List<ToDo> favouriteHabitsList =
    todosList.where((habit) => habit.isFavourite).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 20, 0, 0),
          child: Text(
            'HABITS',
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (ToDo todo in favouriteHabitsList)
                ToDoItem(
                  todo: todo,
                  onToDoChanged: _handleToDoChange,
                  onStartActivity: _handleStartActivity,
                ),
            ],
          ),
        ),
      ],
    );
  }



  void _handleToDoChange(ToDo todo) async {
    todo.isDone = !todo.isDone;
    await DatabaseHelper.instance.updateTodoStatus(todo);
    _loadTodosFromDatabase();
  }

  void _handleStartActivity(int id) async {
    //go to the related screen
  }

  void _resetCheckboxesIfNewDay() async {
    final todos = await DatabaseHelper.instance.getTodos();
    final now = DateTime.now();
    for (ToDo todo in todos) {
      final todoDate = DateTime.parse(todo.recordDate);
      if (todoDate.isBefore(DateTime(now.year, now.month, now.day))) {
        todo.isDone = false;
        await DatabaseHelper.instance.updateTodoStatus(todo);
      }
    }
    _loadTodosFromDatabase();
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColorDarker)
              : const BorderSide(color: Colors.lightBlue, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: widget.favouriteHabitsList.length.toDouble(),
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
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
      var uniqueIds = <int>{};

      for (var todo in toDoHistory) {
        var todoDate = DateTime.parse(todo.changeDate);
        var normalizedTodoDate =
            DateTime(todoDate.year, todoDate.month, todoDate.day);
        var normalizedDay = DateTime(day.year, day.month, day.day);

        if (normalizedTodoDate == normalizedDay) {
          uniqueIds.add(todo.id);
        }
      }

      completedCounts[day.weekday - 1] = uniqueIds.length;
    }

    // Generate BarChartGroupData list based on completedCounts
    var list = List.generate(7, (i) {
      return makeGroupData(i, completedCounts[i].toDouble(),
          isTouched: i == touchedIndex);
    });

    return list;
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
                  text: (rod.toY - 1).toString() +
                      " / " +
                      widget.favouriteHabitsList.length.toDouble().toString(),
                  style: TextStyle(
                    color: widget.touchedBarColor,
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

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.lightBlue,
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
