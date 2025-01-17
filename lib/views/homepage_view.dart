import 'package:flutter/material.dart';
import '../costants/constants.dart';
import '../models/todo.dart';
import '../widgets/day_selection_row.dart';
import '../widgets/greetings.dart';
import '../widgets/main_content_section.dart';
import '../helpers/database_helper.dart';
import '../widgets/todo_list_section.dart';
import 'settings_view.dart';
import '../models/todo_history.dart';

// This widget represents the home page of the application, which displays a list of ToDo items
// and allows the user to navigate to the to-do list or settings.
class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  HomePageViewState createState() => HomePageViewState();
}

class HomePageViewState extends State<HomePageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Key for Scaffold
  List<ToDo> _todos = []; // List to store all to-do items
  List<ToDoHistory> _todoHistory = []; // List to store the to-do history
  int _selectedIndex = 0; // To keep track of the selected index for navigation

  @override
  void initState() {
    super.initState();
    _loadTodosFromDatabase(); // Load todos from the database when the widget is initialized
    _resetCheckboxesIfNewDay(); // Reset the todo checkboxes if a new day starts
  }

  // Method to load todos and todo history from the database
  Future<void> _loadTodosFromDatabase() async {
    final todos = await DatabaseHelper.instance.getTodos();
    final todoHistory = await DatabaseHelper.instance.getToDoHistory();
    setState(() {
      _todos = todos; // Set the fetched todos to the state
      _todoHistory = todoHistory; // Set the fetched todo history to the state
    });
  }

  // Method to handle the bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex =
          index; // Update the selected index when a bottom nav item is tapped
    });
  }

  // Method to reset the 'isDone' status of todos if the date has changed
  void _resetCheckboxesIfNewDay() async {
    final todos = await DatabaseHelper.instance.getTodos();
    final now = DateTime.now();
    for (var todo in todos) {
      final todoDate = DateTime.parse(todo.recordDate);
      // If the todo's date is before the current date, reset its 'isDone' status
      if (todoDate.isBefore(DateTime(now.year, now.month, now.day))) {
        todo.isDone = false; // Reset the 'isDone' status to false
        await DatabaseHelper.instance
            .updateTodoStatus(todo); // Update the todo in the database
      }
    }
    _loadTodosFromDatabase(); // Reload todos after resetting
  }

  // Method to handle changes in the todo's completion status
  void _handleTodoChange(ToDo todo) async {
    todo.isDone = !todo.isDone; // Toggle the 'isDone' status
    await DatabaseHelper.instance
        .updateTodoStatus(todo); // Update the todo in the database
    _loadTodosFromDatabase(); // Reload todos after the change
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Scaffold key for managing state
      backgroundColor: backgroundColor, // Background color of the page
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            // Build the header section of the page
            // Conditionally render content based on the selected index for navigation
            if (_selectedIndex == 0) Expanded(child: _buildMainContent()),
            if (_selectedIndex == 1) Expanded(child: _buildTodoList()),
          ],
        ),
      ),
      bottomNavigationBar:
          _buildBottomNavigationBar(), // Bottom navigation bar for navigation between views
    );
  }

  // Method to build the header section of the home page
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              children: [
                Expanded(
                    child: GreetingSection(
                        currentHour: DateTime.now()
                            .hour)), // Greeting section based on the current time
                const SizedBox(width: 60),
                IconButton(
                  onPressed: _navigateToSettings,
                  // Navigate to settings when tapped
                  iconSize: 22,
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: DaySelectionRow(
                currentDayOfWeek:
                    DateTime.now().weekday), // Display the day of the week
          ),
        ],
      ),
    );
  }

  // Method to navigate to the settings view
  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsView(
          onFavouriteChange:
              _loadTodosFromDatabase, // Reload todos if the favourite list is changed in settings
        ),
      ),
    );
  }

  // Method to build the main content section with todos and todo history
  Widget _buildMainContent() {
    return MainContentSection(
      _todos.where((todo) => todo.isFavourite).toList(),
      // Filter favourite todos
      _todos, // All todos
      _todoHistory, // Todo history
      _handleTodoChange, // Handle todo completion status change
    );
  }

  // Method to build the todo list section
  Widget _buildTodoList() {
    return ToDoListSection(
      _todos.where((todo) => todo.isFavourite).toList(),
      // Filter favourite todos for the list
      _handleTodoChange, // Handle todo completion status change
    );
  }

  // Method to build the bottom navigation bar with navigation items
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: bottomNavigationBarColor,
      // Background color of the bottom nav
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // Icon for home tab
          label: 'Home', // Label for home tab
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list), // Icon for todo list tab
          label: 'To-do List', // Label for todo list tab
        ),
      ],
      currentIndex: _selectedIndex,
      // Set the current selected index
      selectedItemColor: boldTextColor,
      // Color for the selected item
      onTap: _onItemTapped, // Handle tab item selection
    );
  }
}
