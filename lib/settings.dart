import 'package:flutter/material.dart';
import 'todo.dart';
import 'database_helper.dart';

class Settings extends StatefulWidget {
  final onFavouriteChange;
  const Settings({Key? key,  required this.onFavouriteChange}) : super(key: key);

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
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            widget.onFavouriteChange();
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                for (ToDo todo in todosList) {
                  await DatabaseHelper.instance.updateFavouriteStatus(todo);
                }
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
                              color: Colors.lightBlue,
                            ),
                            title: Text(
                              todo.todoText,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                decoration: todo.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        )
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

  void _onChecked(ToDo todo) async {
    setState(() {
      todo.isFavourite = !todo.isFavourite;
    });
  }
}
