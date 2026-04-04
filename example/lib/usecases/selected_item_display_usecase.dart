import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class SelectedItemDisplayUseCase extends StatefulWidget {
  const SelectedItemDisplayUseCase({super.key});

  @override
  State<SelectedItemDisplayUseCase> createState() => _SelectedItemDisplayUseCaseState();
}

class _SelectedItemDisplayUseCaseState extends State<SelectedItemDisplayUseCase> {
  final controller = SmartAutoSuggestController<String>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestBox<String>(
        smartController: controller,
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: fruitItemBuilder,
          initialList: (context) => fruits,
        ),
        decoration: const InputDecoration(
          labelText: 'Select with custom display',
        ),
        selectedItemBuilder: (context, item) {
          return InputDecorator(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            child: Chip(
              label: Text(item.label),
              onDeleted: () {
                controller.clearSelection();
              },
            ),
          );
        },
      ),
    );
  }
}''';

class SelectedItemDisplayUseCase extends StatefulWidget {
  const SelectedItemDisplayUseCase({super.key});

  @override
  State<SelectedItemDisplayUseCase> createState() =>
      _SelectedItemDisplayUseCaseState();
}

class _SelectedItemDisplayUseCaseState
    extends State<SelectedItemDisplayUseCase> {
  final controller = SmartAutoSuggestController<String>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Selected Item Builder',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SmartAutoSuggestBox<String>(
              smartController: controller,
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (context) => fruits,
              ),
              selectedItemBuilder: (context, item) {
                return InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: Wrap(
                    children: [
                      Chip(
                        avatar: CircleAvatar(
                          child: Text(fruitEmojis[item.value] ?? item.value[0]),
                        ),
                        label: Text(item.label),
                        onDeleted: () {
                          controller.clearSelection();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
