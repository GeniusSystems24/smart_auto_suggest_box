import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Auto Suggest Box Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SmartAutoSuggestBoxExample(),
    );
  }
}

/// Sample items for the auto suggest box
final List<SmartAutoSuggestBoxItem<String>> _fruits = [
  SmartAutoSuggestBoxItem(value: 'apple', label: 'Apple'),
  SmartAutoSuggestBoxItem(value: 'banana', label: 'Banana'),
  SmartAutoSuggestBoxItem(value: 'cherry', label: 'Cherry'),
  SmartAutoSuggestBoxItem(value: 'date', label: 'Date'),
  SmartAutoSuggestBoxItem(value: 'elderberry', label: 'Elderberry'),
  SmartAutoSuggestBoxItem(value: 'fig', label: 'Fig'),
  SmartAutoSuggestBoxItem(value: 'grape', label: 'Grape'),
  SmartAutoSuggestBoxItem(value: 'honeydew', label: 'Honeydew'),
  SmartAutoSuggestBoxItem(value: 'kiwi', label: 'Kiwi'),
  SmartAutoSuggestBoxItem(value: 'lemon', label: 'Lemon'),
  SmartAutoSuggestBoxItem(value: 'mango', label: 'Mango'),
  SmartAutoSuggestBoxItem(value: 'orange', label: 'Orange'),
];

class SmartAutoSuggestBoxExample extends StatefulWidget {
  const SmartAutoSuggestBoxExample({super.key});

  @override
  State<SmartAutoSuggestBoxExample> createState() =>
      _SmartAutoSuggestBoxExampleState();
}

class _SmartAutoSuggestBoxExampleState
    extends State<SmartAutoSuggestBoxExample> {
  SmartAutoSuggestBoxDirection _selectedDirection =
      SmartAutoSuggestBoxDirection.bottom;
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Auto Suggest Box'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Direction selector
            const Text(
              'Dropdown Direction:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<SmartAutoSuggestBoxDirection>(
              segments: const [
                ButtonSegment(
                  value: SmartAutoSuggestBoxDirection.bottom,
                  label: Text('Bottom'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: SmartAutoSuggestBoxDirection.top,
                  label: Text('Top'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: SmartAutoSuggestBoxDirection.start,
                  label: Text('Start'),
                  icon: Icon(Icons.arrow_back),
                ),
                ButtonSegment(
                  value: SmartAutoSuggestBoxDirection.end,
                  label: Text('End'),
                  icon: Icon(Icons.arrow_forward),
                ),
              ],
              selected: {_selectedDirection},
              onSelectionChanged: (value) {
                setState(() => _selectedDirection = value.first);
              },
            ),
            const SizedBox(height: 24),
            // Info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Positioning',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The dropdown automatically repositions itself when '
                      'there is not enough space in the preferred direction. '
                      'Try placing the text field near screen edges to see '
                      'the fallback behavior.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Auto suggest box
            SmartAutoSuggestBox<String>(
              items: List.from(_fruits),
              direction: _selectedDirection,
              decoration: const InputDecoration(
                labelText: 'Search fruits',
                hintText: 'Type to search...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSelected: (item) {
                if (item != null) {
                  setState(() => _selectedValue = item.label);
                }
              },
              onChanged: (text, reason) {
                if (reason == FluentTextChangedReason.cleared) {
                  setState(() => _selectedValue = null);
                }
              },
            ),
            const SizedBox(height: 16),
            if (_selectedValue != null)
              Text(
                'Selected: $_selectedValue',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            const Spacer(),
            // Bottom example - demonstrates auto-repositioning to top
            const Text(
              'Bottom positioned field (will auto-flip to top):',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            SmartAutoSuggestBox<String>(
              items: List.from(_fruits),
              direction: SmartAutoSuggestBoxDirection.bottom,
              decoration: const InputDecoration(
                labelText: 'Near bottom edge',
                hintText: 'Dropdown flips to top automatically',
                border: OutlineInputBorder(),
              ),
              onSelected: (item) {},
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
