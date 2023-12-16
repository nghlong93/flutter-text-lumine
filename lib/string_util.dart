import 'dart:collection';

import 'package:diacritic/diacritic.dart';

class StringUtil {
  static final _diacriticPreservedCharacters = HashSet<String>.from(['Ƀ', 'ƀ']);

  static bool isNullOrEmpty(String? str) {
    return str?.isEmpty ?? true;
  }

  static bool isNotNullNorEmpty(String? str) {
    return !isNullOrEmpty(str);
  }

  static bool isNullOrBlank(String? str) {
    return str?.trim().isEmpty ?? true;
  }

  static bool isNotNullNorBlank(String? str) {
    return !isNullOrBlank(str);
  }

  static String removeDiacriticsWithExceptions(String input) {
    return input.replaceAllMapped(RegExp(r'[^\x00-\x7F]'), (match) {
      if (_diacriticPreservedCharacters.contains(match.group(0))) {
        return match.group(0)!;
      } else {
        // Remove other diacritics
        return removeDiacritics(match.group(0)!);
      }
    });
  }

  static bool isCombiningCharacter(int codeUnit) =>
      0x0300 <= codeUnit && codeUnit <= 0x036F;
}
