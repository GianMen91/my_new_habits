import 'package:flutter/material.dart';
import '../costants/constants.dart';
import '../helpers/database_helper.dart';
import '../models/todo.dart';

DateTime scheduleTime = DateTime.now();

class Settings extends StatefulWidget {
  final Future<void> Function() onFavouriteChange;

  const Settings({Key? key, required this.onFavouriteChange}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<ToDo> todosList = [];

  @override
  void initState() {
    _loadTodosFromDatabase();
    super.initState();
  }

  Future<void> _loadTodosFromDatabase() async {
    final todos = await DatabaseHelper.instance.getTodos();
    setState(() {
      todosList = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () async {
                          for (ToDo todo in todosList) {
                            await DatabaseHelper.instance
                                .updateFavouriteStatus(todo);
                          }

                          Navigator.pop(context);
                          widget.onFavouriteChange();
                        },
                      ),
                      const Text(
                        'Settings',
                        style: TextStyle(
                          //fontFamily: 'Niconne',
                          //fontSize: 32,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        right: 15, left: 15, top: 10, bottom: 20),
                    child: Text(
                      'Choose the habits you want to follow:',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: const Column(
                            
                          ),
                        ),
                        for (ToDo todo in todosList)
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: ListTile(
                              onTap: () {
                                _onChecked(todo);
                              },
                              leading: Icon(
                                todo.isFavourite
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: selectedColor,
                              ),
                              title: Text(
                                todo.todoText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  FloatingActionButton.small(
                    backgroundColor: selectedColor,
                    onPressed: () {
                      _showAddHabitDialog(context);
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    TextEditingController habitController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Habit',
              style: TextStyle(
                fontFamily: 'Niconne',
                fontSize: 32,
                fontWeight: FontWeight.bold,
              )),
          content: TextField(
            controller: habitController,
            style: const TextStyle(color: Colors.black),
            // Change text color as needed
            decoration: const InputDecoration(
              labelText: 'Enter the new habit',
              labelStyle: TextStyle(color: Colors.black),
              // Change label text color
              focusedBorder: UnderlineInputBorder(
                
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: boldTextColor,
                  )),
            ),
            TextButton(
                onPressed: () async {
                  String newHabitText = habitController.text.trim();

                  if (newHabitText.isNotEmpty) {
                    // Add new habit to the database
                    await DatabaseHelper.instance.addNewHabit(newHabitText);

                    // Reload the list of habits
                    _reloadHabitsList();

                    Navigator.pop(context); // Close the dialog
                  }
                },
                child: const Text('Add',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: boldTextColor,
                    ))),
          ],
        );
      },
    );
  }

  void _reloadHabitsList() async {
    // Reload the list of habits from the database
    List<ToDo> updatedHabits = await DatabaseHelper.instance.getTodos();

    // Update the state to trigger a rebuild of the widget
    setState(() {
      todosList = updatedHabits;
    });
  }

  void _onChecked(ToDo todo) async {
    setState(() {
      todo.isFavourite = !todo.isFavourite;
    });
    widget.onFavouriteChange(); // Notify the parent widget about the change
  }
}
