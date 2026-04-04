import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class CustomItemBuilderUseCase extends StatelessWidget {
  const CustomItemBuilderUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestBox<String>(
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: (context, value) => SmartAutoSuggestItem(
            value: value,
            label: value[0].toUpperCase() + value.substring(1),
            builder: (context, searchText) {
              final label = value[0].toUpperCase() + value.substring(1);
              return ListTile(
                leading: CircleAvatar(
                  child: Text(fruitEmojis[value] ?? value[0]),
                ),
                title: SmartAutoSuggestHighlightText(
                  text: label,
                  query: searchText,
                ),
                subtitle: Text('Value: \$value'),
                trailing: Chip(label: Text('\${label.length} letters')),
              );
            },
          ),
          initialList: (c) => fruits,
        ),
        tileHeight: 72,
        decoration: const InputDecoration(
          labelText: 'Custom Item Builder',
          border: OutlineInputBorder(),
        ),
        onSelected: (item) {},
      ),
    );
  }
}''';

class CustomItemBuilderUseCase extends StatelessWidget {
  const CustomItemBuilderUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Custom Item Builder',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SmartAutoSuggestBox<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: (context, value) => SmartAutoSuggestItem(
                  value: value,
                  label: value[0].toUpperCase() + value.substring(1),
                  builder: (context, searchText) {
                    final label = value[0].toUpperCase() + value.substring(1);
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(fruitEmojis[value] ?? value[0]),
                      ),
                      title: SmartAutoSuggestHighlightText(
                        text: label,
                        query: searchText,
                      ),
                      subtitle: Text('Value: $value'),
                      trailing: Chip(label: Text('${label.length} letters')),
                    );
                  },
                ),
                initialList: (c) => fruits,
              ),
              tileHeight: 72,
              decoration: const InputDecoration(
                labelText: 'Custom Item Builder',
                border: OutlineInputBorder(),
              ),
              onSelected: (item) {},
            ),
          ],
        ),
      ),
    );
  }
}
