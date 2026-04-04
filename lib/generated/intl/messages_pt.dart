// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "noResultsFound": MessageLookupByLibrary.simpleMessage(
      "Nenhum resultado encontrado",
    ),
    "noResultsFoundHint": MessageLookupByLibrary.simpleMessage(
      "Não conseguimos encontrar resultados correspondentes à sua pesquisa. Tente outra consulta.",
    ),
    "searchingInServer": MessageLookupByLibrary.simpleMessage(
      "Pesquisando no servidor...",
    ),
    "searchingInServerHint": MessageLookupByLibrary.simpleMessage(
      "Aguarde enquanto buscamos os resultados do servidor.",
    ),
    "searchError": MessageLookupByLibrary.simpleMessage(
      "Ocorreu um erro",
    ),
    "searchErrorHint": MessageLookupByLibrary.simpleMessage(
      "Algo deu errado durante a pesquisa. Tente novamente.",
    ),
  };
}
