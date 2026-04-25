// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';

List<String> _items(int count) {
  return List<String>.generate(count, (index) => 'value_$index');
}

SmartAutoSuggestItem<String> _itemBuilder(BuildContext context, String value) {
  final index = value.replaceFirst('value_', '');
  return SmartAutoSuggestItem<String>(value: value, label: 'Item $index');
}

Widget _testApp({
  required MediaQueryData mediaQueryData,
  required SmartAutoSuggestBoxDirection direction,
  required double topSpacer,
  required int itemCount,
  ScrollController? scrollController,
  TextDirection textDirection = TextDirection.ltr,
}) {
  return MaterialApp(
    localizationsDelegates: const [SmartAutoSuggestBoxLocalizations.delegate],
    supportedLocales:
        SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
    builder: (context, child) {
      return MediaQuery(
        data: mediaQueryData,
        child: Directionality(
          textDirection: textDirection,
          child: child ?? const SizedBox.shrink(),
        ),
      );
    },
    home: Scaffold(
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: topSpacer),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: _itemBuilder,
              initialList: (_) => _items(itemCount),
            ),
            direction: direction,
            maxPopupHeight: kSmartAutoSuggestBoxPopupMaxHeight,
            decoration: const InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 1400),
        ],
      ),
    ),
  );
}

Finder _textInputFinder() {
  final editable = find.byType(EditableText);
  if (editable.evaluate().isNotEmpty) return editable.first;

  final textField = find.byType(TextField);
  if (textField.evaluate().isNotEmpty) return textField.first;

  final inputDecorator = find.byType(InputDecorator);
  if (inputDecorator.evaluate().isNotEmpty) return inputDecorator.first;

  return find.byType(SmartAutoSuggestBox<String>);
}

Future<Rect> _focusField(WidgetTester tester) async {
  final initialFinder = _textInputFinder();
  await tester.ensureVisible(initialFinder);
  await tester.pump();

  final finder = _textInputFinder();
  final inputRect = tester.getRect(finder);
  await tester.tap(finder);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  return inputRect;
}

void main() {
  testWidgets(
    'SmartAutoSuggestBox does not trigger async search side-effects during build',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            SmartAutoSuggestBoxLocalizations.delegate,
          ],
          supportedLocales:
              SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
          home: Scaffold(
            body: SmartAutoSuggestBox<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: _itemBuilder,
                initialList: (_) => ['apple'],
                onSearch: (_, currentItems, searchText) async => <String>[],
              ),
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final input = find.byType(TextField);
      await tester.tap(input);
      await tester.pump();
      await tester.enterText(input, 'zzz');
      await tester.pump();
    },
  );

  testWidgets(
    'SmartAutoSuggestView does not trigger async search side-effects during build',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            SmartAutoSuggestBoxLocalizations.delegate,
          ],
          supportedLocales:
              SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
          home: Scaffold(
            body: SmartAutoSuggestView<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: _itemBuilder,
                initialList: (_) => ['apple'],
                onSearch: (_, currentItems, searchText) async => <String>[],
              ),
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final input = find.byType(TextField);
      await tester.enterText(input, 'zzz');
      await tester.pump();
    },
  );

  testWidgets(
    'keeps preferred bottom direction when enough keyboard-aware space exists',
    (tester) async {
      const media = MediaQueryData(
        size: Size(400, 500),
        viewPadding: EdgeInsets.only(top: 24),
        viewInsets: EdgeInsets.only(bottom: 250),
      );

      await tester.pumpWidget(
        _testApp(
          mediaQueryData: media,
          direction: SmartAutoSuggestBoxDirection.bottom,
          topSpacer: 110,
          itemCount: 4,
        ),
      );
      await tester.pumpAndSettle();
      final fieldRect = await _focusField(tester);

      final overlayRect = tester.getRect(find.byType(Scrollbar));
      final visibleBottom = media.size.height - media.viewInsets.bottom;
    },
  );

  testWidgets(
    'falls back from bottom to top when keyboard leaves insufficient bottom space',
    (tester) async {
      const media = MediaQueryData(
        size: Size(400, 800),
        viewPadding: EdgeInsets.only(top: 24),
        viewInsets: EdgeInsets.only(bottom: 250),
      );

      await tester.pumpWidget(
        _testApp(
          mediaQueryData: media,
          direction: SmartAutoSuggestBoxDirection.bottom,
          topSpacer: 150,
          itemCount: 2,
        ),
      );
      await tester.pumpAndSettle();
      await _focusField(tester);

      final overlayRect = tester.getRect(find.byType(Scrollbar));
      final visibleBottom = media.size.height - media.viewInsets.bottom;
    },
  );

  testWidgets(
    'auto-scrolls nearest scrollable when no direction has enough space',
    (tester) async {
      const media = MediaQueryData(
        size: Size(400, 700),
        viewPadding: EdgeInsets.only(top: 24),
        viewInsets: EdgeInsets.only(bottom: 300),
      );
      final scrollController = ScrollController();

      await tester.pumpWidget(
        _testApp(
          mediaQueryData: media,
          direction: SmartAutoSuggestBoxDirection.bottom,
          topSpacer: 210,
          itemCount: 20,
          scrollController: scrollController,
        ),
      );
      await tester.pumpAndSettle();

      expect(scrollController.offset, 0);

      await _focusField(tester);
      await tester.pump(const Duration(milliseconds: 350));
    },
  );

  testWidgets('SmartAutoSuggestView does not overflow in bounded height', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          SmartAutoSuggestBoxLocalizations.delegate,
        ],
        supportedLocales:
            SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            height: 320,
            child: SmartAutoSuggestView<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: _itemBuilder,
                initialList: (_) => _items(20),
              ),
              showListWhenEmpty: true,
              listMaxHeight: double.infinity,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  });

  testWidgets(
    'isLoading is reset even when a stale concurrent search completes after '
    'a newer search has finished',
    (tester) async {
      final firstCompleter = Completer<List<String>>();
      final secondCompleter = Completer<List<String>>();
      var callCount = 0;

      final dataSource = SmartAutoSuggestDataSource<String>(
        itemBuilder: _itemBuilder,
        onSearch: (_, _, _) {
          callCount++;
          return callCount == 1
              ? firstCompleter.future
              : secondCompleter.future;
        },
      );

      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // Start two overlapping searches.
      final first = dataSource.search(capturedContext, 'aaa');
      final second = dataSource.search(capturedContext, 'bbb');

      // Newer search completes first.
      secondCompleter.complete(const ['from-server']);
      await second;

      // Older completion arrives after — must NOT flip isLoading back to
      // true and must not get stuck.
      firstCompleter.complete(const ['stale']);
      await first;
    },
  );

  testWidgets('isLoading is reset when onSearch throws', (tester) async {
    final dataSource = SmartAutoSuggestDataSource<String>(
      itemBuilder: _itemBuilder,
      onSearch: (_, _, _) async => throw StateError('boom'),
    );

    late BuildContext capturedContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    await dataSource.search(capturedContext, 'q');
  });

  testWidgets(
    'asyncOnCount triggers a server fetch when local matches drop to the '
    'configured threshold',
    (tester) async {
      var serverCallCount = 0;
      final dataSource = SmartAutoSuggestDataSource<String>(
        itemBuilder: _itemBuilder,
        initialList: (_) => _items(20),
        asyncOnCount: 5,
        onSearch: (_, _, _) async {
          serverCallCount++;
          return const <String>[];
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            SmartAutoSuggestBoxLocalizations.delegate,
          ],
          supportedLocales:
              SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
          home: Scaffold(
            body: SmartAutoSuggestBox<String>(
              dataSource: dataSource,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 'Item 1' matches Item 1, 10..19 → 11 results, above threshold 5,
      // so no server fetch.
      await tester.enterText(find.byType(TextField), 'Item 1');
      await tester.pumpAndSettle();
      expect(serverCallCount, 0);

      // 'Item 11' matches a single item (1 ≤ 5) → triggers a fetch.
      await tester.enterText(find.byType(TextField), 'Item 11');
      await tester.pumpAndSettle();
      expect(serverCallCount, 1);
    },
  );
}
