import 'package:flutter/material.dart';
import '../costants/constants.dart';
import '../models/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final void Function(ToDo) onToDoTapped;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Reuse a const widget for consistent performance
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          // Trigger onToDoTapped callback when the item is tapped
          onToDoTapped(todo);
        },
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: selectedColor, // Can use a static or predefined color
        ),
        title: Text(
          todo.todoText,
          style: _getToDoTextStyle(todo.isDone),
        ),
      ),
    );
  }

  TextStyle _getToDoTextStyle(bool isDone) {
    return TextStyle(
      fontSize: 16,
      color: Colors.black,
      decoration: isDone ? TextDecoration.lineThrough : null,
    );
  }
}
