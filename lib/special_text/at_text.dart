import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AtText extends SpecialText {
  AtText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,
      {required this.text,
      this.showAtBackground = false,
      this.start,
      this.id,
      this.end})
      : super(flag, '\t', textStyle, onTap: onTap);
  static const String flag = '@';
  int? start;
  int? end;
  final int? id;
  final String text;

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  InlineSpan finishText() {
    final TextStyle? textStyle =
        this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);

    final String atText = toString();

    return showAtBackground
        ? BackgroundTextSpan(
            background: Paint()..color = Colors.blue.withOpacity(0.15),
            text: atText,
            actualText: atText,
            start: start!,

            ///caret can move into special text
            deleteAll: true,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) {
                  onTap!(atText);
                }
              }))
        : SpecialTextSpan(
            text: atText,
            actualText: atText,
            start: start!,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) {
                  onTap!(atText);
                }
              }));
  }
}

class AtImage extends ExtendedWidgetSpan {
  AtImage({required super.child});

}
