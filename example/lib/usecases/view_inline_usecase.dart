import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';
import '../data.dart';

class ViewInlineUseCase extends StatelessWidget {
  const ViewInlineUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestView<String>(
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: fruitItemBuilder,
          initialList: (context) => fruits,
        ),
        showListWhenEmpty: true,
        listMaxHeight: 300,
        decoration: const InputDecoration(
          labelText: 'Search inline',
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

class ViewInlineUseCase extends StatelessWidget {
  const ViewInlineUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Inline View',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: SmartAutoSuggestView<String>(
                dataSource: SmartAutoSuggestDataSource(
                  itemBuilder: fruitItemBuilder,
                  initialList: (context) => fruits,
                ),
                showListWhenEmpty: true,
                listMaxHeight: 300,
                decoration: const InputDecoration(
                  labelText: 'Search inline',
                  border: OutlineInputBorder(),
                ),
                onSelected: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: ${item?.label}')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
