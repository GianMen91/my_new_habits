import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:my_new_habits/views/homepage_view.dart';

@widgetbook.UseCase(name: 'Default', type: HomePageView)
Widget buildHomePageViewUseCase(BuildContext context) {
  return HomePageView();
}
