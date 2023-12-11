import 'package:flutter/material.dart';
import 'todo.dart';
import 'widgets/todo_item.dart';

class ToDoListSection extends StatelessWidget {
  final List<ToDo> favouriteHabitsList;
  final Function(ToDo) handleToDoChange;

  const ToDoListSection(
      this.favouriteHabitsList, this.handleToDoChange,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 20, 0, 0),
          child: Text(
            "TODAY'S PLANNING",
            textAlign: TextAlign.left,
          ),
        ),
         Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 0, 0),
          child: Text(
            "YOU HAVE "+favouriteHabitsList.length.toString()+" TO DO",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 10),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (ToDo todo in favouriteHabitsList)
                ToDoItem(
                  todo: todo,
                  onToDoChanged: handleToDoChange,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
