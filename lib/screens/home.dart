import 'package:flutter/material.dart';
import 'package:newmehabits2/model/todo.dart';
import 'package:newmehabits2/screens/statistic.dart';

import '../widgets/todo_item.dart';
import '../database_helper.dart';
import 'statistic_bar.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todosList = [];
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
    setState(() {
      todosList = todos;
    });
  }

  Future<void> _loadTodayDate() async {
    final now = DateTime.now();
    todayDate =
        "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year.toString()}";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  StatisticBar()),
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
                          top: 50,
                          bottom: 20,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Your daily habits',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Today is $todayDate', // Display the formatted date
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (ToDo todo in todosList.reversed)
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
