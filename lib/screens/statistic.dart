import 'package:flutter/material.dart';
import 'package:newmehabits2/model/todo.dart';
import '../database_helper.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool _showTodayStats = true; // Initial state to show today's stats

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ToDo>>(
      future: DatabaseHelper.instance.getTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available.');
        }

        final todos = snapshot.data!;
        final now = DateTime.now();

        final completedGoalsToday = todos.where((todo) {
          final todoDate = DateTime.parse(todo.recordDate);
          return todo.isDone && todoDate.isAtSameMomentAs(now);
        }).length;

        final completedGoalsLastWeek = todos.where((todo) {
          final lastWeekStart = now.subtract(const Duration(days: 7));
          final todoDate = DateTime.parse(todo.recordDate);
          return todo.isDone && todoDate.isAfter(lastWeekStart);
        }).length;

        final List<FlSpot> chartData = [
          FlSpot(0, completedGoalsToday.toDouble()),
          FlSpot(1, completedGoalsLastWeek.toDouble()),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Statistics'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Statistics for Completed Goals'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showTodayStats = true;
                        });
                      },
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontWeight: _showTodayStats ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showTodayStats = false;
                        });
                      },
                      child: Text(
                        'Last Week',
                        style: TextStyle(
                          fontWeight: !_showTodayStats ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Completed Goals: ${_showTodayStats ? completedGoalsToday : completedGoalsLastWeek}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1.7,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [BarChartRodData(fromY: 0 , toY: chartData[0].y)],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [BarChartRodData(fromY: 0 , toY: chartData[1].y)],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
