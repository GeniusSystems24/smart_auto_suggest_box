import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';
import '../data.dart';

class BottomSheetUseCase extends StatelessWidget {
  const BottomSheetUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) => Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('BottomSheet Title', style: TextStyle(fontSize: 20)),
                  ),
                  Expanded(
                    child: SmartAutoSuggestView<String>(
                      dataSource: SmartAutoSuggestDataSource(
                        itemBuilder: fruitItemBuilder,
                        initialList: (context) => fruits,
                      ),
                      showListWhenEmpty: true,
                      listMaxHeight: double.infinity,
                      onSelected: (item) => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Text('Show Bottom Sheet'),
      ),
    );
  }
}''';

class BottomSheetUseCase extends StatelessWidget {
  const BottomSheetUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'BottomSheet View',
      code: _code,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => DraggableScrollableSheet(
                expand: false,
                builder: (context, scrollController) => Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'BottomSheet Title',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: SmartAutoSuggestView<String>(
                        dataSource: SmartAutoSuggestDataSource(
                          itemBuilder: fruitItemBuilder,
                          initialList: (context) => fruits,
                        ),
                        showListWhenEmpty: true,
                        listMaxHeight: double.infinity,
                        onSelected: (item) => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}
