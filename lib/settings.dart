import 'package:flutter/material.dart';
import 'costants/constants.dart';
import 'costants/habits_info_costants.dart';
import 'todo.dart';
import 'database_helper.dart';

DateTime scheduleTime = DateTime.now();

class Settings extends StatefulWidget {
  final onFavouriteChange;

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

                      Text(
                        'Settings',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        right: 15, left: 15, top: 10, bottom: 20),
                    child: Text(
                      'Choose the habits you want to follow and click on the save button to save the changes',
                      /*style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),*/
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: Column(
                            children: const [],
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
                                trailing: Container(
                                  padding: const EdgeInsets.all(0),
                                  margin: const EdgeInsets.symmetric(vertical: 12),
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: selectedColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: IconButton(
                                    color: Colors.white,
                                    iconSize: 18,
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () {
                                      _dialogBuilder(context, todo);
                                    },
                                  ),
                                )
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
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, ToDo todo) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(todo.todoText),
          content: Text(details[todo.id - 1]),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onChecked(ToDo todo) async {
    setState(() {
      todo.isFavourite = !todo.isFavourite;
    });
  }
}
