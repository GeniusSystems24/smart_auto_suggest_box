import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/generated/l10n.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'advanced_examples.dart';
import 'box_demo.dart';
import 'multi_select_demo.dart';
import 'view_demo.dart';

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

// ─────────────────────────────────────────────────────────────────────────────
// Home with bottom navigation between the three widget demos
// ─────────────────────────────────────────────────────────────────────────────

class _DemoHome extends StatefulWidget {
  const _DemoHome();

  @override
  State<_DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<_DemoHome> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          SmartAutoSuggestBoxDemo(),
          SmartAutoSuggestViewDemo(),
          MultiSelectDemo(),
          AdvancedExamplesDemo(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.text_fields),
            label: 'Box',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'View',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist),
            label: 'Multi-Select',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            label: 'Examples',
          ),
        ],
      ),
    );
  }
}
