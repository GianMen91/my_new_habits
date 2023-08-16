import 'package:flutter/material.dart';
import 'package:newmehabits2/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    //title: 'App Title',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State {
  //static const PrimaryColor = const Color(0xFF811611);

  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
                child: Image.asset("assets/logo.png",
                    height: 200, width: 200, fit: BoxFit.contain)),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text("©Copyright 2023 Giancarlo Mennillo",
                  style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
