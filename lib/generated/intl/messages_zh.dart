// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "noResultsFound": MessageLookupByLibrary.simpleMessage("未找到结果"),
    "noResultsFoundHint": MessageLookupByLibrary.simpleMessage(
      "我们无法找到与您的搜索匹配的结果。请尝试不同的查询。",
    ),
    "searchingInServer": MessageLookupByLibrary.simpleMessage("正在服务器中搜索..."),
    "searchingInServerHint": MessageLookupByLibrary.simpleMessage(
      "请稍候，我们正在从服务器获取结果。",
    ),
    "searchError": MessageLookupByLibrary.simpleMessage(
      "发生了错误",
    ),
    "searchErrorHint": MessageLookupByLibrary.simpleMessage(
      "搜索时出了问题。请重试。",
    ),
  };
}
