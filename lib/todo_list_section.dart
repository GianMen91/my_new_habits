import 'package:flutter/material.dart';
import 'todo.dart';
import 'widgets/todo_item.dart';

class ToDoListSection extends StatelessWidget {
  final List<ToDo> favouriteHabitsList;
  final Function(ToDo) handleToDoChange;
  final Function(int) handleStartActivity;

  const ToDoListSection(
      this.favouriteHabitsList, this.handleToDoChange, this.handleStartActivity,
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
            'HABITS',
            textAlign: TextAlign.left,
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
                  onStartActivity: handleStartActivity,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
