import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class DropdownDirectionUseCase extends StatefulWidget {
  const DropdownDirectionUseCase({super.key});

  @override
  State<DropdownDirectionUseCase> createState() => _DropdownDirectionUseCaseState();
}

class _DropdownDirectionUseCaseState extends State<DropdownDirectionUseCase> {
  SmartAutoSuggestBoxDirection _direction = SmartAutoSuggestBoxDirection.top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          DropdownButton<SmartAutoSuggestBoxDirection>(
            value: _direction,
            items: SmartAutoSuggestBoxDirection.values
                .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _direction = v);
            },
          ),
          const SizedBox(height: 100),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (c) => fruits,
            ),
            direction: _direction,
            decoration: const InputDecoration(
              labelText: 'Direction Test',
              border: OutlineInputBorder(),
            ),
            onSelected: (item) {},
          ),
        ],
      ),
    );
  }
}''';

class DropdownDirectionUseCase extends StatefulWidget {
  const DropdownDirectionUseCase({super.key});

  @override
  State<DropdownDirectionUseCase> createState() =>
      _DropdownDirectionUseCaseState();
}

class _DropdownDirectionUseCaseState extends State<DropdownDirectionUseCase> {
  SmartAutoSuggestBoxDirection _direction = SmartAutoSuggestBoxDirection.top;

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Dropdown Direction',
      code: _code,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<SmartAutoSuggestBoxDirection>(
                value: _direction,
                items: SmartAutoSuggestBoxDirection.values
                    .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _direction = v);
                },
              ),
              const SizedBox(height: 100),
              SmartAutoSuggestBox<String>(
                dataSource: SmartAutoSuggestDataSource(
                  itemBuilder: fruitItemBuilder,
                  initialList: (c) => fruits,
                ),
                direction: _direction,
                decoration: const InputDecoration(
                  labelText: 'Direction Test',
                  border: OutlineInputBorder(),
                ),
                onSelected: (item) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
