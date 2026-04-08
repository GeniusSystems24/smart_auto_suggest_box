// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRoute];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  factory: $HomeRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'box-overlay',
      factory: $BoxOverlayRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'view-inline',
      factory: $ViewInlineRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'async-search',
      factory: $AsyncSearchRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'search-mode-always',
      factory: $SearchModeAlwaysRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'error-on-search',
      factory: $ErrorOnSearchRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'dropdown-direction',
      factory: $DropdownDirectionRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'bottom-sheet',
      factory: $BottomSheetRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'custom-no-results',
      factory: $CustomNoResultsRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'custom-item-builder',
      factory: $CustomItemBuilderRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'form-validation',
      factory: $FormValidationRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'selected-item-display',
      factory: $SelectedItemDisplayRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'multi-select-basic',
      factory: $MultiSelectBasicRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'multi-select-max',
      factory: $MultiSelectMaxRoute._fromState,
    ),
  ],
);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BoxOverlayRoute on GoRouteData {
  static BoxOverlayRoute _fromState(GoRouterState state) =>
      const BoxOverlayRoute();

  @override
  String get location => GoRouteData.$location('/box-overlay');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ViewInlineRoute on GoRouteData {
  static ViewInlineRoute _fromState(GoRouterState state) =>
      const ViewInlineRoute();

  @override
  String get location => GoRouteData.$location('/view-inline');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AsyncSearchRoute on GoRouteData {
  static AsyncSearchRoute _fromState(GoRouterState state) =>
      const AsyncSearchRoute();

  @override
  String get location => GoRouteData.$location('/async-search');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SearchModeAlwaysRoute on GoRouteData {
  static SearchModeAlwaysRoute _fromState(GoRouterState state) =>
      const SearchModeAlwaysRoute();

  @override
  String get location => GoRouteData.$location('/search-mode-always');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ErrorOnSearchRoute on GoRouteData {
  static ErrorOnSearchRoute _fromState(GoRouterState state) =>
      const ErrorOnSearchRoute();

  @override
  String get location => GoRouteData.$location('/error-on-search');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DropdownDirectionRoute on GoRouteData {
  static DropdownDirectionRoute _fromState(GoRouterState state) =>
      const DropdownDirectionRoute();

  @override
  String get location => GoRouteData.$location('/dropdown-direction');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BottomSheetRoute on GoRouteData {
  static BottomSheetRoute _fromState(GoRouterState state) =>
      const BottomSheetRoute();

  @override
  String get location => GoRouteData.$location('/bottom-sheet');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CustomNoResultsRoute on GoRouteData {
  static CustomNoResultsRoute _fromState(GoRouterState state) =>
      const CustomNoResultsRoute();

  @override
  String get location => GoRouteData.$location('/custom-no-results');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CustomItemBuilderRoute on GoRouteData {
  static CustomItemBuilderRoute _fromState(GoRouterState state) =>
      const CustomItemBuilderRoute();

  @override
  String get location => GoRouteData.$location('/custom-item-builder');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FormValidationRoute on GoRouteData {
  static FormValidationRoute _fromState(GoRouterState state) =>
      const FormValidationRoute();

  @override
  String get location => GoRouteData.$location('/form-validation');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SelectedItemDisplayRoute on GoRouteData {
  static SelectedItemDisplayRoute _fromState(GoRouterState state) =>
      const SelectedItemDisplayRoute();

  @override
  String get location => GoRouteData.$location('/selected-item-display');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MultiSelectBasicRoute on GoRouteData {
  static MultiSelectBasicRoute _fromState(GoRouterState state) =>
      const MultiSelectBasicRoute();

  @override
  String get location => GoRouteData.$location('/multi-select-basic');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MultiSelectMaxRoute on GoRouteData {
  static MultiSelectMaxRoute _fromState(GoRouterState state) =>
      const MultiSelectMaxRoute();

  @override
  String get location => GoRouteData.$location('/multi-select-max');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
