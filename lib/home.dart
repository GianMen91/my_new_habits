import 'package:flutter/material.dart';
import 'package:newmehabits2/settings.dart';
import 'package:newmehabits2/todo_history.dart';
import 'todo.dart';
import 'widgets/todo_item.dart';
import 'database_helper.dart';
import 'statistic_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todosList = [];
  List<ToDoHistory> toDoHistory = [];
  String todayDate = '';

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

  @override
  Widget build(BuildContext context) {
    List<ToDo> favouriteHabitsList =
        todosList.where((habit) => habit.isFavourite).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StatisticBar(toDoHistory: toDoHistory, favouriteHabitsListSize:favouriteHabitsList.length)),
                );
              }),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Settings(onFavouriteChange: _loadTodosFromDatabase)),
                );
              }),
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Your daily good habits',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Today is $todayDate',
                              // Display the formatted date
                              style: const TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (ToDo todo in favouriteHabitsList)
                        ToDoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onStartActivity: _handleStartActivity,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
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
}
