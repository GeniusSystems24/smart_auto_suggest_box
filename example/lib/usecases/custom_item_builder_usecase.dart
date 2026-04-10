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
          itemBuilder: (context, value) {
            final label = value[0].toUpperCase() + value.substring(1);
            return SmartAutoSuggestItem(
              value: value,
              label: label,
              leadingBuilder: (context, searchText, isFocused) =>
                  CircleAvatar(child: Text(fruitEmojis[value] ?? value[0])),
              titleBuilder: (context, searchText, isFocused) =>
                  SmartAutoSuggestHighlightText(
                    text: label,
                    query: searchText,
                  ),
              subtitleBuilder: (context, searchText, isFocused) =>
                  Text('Value: \$value'),
              trailingBuilder: (context, searchText, isFocused) =>
                  Chip(label: Text('\${label.length} letters')),
            );
          },
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
                itemBuilder: (context, value) {
                  final label = value[0].toUpperCase() + value.substring(1);
                  return SmartAutoSuggestItem(
                    value: value,
                    label: label,
                    leadingBuilder: (context, searchText, isFocused) =>
                        CircleAvatar(
                          child: Text(fruitEmojis[value] ?? value[0]),
                        ),
                    titleBuilder: (context, searchText, isFocused) =>
                        SmartAutoSuggestHighlightText(
                          text: label,
                          query: searchText ?? "",
                        ),
                    subtitleBuilder: (context, searchText, isFocused) =>
                        Text('Value: $value'),
                    trailingBuilder: (context, searchText, isFocused) =>
                        Chip(label: Text('${label.length} letters')),
                  );
                },
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
