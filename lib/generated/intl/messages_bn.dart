// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a bn locale. All the
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
  String get localeName => 'bn';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "noResultsFound": MessageLookupByLibrary.simpleMessage(
      "কোনও ফলাফল পাওয়া যায়নি",
    ),
    "noResultsFoundHint": MessageLookupByLibrary.simpleMessage(
      "আপনার অনুসন্ধানের সাথে মিলিয়ে কোনও ফলাফল পাওয়া যায়নি। দয়া করে অন্য প্রশ্ন ব্যবহার করুন।",
    ),
    "searchError": MessageLookupByLibrary.simpleMessage("একটি ত্রুটি ঘটেছে"),
    "searchErrorHint": MessageLookupByLibrary.simpleMessage(
      "অনুসন্ধানের সময় কিছু ভুল হয়েছে। দয়া করে আবার চেষ্টা করুন।",
    ),
    "searchingInServer": MessageLookupByLibrary.simpleMessage(
      "সার্ভারে অনুসন্ধান করা হচ্ছে...",
    ),
    "searchingInServerHint": MessageLookupByLibrary.simpleMessage(
      "অনুগ্রহ করে অপেক্ষা করুন যতক্ষণ আমরা সার্ভার থেকে ফলাফল আনছি।",
    ),
  };
}
