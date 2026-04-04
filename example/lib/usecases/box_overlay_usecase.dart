import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class BoxOverlayUseCase extends StatelessWidget {
  const BoxOverlayUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestBox<String>(
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: fruitItemBuilder,
          initialList: (context) => fruits,
        ),
        decoration: const InputDecoration(
          labelText: 'Search fruits',
          border: OutlineInputBorder(),
        ),
        onSelected: (item) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected: \${item?.label}')),
          );
        },
      ),
    );
  }
}''';

class BoxOverlayUseCase extends StatelessWidget {
  const BoxOverlayUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Floating Overlay',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SmartAutoSuggestBox<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (context) => fruits,
              ),
              decoration: const InputDecoration(
                labelText: 'Search fruits',
                border: OutlineInputBorder(),
              ),
              onSelected: (item) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${item?.label}')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
