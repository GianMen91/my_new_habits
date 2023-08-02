// main.dart

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'JournalingScreen.dart';



void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    if (task == 'mindfulness_timer_task') {
      int durationInSeconds = 10;
      while (durationInSeconds > 0) {
        durationInSeconds--;
        sleep(const Duration(seconds: 1)); // Simulate a one-second delay
      }

      // Play the sound when the timer completes
      AudioCache audioCache = AudioCache();
      audioCache.load('audio/timer_complete.mp3');
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: JournalingScreen(),
    );
  }
}
