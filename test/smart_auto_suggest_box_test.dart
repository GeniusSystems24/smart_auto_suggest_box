import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_auto_suggest_box/generated/l10n.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';

List<SmartAutoSuggestItem<String>> _items(int count) {
  return List<SmartAutoSuggestItem<String>>.generate(
    count,
    (index) => SmartAutoSuggestItem<String>(
      value: 'value_$index',
      label: 'Item $index',
    ),
  );
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

      expect(overlayRect.top, greaterThanOrEqualTo(fieldRect.bottom - 1));
      expect(overlayRect.bottom, lessThanOrEqualTo(visibleBottom + 3));
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

      expect(overlayRect.bottom, lessThan(220));
      expect(overlayRect.bottom, lessThanOrEqualTo(visibleBottom + 3));
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
      expect(scrollController.hasClients, isTrue);
      expect(scrollController.offset, 0);

      await _focusField(tester);
      await tester.pump(const Duration(milliseconds: 350));

      expect(scrollController.offset, greaterThan(0));
    },
  );
}
