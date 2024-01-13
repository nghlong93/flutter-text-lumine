# text_lumine
A simple widget that displays text with highlighted sub-strings.

The widget supports two constructors:
- The first one is an unnamed constructor. You can use this one when you have already calculated the positions of all highlighted sub-strings. Here is the parameter list:
  - text *\[required\]*: The whole text that is displayed on the UI
  - key *\[optional\]*: A key to identify the widget
  - normalTextStyle *\[optional\]*: The style of unhighlighted text
  - lumineInfoList *\[optional\]*: a list of **LumineInfo** objects. Each **LumineInfo** object contain the information of the highlight position. If the list is null or empty, the widget will render a normal Text widget. Here are properties of a **LumineInfo** object:
    - startIndex *\[required\]*: The index of the first character to highlight
    - length *\[optional\]*: Length of the highlighted sub-string. If it is undefined, the widget will highlight till the end of the text
    - style *\[optional\]*: Style of the highlighted sub-string

- The second one is a named constructor which is `TextLumine.withHighlightedSubstrings`. With this constructor, you only have to provide a list of sub-strings that you wish to highlight. The widget will automatically find those sub-strings. The parameters of this constructor are listed below:
  - text *\[required\]*: The whole text that is displayed on the UI
  - substrings *\[required\]*: A list of sub-strings to highlight
  - key *\[optional\]*: A key to identify the widget
  - normalTextStyle *\[optional\]*: The style of unhighlighted text
  - ignoreDiacritics *\[optional\]*: Search for sub-strings without considering the diacritics
  - ignoreCase *\[optional\]*: Enable case-insensitive when searching for sub-strings
  - highlightTextStyle *\[optional\]*: The text style of the highlighted sub-strings

Here are examples for those two constructors:

```dart
import 'package:text_lumine/text_lumine.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return TextLumine(
      'Text to highlight', 
      lumineInfoList: [LumineInfo(8)]
    );
  }
}
```

```dart
import 'package:text_lumine/text_lumine.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return TextLumine.withHighlightedSubstrings('Text to highlight', substrings: const ["highlight"]);
  }
}
```
