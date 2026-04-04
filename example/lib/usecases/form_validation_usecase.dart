import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';
import '../data.dart';

class FormValidationUseCase extends StatelessWidget {
  const FormValidationUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: SmartAutoSuggestView<String>.form(
                dataSource: SmartAutoSuggestDataSource(
                  itemBuilder: fruitItemBuilder,
                  initialList: (c) => fruits,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required selection';
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Form Validation (View)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form applies!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form has errors')),
                  );
                }
              },
              child: const Text('Validate'),
            ),
          ],
        ),
      ),
    );
  }
}''';

class FormValidationUseCase extends StatelessWidget {
  const FormValidationUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Form Validation',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FormUseCaseBody(),
      ),
    );
  }
}

class FormUseCaseBody extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  FormUseCaseBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            child: SmartAutoSuggestView<String>.form(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (c) => fruits,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required selection';
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Form Validation (View)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Form applies!')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Form has errors')),
                );
              }
            },
            child: const Text('Validate'),
          ),
        ],
      ),
    );
  }
}
