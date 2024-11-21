import 'package:flutter/material.dart';
import '../costants/constants.dart';
import '../models/todo_test.dart';
import '../widgets/day_selection_row_test.dart';
import '../widgets/greetings_test.dart';
import '../widgets/main_content_section_test.dart';
import '../helpers/database_helper_test.dart';
import '../widgets/todo_list_section_test.dart';
import 'settings_view.dart';
import '../models/todo_history_test.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ToDo> _todos = [];
  List<ToDoHistory> _todoHistory = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTodosFromDatabase();
    _resetCheckboxesIfNewDay();
  }

  Future<void> _loadTodosFromDatabase() async {
    final todos = await DatabaseHelper.instance.getTodos();
    final todoHistory = await DatabaseHelper.instance.getToDoHistory();
    setState(() {
      _todos = todos;
      _todoHistory = todoHistory;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _resetCheckboxesIfNewDay() async {
    final todos = await DatabaseHelper.instance.getTodos();
    final now = DateTime.now();
    for (var todo in todos) {
      final todoDate = DateTime.parse(todo.recordDate);
      if (todoDate.isBefore(DateTime(now.year, now.month, now.day))) {
        todo.isDone = false;
        await DatabaseHelper.instance.updateTodoStatus(todo);
      }
    }
    _loadTodosFromDatabase();
  }

  void _handleTodoChange(ToDo todo) async {
    todo.isDone = !todo.isDone;
    await DatabaseHelper.instance.updateTodoStatus(todo);
    _loadTodosFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_selectedIndex == 0) Expanded(child: _buildMainContent()),
            if (_selectedIndex == 1) Expanded(child: _buildTodoList()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              children: [
                const Expanded(child: GreetingSection()),
                const SizedBox(width: 60),
                IconButton(
                  onPressed: _navigateToSettings,
                  iconSize: 22,
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: DaySelectionRow(currentDayOfWeek: DateTime.now().weekday),
          ),
        ],
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsView(
          onFavouriteChange: _loadTodosFromDatabase,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return MainContentSection(
      _todos.where((todo) => todo.isFavourite).toList(),
      _todos,
      _todoHistory,
      _handleTodoChange,
    );
  }

  Widget _buildTodoList() {
    return ToDoListSection(
      _todos.where((todo) => todo.isFavourite).toList(),
      _handleTodoChange,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: bottomNavigationBarColor,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'To-do List',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: boldTextColor,
      onTap: _onItemTapped,
    );
  }
}
