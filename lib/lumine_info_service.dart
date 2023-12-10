import 'package:flutter/painting.dart';
import 'package:text_lumine/lumine_info.dart';
import 'package:text_lumine/string_util.dart';

class LumineInfoService {
  List<LumineInfo> generateLumineInfoList(String text, List<String> substrings,
      {bool ignoreDiacritics = false,
      bool ignoreCase = false,
      bool ignoreWordBoundaries = false,
      TextStyle? style}) {
    var haystack = _transformText(text, ignoreDiacritics, ignoreCase);

    List<LumineInfo> lumineInfoList = [];

    for (var substring in substrings) {
      if (substring.trim().isEmpty) {
        continue;
      }

      var searchText =
          _transformText(substring, ignoreDiacritics, ignoreCase).trim();

      var index = -1;
      var start = 0;

      do {
        if (ignoreWordBoundaries) {
          index = haystack.indexOf(searchText, start);
        } else {
          index = haystack.indexOf(
              RegExp("(?<!\\w)${RegExp.escape(searchText)}(?!\\w)",
                  caseSensitive: !ignoreCase, unicode: true),
              start);
        }

        if (index >= 0) {
          lumineInfoList
              .add(LumineInfo(index, length: searchText.length, style: style));
          start = index + searchText.length;
        }
      } while (index >= 0 && start < haystack.length);
    }

    return lumineInfoList;
  }

  List<LumineInfo> rectifyHighlightInfoList(
      String text, List<LumineInfo>? lumineInfoList) {
    if (lumineInfoList?.isEmpty ?? true) {
      return [];
    }

    final List<LumineInfo> updatedLumineInfoList = List.from(lumineInfoList!);

    updatedLumineInfoList.sort((firstInfo, secondInfo) =>
        firstInfo.startIndex.compareTo(secondInfo.startIndex));

    // Update length.
    for (var index = 0; index < updatedLumineInfoList.length - 1; index++) {
      final currentLumineInfo = updatedLumineInfoList[index];
      final nextLumineInfo = updatedLumineInfoList[index + 1];
      final currentLumineLength = currentLumineInfo.length ??
          (text.length - currentLumineInfo.startIndex);
      final currentLumineEndIndex =
          currentLumineInfo.startIndex + currentLumineLength;

      if (currentLumineEndIndex >= nextLumineInfo.startIndex) {
        // Current highlight is overlap with the next highlight.
        final highlightLength =
            nextLumineInfo.startIndex - currentLumineInfo.startIndex;

        if (highlightLength > 0) {
          currentLumineInfo.length = highlightLength;
        } else {
          currentLumineInfo.length = 0;
        }
      } else {
        currentLumineInfo.length ??= currentLumineLength;
      }
    }

    updatedLumineInfoList.last.length ??=
        text.length - updatedLumineInfoList.last.startIndex;

    return updatedLumineInfoList;
  }

  String _transformText(
      String text, bool removeAllDiacritics, bool toLowerCase) {
    String transformedText;

    if (removeAllDiacritics) {
      transformedText = StringUtil.removeDiacriticsWithExceptions(text);
    } else {
      transformedText = text;
    }

    if (toLowerCase) {
      transformedText = transformedText.toLowerCase();
    }

    return transformedText;
  }
}
