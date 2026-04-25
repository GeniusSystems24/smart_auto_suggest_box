import 'package:flutter/material.dart';

import '../router/app_router.dart';

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Auto Suggest Use Cases')),
      body: ListView(
        children: [
          _buildListItem(
            context,
            'Floating Overlay',
            'Basic SmartAutoSuggestBox usecase',
            () => const BoxOverlayRoute().push(context),
          ),
          _buildListItem(
            context,
            'Inline View',
            'Basic SmartAutoSuggestView usecase',
            () => const ViewInlineRoute().push(context),
          ),
          _buildListItem(
            context,
            'Async Server Search',
            'Searching with a network delay',
            () => const AsyncSearchRoute().push(context),
          ),
          _buildListItem(
            context,
            'Search Mode: always',
            'Trigger search on every keystroke',
            () => const SearchModeAlwaysRoute().push(context),
          ),
          _buildListItem(
            context,
            'onSearch Error',
            'Error handling when onSearch fails',
            () => const ErrorOnSearchRoute().push(context),
          ),
          _buildListItem(
            context,
            'Dropdown Direction',
            'Test top, bottom, start, end directions',
            () => const DropdownDirectionRoute().push(context),
          ),
          _buildListItem(
            context,
            'BottomSheet View',
            'SmartAutoSuggestView inside a BottomSheet',
            () => const BottomSheetRoute().push(context),
          ),
          _buildListItem(
            context,
            'Custom No-Results',
            'Custom UI when no results are found',
            () => const CustomNoResultsRoute().push(context),
          ),
          _buildListItem(
            context,
            'Custom Item Builder',
            'Custom layout for suggestion items',
            () => const CustomItemBuilderRoute().push(context),
          ),
          _buildListItem(
            context,
            'Form Validation',
            'Usage inside a Form with error text',
            () => const FormValidationRoute().push(context),
          ),
          _buildListItem(
            context,
            'Selected Item Builder',
            'Custom layout for the selected item in the text field',
            () => const SelectedItemDisplayRoute().push(context),
          ),
          _buildListItem(
            context,
            'Basic Multi-Select',
            'SmartAutoSuggestMultiSelectBox basic demo',
            () => const MultiSelectBasicRoute().push(context),
          ),
          _buildListItem(
            context,
            'Max Selections Multi-Select',
            'Multi-Select with max limits',
            () => const MultiSelectMaxRoute().push(context),
          ),
          _buildListItem(
            context,
            'Overlay Tuning',
            'Play with asyncOnCount, forcedDirection and overlayCardConstraints',
            () => const OverlayTuningRoute().push(context),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
