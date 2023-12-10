import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'costants/constants.dart';
import 'todo.dart';
import 'widgets/todo_item.dart';
import 'database_helper.dart';
import 'settings.dart';
import 'todo_history.dart';

class ToDoListSection extends StatelessWidget {
  final List<ToDo> favouriteHabitsList;
  final Function(ToDo) handleToDoChange;
  final Function(int) handleStartActivity;

  ToDoListSection(this.favouriteHabitsList, this.handleToDoChange, this.handleStartActivity);

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
