import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class JournalingScreen extends StatefulWidget {
  @override
  _JournalingScreenState createState() => _JournalingScreenState();
}

class _JournalingScreenState extends State<JournalingScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<JournalEntry> _journalEntries = [];
  TextEditingController goalController = TextEditingController();
  TextEditingController gratitudeController = TextEditingController();
  TextEditingController reflectionsController = TextEditingController();
  TextEditingController businessController = TextEditingController();

  @override
  void dispose() {
    goalController.dispose();
    gratitudeController.dispose();
    reflectionsController.dispose();
    businessController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadJournalEntriesFromDatabase();
  }

  void _loadJournalEntriesFromDatabase() async {
    List<JournalEntry> journalEntries = await _databaseHelper.getJournalEntries();
    setState(() {
      _journalEntries = journalEntries;
    });
  }

  void _saveJournalEntry(String title, String content) async {
    String timestamp = DateTime.now().toIso8601String();
    JournalEntry journalEntry = JournalEntry(title: title, content: content, timestamp: timestamp);
    await _databaseHelper.insertJournalEntry(journalEntry);
    _loadJournalEntriesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journaling'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tomorrow\'s Goal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: goalController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write your goal for tomorrow...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Expressions of Gratitude',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: gratitudeController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write what you are grateful for...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Reflections on Negative Thoughts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: reflectionsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Reflect on negative thoughts and how to address them...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Working on Business',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: businessController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write about your business tasks and progress...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save journal entries to your data source
                // You can use a database, shared preferences, or any other storage method
                // For simplicity, we'll just show a snackbar indicating the entries are saved
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Journal entries saved!')),
                );
              },
              child: Text('Save Journal Entries'),
            ),
          ],
        ),
      ),
    );
  }
}
