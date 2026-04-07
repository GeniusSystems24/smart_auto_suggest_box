// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
    ];

RouteBase get $homeRoute => GoRoute(
      path: '/',
      name: 'HomeRoute',
      builder: (BuildContext context, GoRouterState state) =>
          const HomeRoute().build(context, state),
      routes: [
        GoRoute(
          path: 'box-overlay',
          name: 'BoxOverlayRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const BoxOverlayRoute().build(context, state),
        ),
        GoRoute(
          path: 'view-inline',
          name: 'ViewInlineRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const ViewInlineRoute().build(context, state),
        ),
        GoRoute(
          path: 'async-search',
          name: 'AsyncSearchRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const AsyncSearchRoute().build(context, state),
        ),
        GoRoute(
          path: 'search-mode-always',
          name: 'SearchModeAlwaysRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const SearchModeAlwaysRoute().build(context, state),
        ),
        GoRoute(
          path: 'error-on-search',
          name: 'ErrorOnSearchRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const ErrorOnSearchRoute().build(context, state),
        ),
        GoRoute(
          path: 'dropdown-direction',
          name: 'DropdownDirectionRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const DropdownDirectionRoute().build(context, state),
        ),
        GoRoute(
          path: 'bottom-sheet',
          name: 'BottomSheetRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const BottomSheetRoute().build(context, state),
        ),
        GoRoute(
          path: 'custom-no-results',
          name: 'CustomNoResultsRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const CustomNoResultsRoute().build(context, state),
        ),
        GoRoute(
          path: 'custom-item-builder',
          name: 'CustomItemBuilderRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const CustomItemBuilderRoute().build(context, state),
        ),
        GoRoute(
          path: 'form-validation',
          name: 'FormValidationRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const FormValidationRoute().build(context, state),
        ),
        GoRoute(
          path: 'selected-item-display',
          name: 'SelectedItemDisplayRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const SelectedItemDisplayRoute().build(context, state),
        ),
        GoRoute(
          path: 'multi-select-basic',
          name: 'MultiSelectBasicRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const MultiSelectBasicRoute().build(context, state),
        ),
        GoRoute(
          path: 'multi-select-max',
          name: 'MultiSelectMaxRoute',
          builder: (BuildContext context, GoRouterState state) =>
              const MultiSelectMaxRoute().build(context, state),
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location('/');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BoxOverlayRouteExtension on BoxOverlayRoute {
  static BoxOverlayRoute _fromState(GoRouterState state) =>
      const BoxOverlayRoute();

  String get location => GoRouteData.$location('/box-overlay');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ViewInlineRouteExtension on ViewInlineRoute {
  static ViewInlineRoute _fromState(GoRouterState state) =>
      const ViewInlineRoute();

  String get location => GoRouteData.$location('/view-inline');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AsyncSearchRouteExtension on AsyncSearchRoute {
  static AsyncSearchRoute _fromState(GoRouterState state) =>
      const AsyncSearchRoute();

  String get location => GoRouteData.$location('/async-search');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SearchModeAlwaysRouteExtension on SearchModeAlwaysRoute {
  static SearchModeAlwaysRoute _fromState(GoRouterState state) =>
      const SearchModeAlwaysRoute();

  String get location => GoRouteData.$location('/search-mode-always');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ErrorOnSearchRouteExtension on ErrorOnSearchRoute {
  static ErrorOnSearchRoute _fromState(GoRouterState state) =>
      const ErrorOnSearchRoute();

  String get location => GoRouteData.$location('/error-on-search');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DropdownDirectionRouteExtension on DropdownDirectionRoute {
  static DropdownDirectionRoute _fromState(GoRouterState state) =>
      const DropdownDirectionRoute();

  String get location => GoRouteData.$location('/dropdown-direction');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BottomSheetRouteExtension on BottomSheetRoute {
  static BottomSheetRoute _fromState(GoRouterState state) =>
      const BottomSheetRoute();

  String get location => GoRouteData.$location('/bottom-sheet');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CustomNoResultsRouteExtension on CustomNoResultsRoute {
  static CustomNoResultsRoute _fromState(GoRouterState state) =>
      const CustomNoResultsRoute();

  String get location => GoRouteData.$location('/custom-no-results');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CustomItemBuilderRouteExtension on CustomItemBuilderRoute {
  static CustomItemBuilderRoute _fromState(GoRouterState state) =>
      const CustomItemBuilderRoute();

  String get location => GoRouteData.$location('/custom-item-builder');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FormValidationRouteExtension on FormValidationRoute {
  static FormValidationRoute _fromState(GoRouterState state) =>
      const FormValidationRoute();

  String get location => GoRouteData.$location('/form-validation');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SelectedItemDisplayRouteExtension on SelectedItemDisplayRoute {
  static SelectedItemDisplayRoute _fromState(GoRouterState state) =>
      const SelectedItemDisplayRoute();

  String get location => GoRouteData.$location('/selected-item-display');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MultiSelectBasicRouteExtension on MultiSelectBasicRoute {
  static MultiSelectBasicRoute _fromState(GoRouterState state) =>
      const MultiSelectBasicRoute();

  String get location => GoRouteData.$location('/multi-select-basic');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MultiSelectMaxRouteExtension on MultiSelectMaxRoute {
  static MultiSelectMaxRoute _fromState(GoRouterState state) =>
      const MultiSelectMaxRoute();

  String get location => GoRouteData.$location('/multi-select-max');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
