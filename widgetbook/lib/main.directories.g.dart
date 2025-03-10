// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/views/homepage_view.dart' as _i2;
import 'package:widgetbook_workspace/views/settings_view.dart' as _i3;
import 'package:widgetbook_workspace/widgets/day_selection_row.dart' as _i4;
import 'package:widgetbook_workspace/widgets/greetings.dart' as _i5;
import 'package:widgetbook_workspace/widgets/main_content_section.dart' as _i6;
import 'package:widgetbook_workspace/widgets/todo_item.dart' as _i7;
import 'package:widgetbook_workspace/widgets/todo_list_section.dart' as _i8;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'views',
    children: [
      _i1.WidgetbookLeafComponent(
        name: 'HomePageView',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i2.buildHomePageViewUseCase,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'SettingsView',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i3.buildSettingsViewUseCase,
        ),
      ),
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'widgets',
    children: [
      _i1.WidgetbookLeafComponent(
        name: 'DaySelectionRow',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i4.buildDaySelectionRowUseCase,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'GreetingSection',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i5.buildGreetingSectionUseCase,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'MainContentSection',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i6.buildMainContentSectionUseCase,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'ToDoItem',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i7.buildToDoItemUseCase,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'ToDoListSection',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i8.buildToDoListSectionUseCase,
        ),
      ),
    ],
  ),
];
