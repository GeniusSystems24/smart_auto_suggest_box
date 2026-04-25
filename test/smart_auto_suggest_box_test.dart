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

  test('mergeOverlayCardConstraints leaves unspecified fields at defaults', () {
    const defaults = BoxConstraints(maxHeight: 380);

    expect(
      mergeOverlayCardConstraints(user: null, defaults: defaults),
      defaults,
      reason: 'null user → identical defaults',
    );

    final onlyMinWidth = mergeOverlayCardConstraints(
      user: const BoxConstraints(minWidth: 400),
      defaults: defaults,
    );
    expect(onlyMinWidth.minWidth, 400);
    expect(onlyMinWidth.maxWidth, double.infinity);
    expect(onlyMinWidth.minHeight, 0);
    expect(onlyMinWidth.maxHeight, 380, reason: 'maxHeight inherits default');

    final onlyMaxHeight = mergeOverlayCardConstraints(
      user: const BoxConstraints(maxHeight: 200),
      defaults: defaults,
    );
    expect(onlyMaxHeight.maxHeight, 200, reason: 'user maxHeight overrides');

    final allOverridden = mergeOverlayCardConstraints(
      user: const BoxConstraints(
        minWidth: 100,
        maxWidth: 500,
        minHeight: 50,
        maxHeight: 250,
      ),
      defaults: defaults,
    );
    expect(allOverridden.minWidth, 100);
    expect(allOverridden.maxWidth, 500);
    expect(allOverridden.minHeight, 50);
    expect(allOverridden.maxHeight, 250);
  });

  testWidgets(
    'forcedDirection pins the overlay even when more space exists below',
    (tester) async {
      // Plenty of space below the field; without forcedDirection the
      // overlay would render under it.
      const media = MediaQueryData(
        size: Size(400, 800),
        viewPadding: EdgeInsets.only(top: 24),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            SmartAutoSuggestBoxLocalizations.delegate,
          ],
          supportedLocales:
              SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
          builder: (_, child) => MediaQuery(
            data: media,
            child: child ?? const SizedBox.shrink(),
          ),
          home: Scaffold(
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 300),
                SmartAutoSuggestBox<String>(
                  dataSource: SmartAutoSuggestDataSource(
                    itemBuilder: _itemBuilder,
                    initialList: (_) => _items(3),
                  ),
                  forcedDirection: SmartAutoSuggestBoxDirection.top,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final fieldRect = await _focusField(tester);

      final overlayRect = tester.getRect(find.byType(Scrollbar));
      expect(
        overlayRect.bottom,
        lessThanOrEqualTo(fieldRect.top + 1),
        reason: 'forced top direction should put overlay above the field',
      );
    },
  );

  test('clampOverlayCardConstraintsToScreen caps both axes at viewport', () {
    const screen = Size(400, 600);

    // User asked for an oversized overlay — both axes get clamped down.
    final clamped = clampOverlayCardConstraintsToScreen(
      const BoxConstraints(
        minWidth: 1000,
        maxWidth: 1200,
        maxHeight: 2000,
      ),
      screen,
    );
    expect(clamped.maxWidth, screen.width);
    expect(clamped.maxHeight, screen.height);
    // minWidth must never exceed the new maxWidth (so min ≤ max stays valid).
    expect(clamped.minWidth, screen.width);

    // Already-small constraints pass through unchanged.
    final small = clampOverlayCardConstraintsToScreen(
      const BoxConstraints(maxWidth: 200, maxHeight: 100),
      screen,
    );
    expect(small.maxWidth, 200);
    expect(small.maxHeight, 100);
  });

  testWidgets(
    'overlay never exceeds screen size even when overlayCardConstraints '
    'asks for more',
    (tester) async {
      const screen = Size(400, 700);
      const media = MediaQueryData(
        size: screen,
        viewPadding: EdgeInsets.only(top: 24),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            SmartAutoSuggestBoxLocalizations.delegate,
          ],
          supportedLocales:
              SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
          builder: (_, child) => MediaQuery(
            data: media,
            child: child ?? const SizedBox.shrink(),
          ),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: SmartAutoSuggestBox<String>(
                  dataSource: SmartAutoSuggestDataSource(
                    itemBuilder: _itemBuilder,
                    initialList: (_) => _items(3),
                  ),
                  // Aggressively oversized request — must be clamped.
                  overlayCardConstraints: const BoxConstraints(
                    minWidth: 5000,
                    maxHeight: 5000,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _focusField(tester);

      final overlayRect = tester.getRect(find.byType(Scrollbar));
      expect(
        overlayRect.width,
        lessThanOrEqualTo(screen.width),
        reason: 'overlay width must never exceed screen width',
      );
      expect(
        overlayRect.height,
        lessThanOrEqualTo(screen.height),
        reason: 'overlay height must never exceed screen height',
      );
    },
  );

  testWidgets(
    'overlayCardConstraints widens the overlay when minWidth exceeds '
    'the field width',
    (tester) async {
      const media = MediaQueryData(
        size: Size(800, 800),
        viewPadding: EdgeInsets.only(top: 24),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            SmartAutoSuggestBoxLocalizations.delegate,
          ],
          supportedLocales:
              SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
          builder: (_, child) => MediaQuery(
            data: media,
            child: child ?? const SizedBox.shrink(),
          ),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: SmartAutoSuggestBox<String>(
                  dataSource: SmartAutoSuggestDataSource(
                    itemBuilder: _itemBuilder,
                    initialList: (_) => _items(3),
                  ),
                  // Only minWidth specified — maxWidth/maxHeight inherit
                  // defaults so the existing height behavior is preserved.
                  overlayCardConstraints: const BoxConstraints(minWidth: 500),
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _focusField(tester);

      final overlayRect = tester.getRect(find.byType(Scrollbar));
      expect(
        overlayRect.width,
        greaterThanOrEqualTo(500),
        reason: 'minWidth must widen the overlay beyond the field width',
      );
    },
  );

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
