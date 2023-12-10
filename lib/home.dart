import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'DaySelectionRow.dart';
import 'GreetingSection.dart';
import 'MainContentSection.dart';
import 'ToDoListSection.dart';
import 'costants/constants.dart';
import 'todo.dart';
import 'widgets/todo_item.dart';
import 'database_helper.dart';
import 'settings.dart';
import 'todo_history.dart';

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key? key}) : super(key: key);

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
      widget.favouriteHabitsList =
          todosList.where((habit) => habit.isFavourite).toList();
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
      backgroundColor: backgroundColor,
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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GreetingSection(),
                        const SizedBox(width: 60),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  Settings(onFavouriteChange: _loadTodosFromDatabase)),
                            );
                          },
                          iconSize: 22,
                          icon: new Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: DaySelectionRow(currentDayOfWeek: DateTime.now().weekday),
                  ),
                ],
              ),
            ),
            if (_selectedIndex == 0) // Show main content only when index is 0
              Expanded(child: MainContentSection(widget.favouriteHabitsList, todosList, toDoHistory)),
            if (_selectedIndex == 1) // Show to-do list only when index is 1
              Expanded(child: ToDoListSection(widget.favouriteHabitsList, _handleToDoChange, _handleStartActivity)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'To do List',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: selectedColor,
        onTap: _onItemTapped,
      ),
    );
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

  void _handleToDoChange(ToDo todo) async {
    todo.isDone = !todo.isDone;
    await DatabaseHelper.instance.updateTodoStatus(todo);
    _loadTodosFromDatabase();
  }

  void _handleStartActivity(int id) async {
    //go to the related screen
  }
}