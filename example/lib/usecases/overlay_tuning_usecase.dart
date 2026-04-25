import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';

import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

// Three knobs on the latest release:
//  • asyncOnCount            — fetch threshold for onNoLocalResults mode
//  • forcedDirection         — pin the overlay to a fixed direction
//  • overlayCardConstraints  — partial BoxConstraints override (merged)
class OverlayTuningUseCase extends StatefulWidget {
  const OverlayTuningUseCase({super.key});

  @override
  State<OverlayTuningUseCase> createState() => _OverlayTuningUseCaseState();
}

class _OverlayTuningUseCaseState extends State<OverlayTuningUseCase> {
  int _asyncOnCount = 3;
  SmartAutoSuggestBoxDirection? _forcedDirection;
  bool _widen = false;
  bool _shortenHeight = false;

  @override
  Widget build(BuildContext context) {
    // Merge only the fields the user asked for — the rest inherit the
    // framework defaults (maxHeight from maxPopupHeight, maxWidth from the
    // field width, etc.).
    final constraints = !_widen && !_shortenHeight
        ? null
        : BoxConstraints(
            minWidth: _widen ? 420 : 0.0,
            maxHeight: _shortenHeight ? 180 : double.infinity,
          );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Controls omitted for brevity
          const SizedBox(height: 80),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (_) => fruits,
              asyncOnCount: _asyncOnCount,
              onSearch: (context, currentItems, searchText) async {
                await Future.delayed(const Duration(milliseconds: 600));
                return ['\$searchText (from server)'];
              },
            ),
            forcedDirection: _forcedDirection,
            overlayCardConstraints: constraints,
            decoration: const InputDecoration(
              labelText: 'Tune the overlay',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}''';

class OverlayTuningUseCase extends StatefulWidget {
  const OverlayTuningUseCase({super.key});

  @override
  State<OverlayTuningUseCase> createState() => _OverlayTuningUseCaseState();
}

class _OverlayTuningUseCaseState extends State<OverlayTuningUseCase> {
  // ── asyncOnCount (fetch threshold) ───────────────────────────────────
  int _asyncOnCount = 3;

  // ── forcedDirection ──────────────────────────────────────────────────
  SmartAutoSuggestBoxDirection? _forcedDirection;

  // ── overlayCardConstraints ───────────────────────────────────────────
  bool _widen = false;
  bool _shortenHeight = false;

  int _serverCallCount = 0;

  @override
  Widget build(BuildContext context) {
    // Build merged constraints only when the user toggles something on —
    // a null value preserves the framework defaults verbatim.
    final constraints = (!_widen && !_shortenHeight)
        ? null
        : BoxConstraints(
            minWidth: _widen ? 420 : 0.0,
            maxHeight: _shortenHeight ? 180 : double.infinity,
          );

    return CodePreviewScaffold(
      title: 'Overlay Tuning',
      code: _code,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          sectionHeader(
            context,
            title: 'asyncOnCount',
            subtitle:
                'Triggers the server fetch whenever the local matches ≤ this '
                'threshold. 0 keeps the legacy "only when empty" behavior.',
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Threshold:'),
              Expanded(
                child: Slider(
                  value: _asyncOnCount.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: '$_asyncOnCount',
                  onChanged: (v) => setState(() => _asyncOnCount = v.round()),
                ),
              ),
              SizedBox(
                width: 28,
                child: Text('$_asyncOnCount', textAlign: TextAlign.end),
              ),
            ],
          ),
          const SizedBox(height: 16),

          sectionHeader(
            context,
            title: 'forcedDirection',
            subtitle:
                'Null → automatic resolution (can fall back when space is '
                'tight). Pick a value to pin the overlay regardless.',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('auto'),
                selected: _forcedDirection == null,
                onSelected: (_) => setState(() => _forcedDirection = null),
              ),
              for (final d in SmartAutoSuggestBoxDirection.values)
                ChoiceChip(
                  label: Text('forced: ${d.name}'),
                  selected: _forcedDirection == d,
                  onSelected: (_) => setState(() => _forcedDirection = d),
                ),
            ],
          ),
          const SizedBox(height: 16),

          sectionHeader(
            context,
            title: 'overlayCardConstraints',
            subtitle:
                'Fields left at their constructor default (0 / infinity) '
                'inherit the framework defaults. Here we only override the '
                'ones you toggle — the rest stay automatic.',
          ),
          const SizedBox(height: 4),
          SwitchListTile(
            dense: true,
            title: const Text('Widen (minWidth: 420)'),
            subtitle: const Text(
              'Overlay grows wider than the input field.',
            ),
            value: _widen,
            onChanged: (v) => setState(() => _widen = v),
          ),
          SwitchListTile(
            dense: true,
            title: const Text('Short height (maxHeight: 180)'),
            subtitle: const Text(
              'maxHeight overrides the automatic ~380 default.',
            ),
            value: _shortenHeight,
            onChanged: (v) => setState(() => _shortenHeight = v),
          ),
          const SizedBox(height: 24),

          // ── Live preview ────────────────────────────────────────────
          sectionHeader(
            context,
            title: 'Live preview',
            subtitle:
                'Type to narrow the local list. When matches drop to ≤ '
                'threshold, a simulated server fetch adds an entry.',
          ),
          const SizedBox(height: 16),
          // Enough breathing room so the auto-direction logic has meaningful
          // choices and forcedDirection is visually different.
          const SizedBox(height: 120),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (_) => fruits,
              asyncOnCount: _asyncOnCount,
              onSearch: (context, currentItems, searchText) async {
                if (mounted) setState(() => _serverCallCount++);
                await Future.delayed(const Duration(milliseconds: 600));
                if (searchText == null || searchText.isEmpty) return const [];
                // Fake a server result that the user can see was added.
                return ['$searchText (from server)'];
              },
            ),
            forcedDirection: _forcedDirection,
            overlayCardConstraints: constraints,
            decoration: const InputDecoration(
              labelText: 'Tune the overlay',
              hintText: 'Try typing "ap", "ma" or an unknown word',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Simulated server calls: $_serverCallCount',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 480),
        ],
      ),
    );
  }
}
