import 'package:flutter/material.dart';
import '../costants/constants.dart';
import '../models/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo; // The todo item that this widget represents
  final void Function(ToDo)
      onToDoTapped; // Callback function triggered when the todo item is tapped

  // Constructor that initializes the ToDoItem with a ToDo object and an onToDoTapped callback
  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return a container wrapping the ListTile widget
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      // Margin to give space below each item
      child: ListTile(
        onTap: () {
          // Trigger the onToDoTapped callback when the ListTile is tapped
          onToDoTapped(todo);
        },
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: selectedColor, // Use the selectedColor for the checkbox icon
        ),
        title: Text(
          todo.todoText, // Display the text of the todo
          style: _getToDoTextStyle(todo
              .isDone), // Apply text style based on whether the todo is done
        ),
      ),
    );
  }

  // Returns the text style for the todo based on whether it is completed or not
  TextStyle _getToDoTextStyle(bool isDone) {
    return TextStyle(
      fontSize: 16, // Set the font size
      color: Colors.black, // Text color is black
      decoration: isDone
          ? TextDecoration.lineThrough
          : null, // Strikethrough if the todo is marked as done
    );
  }
}
