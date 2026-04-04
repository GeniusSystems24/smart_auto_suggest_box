import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class MultiSelectMaxUseCase extends StatelessWidget {
  const MultiSelectMaxUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestMultiSelectBox<String>(
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: fruitItemBuilder,
          initialList: (context) => fruits,
        ),
        maxSelections: 5,
        maxVisibleChips: 2,
        decoration: const InputDecoration(
          labelText: 'Select max 5 fruits',
          border: OutlineInputBorder(),
        ),
        onSelectionChanged: (selected) {},
      ),
    );
  }
}''';

class MultiSelectMaxUseCase extends StatelessWidget {
  const MultiSelectMaxUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Max Selections Multi-Select',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SmartAutoSuggestMultiSelectBox<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (context) => fruits,
              ),
              maxSelections: 5,
              maxVisibleChips: 2,
              decoration: const InputDecoration(
                labelText: 'Select max 5 fruits',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
