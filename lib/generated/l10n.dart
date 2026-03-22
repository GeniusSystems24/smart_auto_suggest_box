// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class SmartAutoSuggestBoxLocalizations {
  SmartAutoSuggestBoxLocalizations();

  static SmartAutoSuggestBoxLocalizations? _current;

  static SmartAutoSuggestBoxLocalizations get current {
    assert(
      _current != null,
      'No instance of SmartAutoSuggestBoxLocalizations was loaded. Try to initialize the SmartAutoSuggestBoxLocalizations delegate before accessing SmartAutoSuggestBoxLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<SmartAutoSuggestBoxLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = SmartAutoSuggestBoxLocalizations();
      SmartAutoSuggestBoxLocalizations._current = instance;

      return instance;
    });
  }

  static SmartAutoSuggestBoxLocalizations of(BuildContext context) {
    final instance = SmartAutoSuggestBoxLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of SmartAutoSuggestBoxLocalizations present in the widget tree. Did you add SmartAutoSuggestBoxLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static SmartAutoSuggestBoxLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<SmartAutoSuggestBoxLocalizations>(
      context,
      SmartAutoSuggestBoxLocalizations,
    );
  }

  /// `Searching in server...`
  String get searchingInServer {
    return Intl.message(
      'Searching in server...',
      name: 'searchingInServer',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while we fetch the results from the server.`
  String get searchingInServerHint {
    return Intl.message(
      'Please wait while we fetch the results from the server.',
      name: 'searchingInServerHint',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't find any results matching your search. Please try a different query.`
  String get noResultsFoundHint {
    return Intl.message(
      'We couldn\'t find any results matching your search. Please try a different query.',
      name: 'noResultsFoundHint',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<SmartAutoSuggestBoxLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<SmartAutoSuggestBoxLocalizations> load(Locale locale) =>
      SmartAutoSuggestBoxLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
