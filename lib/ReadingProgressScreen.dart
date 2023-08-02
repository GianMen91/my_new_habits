// reading_progress_screen.dart
import 'package:flutter/material.dart';

class ReadingProgressScreen extends StatefulWidget {
  @override
  _ReadingProgressScreenState createState() => _ReadingProgressScreenState();
}

class _ReadingProgressScreenState extends State<ReadingProgressScreen> {
  int _currentPage = 1;
  int _totalPages = 300; // Replace this with the actual total pages of the book
  double _progressPercent = 0.0;

  @override
  void initState() {
    super.initState();
    // Calculate the initial progress percentage
    _progressPercent = (_currentPage / _totalPages) * 100;
  }

  void _updateReadingProgress(int page) {
    setState(() {
      _currentPage = page;
      // Recalculate the progress percentage
      _progressPercent = (_currentPage / _totalPages) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reading Progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Page: $_currentPage',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Total Pages: $_totalPages',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Slider(
              value: _currentPage.toDouble(),
              min: 1,
              max: _totalPages.toDouble(),
              onChanged: (double newValue) {
                _updateReadingProgress(newValue.toInt());
              },
            ),
            SizedBox(height: 16),
            Text(
              'Progress: ${_progressPercent.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement adding the current book to the reading list
                // and any other related actions
              },
              child: Text('Add to Reading List'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement setting reading goals or any other related actions
              },
              child: Text('Set Reading Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
