import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'todo_item.dart';

class ToDoListSection extends StatelessWidget {
  final List<ToDo> favouriteHabitsList; // List of todos that will be displayed
  final Function(ToDo)
      handleToDoTapped; // Callback function when a todo is tapped

  // Constructor that initializes the ToDoListSection with the list of todos and the callback function
  const ToDoListSection(this.favouriteHabitsList, this.handleToDoTapped,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Align children to the start
      children: [
        // Header text indicating today's planning
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 20, 0, 0),
          child: Text(
            "TODAY'S PLANNING",
            textAlign: TextAlign.left,
          ),
        ),

        // Text showing how many todos are in the list or if it's empty
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 0, 0),
          child: Text(
            favouriteHabitsList.isNotEmpty
                ? "You have ${favouriteHabitsList.length} to do"
                : "Your todo list is empty!",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15),
          ),
        ),

        const SizedBox(height: 16), // Space between the text and the list

        // A ListView widget that displays all the todos
        Expanded(
          child: ListView(
            shrinkWrap: true, // Avoids ListView taking extra space
            children: [
              // For each todo item in the list, create a ToDoItem widget
              for (ToDo todo in favouriteHabitsList)
                ToDoItem(
                  todo: todo,
                  onToDoTapped:
                      handleToDoTapped, // Pass the callback to each ToDoItem
                ),
            ],
          ),
        ),
      ],
    );
  }
}
