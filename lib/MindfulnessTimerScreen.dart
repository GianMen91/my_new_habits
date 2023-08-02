// mindfulness_timer_screen.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

class MindfulnessTimerScreen extends StatefulWidget {
  @override
  _MindfulnessTimerScreenState createState() => _MindfulnessTimerScreenState();
}

class _MindfulnessTimerScreenState extends State<MindfulnessTimerScreen> {
  Duration _timerDuration = Duration(minutes: 10);
  bool _isTimerRunning = false;
  AudioCache _audioCache = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mindfulness Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '10 Minutes Mindfulness Timer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '${_timerDuration.inMinutes}:${(_timerDuration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _isTimerRunning
                ? ElevatedButton(
              onPressed: () {
                stopTimer();
              },
              child: Text('Stop Timer'),
            )
                : ElevatedButton(
              onPressed: () {
                startTimer();
              },
              child: Text('Start Timer'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                resetTimer();
              },
              child: Text('Reset Timer'),
            ),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    // Schedule the background task using workmanager
    Workmanager().registerOneOffTask(
      'mindfulness_timer',
      'mindfulness_timer_task',
      inputData: {'duration_in_seconds': _timerDuration.inSeconds},
    );
    setState(() {
      _isTimerRunning = true;
    });

    // Start playing the relaxing background music
  //  _audioCache.loop('audio/relaxing_music.mp3');
  }

  void stopTimer() {
    // Cancel the background task
    Workmanager().cancelAll();
    setState(() {
      _isTimerRunning = false;
    });

    // Stop playing the relaxing background music
   // _audioCache.stop();
  }

  void resetTimer() {
    setState(() {
      _isTimerRunning = false;
      _timerDuration = Duration(minutes: 10);
    });

    // Stop playing the relaxing background music
    //_audioCache.stop();
  }
}
