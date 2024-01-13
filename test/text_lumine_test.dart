import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_lumine/lumine_info.dart';

import 'package:text_lumine/text_lumine.dart';

void main() {
  testWidgets('Text lumine has RichText and its InlineSpan is TextSpan',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["test"])));

    // Create the Finder.
    final richTextFinder = find.text(text, findRichText: true);

    // Expect to find the rich text.
    expect(richTextFinder, findsOneWidget);

    // Expect main text span
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text;

    expect(mainTextSpan, const TypeMatcher<TextSpan>());
  });

  testWidgets('Text lumine has correct TextSpans with highlighted words',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["test"])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 2);

    expect(textSpanChildren[0].toPlainText(), "How to ");
    expect(textSpanChildren[1].toPlainText(), "test");
  });

  testWidgets(
      'Text lumine has correct TextSpans with duplicated highlighted words',
      (tester) async {
    const text = "test how to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["test"])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 3);

    expect(textSpanChildren[0].toPlainText(), "test");
    expect(textSpanChildren[1].toPlainText(), " how to ");
    expect(textSpanChildren[2].toPlainText(), "test");
  });

  testWidgets(
      'Text lumine has correct TextSpans with a highlighted word that could be mistaken as a substring',
      (tester) async {
    const text = "Nightmares are common in children but can happen at any age";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["are"])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 3);

    expect(textSpanChildren[0].toPlainText(), "Nightmares ");
    expect(textSpanChildren[1].toPlainText(), "are");
    expect(textSpanChildren[2].toPlainText(),
        " common in children but can happen at any age");
  });

  testWidgets(
      'Text lumine has correct TextSpans with a highlighted word that could be mistaken as a substring, followed by a comma',
      (tester) async {
    const text = "Nightmares are, common in children but can happen at any age";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["are"])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 3);

    expect(textSpanChildren[0].toPlainText(), "Nightmares ");
    expect(textSpanChildren[1].toPlainText(), "are");
    expect(textSpanChildren[2].toPlainText(),
        ", common in children but can happen at any age");
  });

  testWidgets(
      'Text lumine has correct TextSpans with a highlighted unicode word that could be mistaken as a substring, followed by a punctation',
      (tester) async {
    const text =
        "Gia vị gồm muối, đường, tiêu và ớt. Mặt trời làm bốc hơi nước biển, để lại muối.";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["muối"])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 5);

    expect(textSpanChildren[0].toPlainText(), "Gia vị gồm ");
    expect(textSpanChildren[1].toPlainText(), "muối");
    expect(textSpanChildren[2].toPlainText(),
        ", đường, tiêu và ớt. Mặt trời làm bốc hơi nước biển, để lại ");
    expect(textSpanChildren[3].toPlainText(), "muối");
    expect(textSpanChildren[4].toPlainText(), ".");
  });

  testWidgets(
      'Text lumine has correct TextSpans with highlighted substrings ignoring word boundaries',
      (tester) async {
    const text = "Nightmares are common in children but can happen at any age";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["are"], ignoreWordBoundaries: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 5);

    expect(textSpanChildren[0].toPlainText(), "Nightm");
    expect(textSpanChildren[1].toPlainText(), "are");
    expect(textSpanChildren[2].toPlainText(), "s ");
    expect(textSpanChildren[3].toPlainText(), "are");
    expect(textSpanChildren[4].toPlainText(),
        " common in children but can happen at any age");
  });

  testWidgets(
      'Text lumine has correct TextSpans with highlighted words considering diacritics',
      (tester) async {
    const text = "Làm sao để thử nghiệm";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["thử nghiệm", "Lam sao"])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 2);

    expect(textSpanChildren[0].toPlainText(), "Làm sao để ");
    expect(textSpanChildren[1].toPlainText(), "thử nghiệm");
  });

  testWidgets(
      'Text lumine has correct TextSpans with highlighted words regardless of diacritics',
      (tester) async {
    const text = "Làm sao để thử nghiệm";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["thu nghiem"], ignoreDiacritics: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 2);

    expect(textSpanChildren[0].toPlainText(), "Làm sao để ");
    expect(textSpanChildren[1].toPlainText(), "thử nghiệm");
  });

  testWidgets(
      'Text lumine builds Text widget without highlighted word considering case',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["Test"])));

    // Expect.
    final textFinder = find.text(text);
    final elements = textFinder.evaluate();

    expect(elements.length, isPositive);

    final textWidget = textFinder.evaluate().single.widget;

    expect(textWidget, const TypeMatcher<Text>());
    expect((textWidget as Text).data, text);
  });

  testWidgets(
      'Text lumine has correct TextSpans with highlighted words ignoring case',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["Test"], ignoreCase: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 2);

    expect(textSpanChildren[0].toPlainText(), "How to ");
    expect(textSpanChildren[1].toPlainText(), "test");
  });

  testWidgets('Text lumine has correct TextSpans with LumineInfo list',
      (tester) async {
    const text = "How to do a test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine(text,
            lumineInfoList: [LumineInfo(4, length: 2), LumineInfo(12)])));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 4);

    expect(textSpanChildren[0].toPlainText(), "How ");
    expect(textSpanChildren[1].toPlainText(), "to");
    expect(textSpanChildren[2].toPlainText(), " do a ");
    expect(textSpanChildren[3].toPlainText(), "test");
  });

  testWidgets(
      'Text lumine builds Text widget without neither highlighted words nor lumine info list',
      (tester) async {
    const text = "How to test";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr, child: TextLumine(text)));

    // Expect.
    final textFinder = find.text(text);
    final elements = textFinder.evaluate();

    expect(elements.length, isPositive);

    final textWidget = textFinder.evaluate().single.widget;

    expect(textWidget, const TypeMatcher<Text>());
    expect((textWidget as Text).data, text);
  });

  testWidgets(
      'Text lumine has correct TextSpans with a highlighted unicode word with reserved characters, ignore diacritics',
      (tester) async {
    const text =
        "Ƀiădah ƀing mơnuih anun ƀu hmư̌ ôh pô tha; yua anun pô đah rơkơi anun mơ mă bơnai hơjung ñu ba pơ gah rơngiao brơi kơ ƀing anun, ƀing anun thâo pô bơnai hăng kơtư̌ ñu abih mlam truh pơ mơguah; hăng lơm tơgǔ sing bring, gơñu mơ lui bơnai anun nao.";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["anun"],
            ignoreDiacritics: true,
            ignoreCase: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 13);

    expect(textSpanChildren[0].toPlainText(), "Ƀiădah ƀing mơnuih ");
    expect(textSpanChildren[1].toPlainText(), "anun");
    expect(textSpanChildren[2].toPlainText(), " ƀu hmư̌ ôh pô tha; yua ");
    expect(textSpanChildren[3].toPlainText(), "anun");
    expect(textSpanChildren[4].toPlainText(), " pô đah rơkơi ");
    expect(textSpanChildren[5].toPlainText(), "anun");
    expect(textSpanChildren[6].toPlainText(),
        " mơ mă bơnai hơjung ñu ba pơ gah rơngiao brơi kơ ƀing ");
    expect(textSpanChildren[7].toPlainText(), "anun");
    expect(textSpanChildren[8].toPlainText(), ", ƀing ");
    expect(textSpanChildren[9].toPlainText(), "anun");
    expect(textSpanChildren[10].toPlainText(),
        " thâo pô bơnai hăng kơtư̌ ñu abih mlam truh pơ mơguah; hăng lơm tơgǔ sing bring, gơñu mơ lui bơnai ");
    expect(textSpanChildren[11].toPlainText(), "anun");
    expect(textSpanChildren[12].toPlainText(), " nao.");
  });

  testWidgets(
      'Text lumine has correct TextSpans with highlighted unicode words with combining characters, ignore diacritics',
      (tester) async {
    const text =
        "Ƀiădah ƀing mơnuih anun ƀu hmư̌ ôh pô tha; yua anun pô đah rơkơi anun mơ mă bơnai hơjung ñu ba pơ gah rơngiao brơi kơ ƀing anun, ƀing anun thâo pô bơnai hăng kơtư̌ ñu abih mlam truh pơ mơguah; hăng lơm tơgǔ sing bring, gơñu mơ lui bơnai anun nao.";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["anun", "pô"],
            ignoreDiacritics: true,
            ignoreCase: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 23);

    expect(textSpanChildren[0].toPlainText(), "Ƀiădah ƀing mơnuih ");
    expect(textSpanChildren[1].toPlainText(), "anun");
    expect(textSpanChildren[2].toPlainText(), " ƀu hmư̌ ôh ");
    expect(textSpanChildren[3].toPlainText(), "pô");
    expect(textSpanChildren[4].toPlainText(), " tha; yua ");
    expect(textSpanChildren[5].toPlainText(), "anun");
    expect(textSpanChildren[6].toPlainText(), " ");
    expect(textSpanChildren[7].toPlainText(), "pô");
    expect(textSpanChildren[8].toPlainText(), " đah rơkơi ");
    expect(textSpanChildren[9].toPlainText(), "anun");
    expect(textSpanChildren[10].toPlainText(), " mơ mă bơnai hơjung ñu ba ");
    expect(textSpanChildren[11].toPlainText(), "pơ");
    expect(textSpanChildren[12].toPlainText(), " gah rơngiao brơi kơ ƀing ");
    expect(textSpanChildren[13].toPlainText(), "anun");
    expect(textSpanChildren[14].toPlainText(), ", ƀing ");
    expect(textSpanChildren[15].toPlainText(), "anun");
    expect(textSpanChildren[16].toPlainText(), " thâo ");
    expect(textSpanChildren[17].toPlainText(), "pô");
    expect(textSpanChildren[18].toPlainText(),
        " bơnai hăng kơtư̌ ñu abih mlam truh ");
    expect(textSpanChildren[19].toPlainText(), "pơ");
    expect(textSpanChildren[20].toPlainText(),
        " mơguah; hăng lơm tơgǔ sing bring, gơñu mơ lui bơnai ");
    expect(textSpanChildren[21].toPlainText(), "anun");
    expect(textSpanChildren[22].toPlainText(), " nao.");
  });

  testWidgets(
      'Text lumine has correct TextSpans with highlighted unicode words with combining characters',
      (tester) async {
    const text =
        "Ƀiădah ƀing mơnuih anun ƀu hmư̌ ôh pô tha; yua anun pô đah rơkơi anun mơ mă bơnai hơjung ñu ba pơ gah rơngiao brơi kơ ƀing anun, ƀing anun thâo pô bơnai hăng kơtư̌ ñu abih mlam truh pơ mơguah; hăng lơm tơgǔ sing bring, gơñu mơ lui bơnai anun nao.";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["anun", "pô"],
            ignoreDiacritics: false,
            ignoreCase: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 19);

    expect(textSpanChildren[0].toPlainText(), "Ƀiădah ƀing mơnuih ");
    expect(textSpanChildren[1].toPlainText(), "anun");
    expect(textSpanChildren[2].toPlainText(), " ƀu hmư̌ ôh ");
    expect(textSpanChildren[3].toPlainText(), "pô");
    expect(textSpanChildren[4].toPlainText(), " tha; yua ");
    expect(textSpanChildren[5].toPlainText(), "anun");
    expect(textSpanChildren[6].toPlainText(), " ");
    expect(textSpanChildren[7].toPlainText(), "pô");
    expect(textSpanChildren[8].toPlainText(), " đah rơkơi ");
    expect(textSpanChildren[9].toPlainText(), "anun");
    expect(textSpanChildren[10].toPlainText(),
        " mơ mă bơnai hơjung ñu ba pơ gah rơngiao brơi kơ ƀing ");
    expect(textSpanChildren[11].toPlainText(), "anun");
    expect(textSpanChildren[12].toPlainText(), ", ƀing ");
    expect(textSpanChildren[13].toPlainText(), "anun");
    expect(textSpanChildren[14].toPlainText(), " thâo ");
    expect(textSpanChildren[15].toPlainText(), "pô");
    expect(textSpanChildren[16].toPlainText(),
        " bơnai hăng kơtư̌ ñu abih mlam truh pơ mơguah; hăng lơm tơgǔ sing bring, gơñu mơ lui bơnai ");
    expect(textSpanChildren[17].toPlainText(), "anun");
    expect(textSpanChildren[18].toPlainText(), " nao.");
  });

  testWidgets(
      'Text lumine has correct TextSpans with a highlighted unicode word with combining characters, ignore diacritics',
      (tester) async {
    const text =
        "Ƀiădah ƀing mơnuih anun ƀu hmư̌ ôh pô tha; yua anun pô đah rơkơi anun mơ mă bơnai hơjung ñu ba pơ gah rơngiao brơi kơ ƀing anun, ƀing anun thâo pô bơnai hăng kơtư̌ ñu abih mlam truh pơ mơguah; hăng lơm tơgǔ sing bring, gơñu mơ lui bơnai anun nao.";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["hmư̌"],
            ignoreDiacritics: true,
            ignoreCase: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 3);

    expect(textSpanChildren[0].toPlainText(), "Ƀiădah ƀing mơnuih anun ƀu ");
    expect(textSpanChildren[1].toPlainText(), "hmư̌");
    expect(textSpanChildren[2].toPlainText(),
        " ôh pô tha; yua anun pô đah rơkơi anun mơ mă bơnai hơjung ñu ba pơ gah rơngiao brơi kơ ƀing anun, ƀing anun thâo pô bơnai hăng kơtư̌ ñu abih mlam truh pơ mơguah; hăng lơm tơgǔ sing bring, gơñu mơ lui bơnai anun nao.");
  });

  testWidgets(
      'Text lumine has correct TextSpans with a highlighted unicode word with reserved characters, ignore diacritics',
      (tester) async {
    const text = "Ƀơi anun ñu pơdǒng hơnum kơ yang hrơi.";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["ƀơi", "Ñu pơdǒng"],
            ignoreDiacritics: true,
            ignoreCase: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 4);

    expect(textSpanChildren[0].toPlainText(), "Ƀơi");
    expect(textSpanChildren[1].toPlainText(), " anun ");
    expect(textSpanChildren[2].toPlainText(), "ñu pơdǒng");
    expect(textSpanChildren[3].toPlainText(), " hơnum kơ yang hrơi.");
  });

  testWidgets(
      'Text lumine has correct TextSpans with a highlighted unicode word with reserved characters',
      (tester) async {
    const text = "Ƀơi anun ñu pơdǒng hơnum kơ yang hrơi.";

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TextLumine.withHighlightedSubstrings(text,
            substrings: const ["ƀơi", "Ñu pơdǒng"],
            ignoreDiacritics: false,
            ignoreCase: true)));

    // Get rich text.
    final richTextFinder = find.text(text, findRichText: true);
    final richText = richTextFinder.evaluate().single.widget as RichText;
    final mainTextSpan = richText.text as TextSpan;
    final textSpanChildren = mainTextSpan.children!;

    expect(textSpanChildren, isNotNull);
    expect(textSpanChildren.length, 4);

    expect(textSpanChildren[0].toPlainText(), "Ƀơi");
    expect(textSpanChildren[1].toPlainText(), " anun ");
    expect(textSpanChildren[2].toPlainText(), "ñu pơdǒng");
    expect(textSpanChildren[3].toPlainText(), " hơnum kơ yang hrơi.");
  });
}
