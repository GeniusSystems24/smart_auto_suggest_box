import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';
import '../usecases/async_search_usecase.dart';
import '../usecases/bottom_sheet_usecase.dart';
import '../usecases/box_overlay_usecase.dart';
import '../usecases/custom_item_builder_usecase.dart';
import '../usecases/custom_no_results_usecase.dart';
import '../usecases/dropdown_direction_usecase.dart';
import '../usecases/error_on_search_usecase.dart';
import '../usecases/form_validation_usecase.dart';
import '../usecases/multi_select_basic_usecase.dart';
import '../usecases/multi_select_max_usecase.dart';
import '../usecases/search_mode_always_usecase.dart';
import '../usecases/selected_item_display_usecase.dart';
import '../usecases/view_inline_usecase.dart';

part 'app_router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedRoute>[
    TypedGoRoute<BoxOverlayRoute>(path: 'box-overlay'),
    TypedGoRoute<ViewInlineRoute>(path: 'view-inline'),
    TypedGoRoute<AsyncSearchRoute>(path: 'async-search'),
    TypedGoRoute<SearchModeAlwaysRoute>(path: 'search-mode-always'),
    TypedGoRoute<ErrorOnSearchRoute>(path: 'error-on-search'),
    TypedGoRoute<DropdownDirectionRoute>(path: 'dropdown-direction'),
    TypedGoRoute<BottomSheetRoute>(path: 'bottom-sheet'),
    TypedGoRoute<CustomNoResultsRoute>(path: 'custom-no-results'),
    TypedGoRoute<CustomItemBuilderRoute>(path: 'custom-item-builder'),
    TypedGoRoute<FormValidationRoute>(path: 'form-validation'),
    TypedGoRoute<SelectedItemDisplayRoute>(path: 'selected-item-display'),
    TypedGoRoute<MultiSelectBasicRoute>(path: 'multi-select-basic'),
    TypedGoRoute<MultiSelectMaxRoute>(path: 'multi-select-max'),
  ],
)
@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DemoHomePage();
  }
}

@immutable
class BoxOverlayRoute extends GoRouteData {
  const BoxOverlayRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BoxOverlayUseCase();
  }
}

@immutable
class ViewInlineRoute extends GoRouteData {
  const ViewInlineRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ViewInlineUseCase();
  }
}

@immutable
class AsyncSearchRoute extends GoRouteData {
  const AsyncSearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AsyncSearchUseCase();
  }
}

@immutable
class SearchModeAlwaysRoute extends GoRouteData {
  const SearchModeAlwaysRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchModeAlwaysUseCase();
  }
}

@immutable
class ErrorOnSearchRoute extends GoRouteData {
  const ErrorOnSearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ErrorOnSearchUseCase();
  }
}

@immutable
class DropdownDirectionRoute extends GoRouteData {
  const DropdownDirectionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DropdownDirectionUseCase();
  }
}

@immutable
class BottomSheetRoute extends GoRouteData {
  const BottomSheetRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BottomSheetUseCase();
  }
}

@immutable
class CustomNoResultsRoute extends GoRouteData {
  const CustomNoResultsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomNoResultsUseCase();
  }
}

@immutable
class CustomItemBuilderRoute extends GoRouteData {
  const CustomItemBuilderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomItemBuilderUseCase();
  }
}

@immutable
class FormValidationRoute extends GoRouteData {
  const FormValidationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FormValidationUseCase();
  }
}

@immutable
class SelectedItemDisplayRoute extends GoRouteData {
  const SelectedItemDisplayRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SelectedItemDisplayUseCase();
  }
}

@immutable
class MultiSelectBasicRoute extends GoRouteData {
  const MultiSelectBasicRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MultiSelectBasicUseCase();
  }
}

@immutable
class MultiSelectMaxRoute extends GoRouteData {
  const MultiSelectMaxRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MultiSelectMaxUseCase();
  }
}
