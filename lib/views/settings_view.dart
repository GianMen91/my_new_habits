import 'package:flutter/material.dart';
import '../costants/constants.dart';
import '../helpers/database_helper.dart';
import '../models/todo.dart';

class SettingsView extends StatefulWidget {
  final Future<void> Function() onFavouriteChange;

  const SettingsView({Key? key, required this.onFavouriteChange}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  List<ToDo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodosFromDatabase();
  }

  Future<void> _loadTodosFromDatabase() async {
    final todos = await DatabaseHelper.instance.getTodos();
    setState(() {
      _todos = todos;
    });
  }

  void _onChecked(ToDo todo) async {
    setState(() {
      todo.isFavourite = !todo.isFavourite;
    });
    await DatabaseHelper.instance.updateFavouriteStatus(todo);
    widget.onFavouriteChange(); // Notify parent widget about the change
  }

  void _showAddHabitDialog(BuildContext context) {
    TextEditingController habitController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add New Habit',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: habitController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: 'Enter the new habit',
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(),
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
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.bold, color: boldTextColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newHabitText = habitController.text.trim();

                if (newHabitText.isNotEmpty) {
                  // Add new habit to the database
                  await DatabaseHelper.instance.addNewHabit(newHabitText);
                  _reloadHabitsList();
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(fontWeight: FontWeight.bold, color: boldTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reloadHabitsList() async {
    List<ToDo> updatedHabits = await DatabaseHelper.instance.getTodos();
    setState(() {
      _todos = updatedHabits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              _buildHeader(context),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Text(
                  'Choose the habits you want to follow:',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              _buildHabitList(),
              _buildAddHabitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            for (var todo in _todos) {
              await DatabaseHelper.instance.updateFavouriteStatus(todo);
            }
            Navigator.pop(context);
            widget.onFavouriteChange();
          },
        ),
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildHabitList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return _buildHabitTile(todo);
        },
      ),
    );
  }

  Widget _buildHabitTile(ToDo todo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: () => _onChecked(todo),
        leading: Icon(
          todo.isFavourite ? Icons.check_box : Icons.check_box_outline_blank,
          color: selectedColor,
        ),
        title: Text(
          todo.todoText,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildAddHabitButton(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: selectedColor,
      onPressed: () => _showAddHabitDialog(context),
      child: const Icon(Icons.add),
    );
  }
}
