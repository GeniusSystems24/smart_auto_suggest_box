import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';

import 'usecases/async_search_usecase.dart';
import 'usecases/bottom_sheet_usecase.dart';
import 'usecases/box_overlay_usecase.dart';
import 'usecases/custom_item_builder_usecase.dart';
import 'usecases/custom_no_results_usecase.dart';
import 'usecases/dropdown_direction_usecase.dart';
import 'usecases/error_on_search_usecase.dart';
import 'usecases/form_validation_usecase.dart';
import 'usecases/multi_select_basic_usecase.dart';
import 'usecases/multi_select_max_usecase.dart';
import 'usecases/search_mode_always_usecase.dart';
import 'usecases/selected_item_display_usecase.dart';
import 'usecases/view_inline_usecase.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Auto Suggest Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        extensions: [SmartAutoSuggestTheme.light()],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        extensions: [SmartAutoSuggestTheme.dark()],
      ),
      localizationsDelegates: const [
        SmartAutoSuggestBoxLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:
          SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
      home: const _DemoHome(),
    );
  }
}

class _DemoHome extends StatelessWidget {
  const _DemoHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Auto Suggest Use Cases')),
      body: ListView(
        children: [
          _buildListItem(
            context,
            'Floating Overlay',
            'Basic SmartAutoSuggestBox usecase',
            const BoxOverlayUseCase(),
          ),
          _buildListItem(
            context,
            'Inline View',
            'Basic SmartAutoSuggestView usecase',
            const ViewInlineUseCase(),
          ),
          _buildListItem(
            context,
            'Async Server Search',
            'Searching with a network delay',
            const AsyncSearchUseCase(),
          ),
          _buildListItem(
            context,
            'Search Mode: always',
            'Trigger search on every keystroke',
            const SearchModeAlwaysUseCase(),
          ),
          _buildListItem(
            context,
            'onSearch Error',
            'Error handling when onSearch fails',
            const ErrorOnSearchUseCase(),
          ),
          _buildListItem(
            context,
            'Dropdown Direction',
            'Test top, bottom, start, end directions',
            const DropdownDirectionUseCase(),
          ),
          _buildListItem(
            context,
            'BottomSheet View',
            'SmartAutoSuggestView inside a BottomSheet',
            const BottomSheetUseCase(),
          ),
          _buildListItem(
            context,
            'Custom No-Results',
            'Custom UI when no results are found',
            const CustomNoResultsUseCase(),
          ),
          _buildListItem(
            context,
            'Custom Item Builder',
            'Custom layout for suggestion items',
            const CustomItemBuilderUseCase(),
          ),
          _buildListItem(
            context,
            'Form Validation',
            'Usage inside a Form with error text',
            const FormValidationUseCase(),
          ),
          _buildListItem(
            context,
            'Selected Item Builder',
            'Custom layout for the selected item in the text field',
            const SelectedItemDisplayUseCase(),
          ),
          _buildListItem(
            context,
            'Basic Multi-Select',
            'SmartAutoSuggestMultiSelectBox basic demo',
            const MultiSelectBasicUseCase(),
          ),
          _buildListItem(
            context,
            'Max Selections Multi-Select',
            'Multi-Select with max limits',
            const MultiSelectMaxUseCase(),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    String title,
    String subtitle,
    Widget child,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => child));
      },
    );
  }
}
