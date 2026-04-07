// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hi locale. All the
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
  String get localeName => 'hi';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "noResultsFound": MessageLookupByLibrary.simpleMessage(
      "कोई परिणाम नहीं मिला",
    ),
    "noResultsFoundHint": MessageLookupByLibrary.simpleMessage(
      "हमे आपके खोज से मेल खाने वाला कोई परिणाम नहीं मिला। कृपया कोई अलग क्वेरी आज़माएँ।",
    ),
    "searchError": MessageLookupByLibrary.simpleMessage("एक त्रुटि हुई"),
    "searchErrorHint": MessageLookupByLibrary.simpleMessage(
      "खोज के दौरान कुछ गलत हो गया। कृपया पुनः प्रयास करें।",
    ),
    "searchingInServer": MessageLookupByLibrary.simpleMessage(
      "सर्वर में खोज जारी है...",
    ),
    "searchingInServerHint": MessageLookupByLibrary.simpleMessage(
      "कृपया प्रतीक्षा करें जब हम सर्वर से परिणाम प्राप्त करते हैं।",
    ),
  };
}
