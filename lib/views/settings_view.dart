import 'package:flutter/material.dart';
import '../costants/constants.dart';
import '../helpers/database_helper.dart';
import '../models/todo.dart';

// This widget represents the settings page where users can manage their habits,
// including marking them as favorites and adding new habits.
class SettingsView extends StatefulWidget {
  final Future<void> Function()
      onFavouriteChange; // Callback function to notify parent about favorite change

  const SettingsView({Key? key, required this.onFavouriteChange})
      : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  List<ToDo> _todos = []; // List to store todos (habits)

  @override
  void initState() {
    super.initState();
    _loadTodosFromDatabase(); // Load todos from the database when the view is initialized
  }

  // Method to load the todos from the database and update the state
  Future<void> _loadTodosFromDatabase() async {
    final todos = await DatabaseHelper.instance.getTodos();
    setState(() {
      _todos = todos; // Set the fetched todos to the state
    });
  }

  // Method to handle when a user toggles the 'isFavourite' status of a todo
  void _onChecked(ToDo todo) async {
    setState(() {
      todo.isFavourite = !todo.isFavourite; // Toggle the 'isFavourite' status
    });
    await DatabaseHelper.instance
        .updateFavouriteStatus(todo); // Update the status in the database
    widget.onFavouriteChange(); // Notify the parent widget about the change
  }

  // Method to show a dialog for adding a new habit
  void _showAddHabitDialog(BuildContext context) {
    TextEditingController habitController = TextEditingController();

    // Show the dialog for adding a new habit
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
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: boldTextColor),
              ),
            ),
            // Add button
            TextButton(
              onPressed: () async {
                String newHabitText = habitController.text.trim();

                if (newHabitText.isNotEmpty) {
                  // Add the new habit to the database
                  await DatabaseHelper.instance.addNewHabit(newHabitText);
                  _reloadHabitsList(); // Reload the list of habits after adding the new one
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: boldTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to reload the habits list after adding a new habit
  Future<void> _reloadHabitsList() async {
    List<ToDo> updatedHabits = await DatabaseHelper.instance.getTodos();
    setState(() {
      _todos = updatedHabits; // Update the todos list with the latest data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background color of the settings page
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              _buildHeader(context),
              // Build the header section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Text(
                  'Choose the habits you want to follow:',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              _buildHabitList(),
              // Build the list of habits (todos)
              _buildAddHabitButton(context),
              // Build the button to add a new habit
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the header section of the settings page
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back), // Back button
          onPressed: () async {
            // Update the database when leaving the settings page
            for (var todo in _todos) {
              await DatabaseHelper.instance.updateFavouriteStatus(todo);
            }
            Navigator.pop(
                context); // Pop the settings page from the navigation stack
            widget
                .onFavouriteChange(); // Notify the parent widget about changes
          },
        ),
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Method to build the list of habits (todos)
  Widget _buildHabitList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _todos.length, // Number of items in the list
        itemBuilder: (context, index) {
          final todo = _todos[index]; // Get the todo for this index
          return _buildHabitTile(todo); // Build the tile for this habit
        },
      ),
    );
  }

  // Method to build a tile for a single habit (todo)
  Widget _buildHabitTile(ToDo todo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: () => _onChecked(todo), // Toggle favorite status when tapped
        leading: Icon(
          todo.isFavourite ? Icons.check_box : Icons.check_box_outline_blank,
          // Display checked or unchecked icon
          color: selectedColor, // Icon color
        ),
        title: Text(
          todo.todoText, // Display the habit text
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }

  // Method to build the button that allows the user to add a new habit
  Widget _buildAddHabitButton(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: selectedColor,
      // Button color
      onPressed: () => _showAddHabitDialog(context),
      // Show the dialog when pressed
      child: const Icon(Icons.add), // Icon for adding a new habit
    );
  }
}
