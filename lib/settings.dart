import 'package:flutter/material.dart';
import 'todo.dart';
import 'database_helper.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'services/notification_service.dart';

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
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          children: const [
                            Text(
                              'Choose the habits you want to follow and click on the save button to save the changes',
                              /*style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),*/
                            ),
                          ],
                        ),
                      ),
                      for (ToDo todo in todosList)
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: ExpansionTile(
                              title: Text(
                                todo.todoText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              leading: IconButton(
                                  color: Colors.lightBlue,
                                  onPressed: () {
                                    _onChecked(todo);
                                  },
                                  icon: todo.isFavourite
                                      ? const Icon(Icons.check_box)
                                      : const Icon(
                                          Icons.check_box_outline_blank)),
                              children: const <Widget>[
                                DatePickerTxt(),
                                ScheduleBtn(),
                              ]),
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

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => scheduleTime = date,
          onConfirm: (date) {},
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
            title: 'Scheduled Notification',
            body: '$scheduleTime',
            scheduledNotificationDateTime: scheduleTime);
      },
    );
  }
}