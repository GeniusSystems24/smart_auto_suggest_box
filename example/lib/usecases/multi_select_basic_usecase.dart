import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class MultiSelectBasicUseCase extends StatelessWidget {
  const MultiSelectBasicUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestMultiSelectBox<String>(
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: fruitItemBuilder,
          initialList: (context) => fruits,
        ),
        decoration: const InputDecoration(
          labelText: 'Select fruits',
          border: OutlineInputBorder(),
        ),
        onSelectionChanged: (selected) {
          debugPrint('Selected: \${selected.map((e) => e.label).join(', ')}');
        },
      ),
    );
  }
}''';

class MultiSelectBasicUseCase extends StatelessWidget {
  const MultiSelectBasicUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Basic Multi-Select',
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
              decoration: const InputDecoration(
                labelText: 'Select fruits',
                border: OutlineInputBorder(),
              ),
              onSelectionChanged: (selected) {
                // Normally handled internally
              },
            ),
          ],
        ),
      ),
    );
  }
}
