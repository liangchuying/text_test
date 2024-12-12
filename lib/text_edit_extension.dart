import 'package:flutter/widgets.dart';

extension TextEditingControllerE on TextEditingController {
  /// Insert text at the current selection or replace the current selection with
  void insertText(String text) {
    final TextEditingValue value = this.value;
    // 光标的位置的起始位置
    final int start = value.selection.baseOffset;
    // 光标的位置的末尾位置
    int end = value.selection.extentOffset;
    // 文本位置是否有效
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      this.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      this.value = TextEditingValue(
          text: text,
          selection:
          TextSelection.fromPosition(TextPosition(offset: text.length)));
    }

    // SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
    //   _key.currentState?.bringIntoView(_textEditingController.selection.base);
    // });
  }

  /// Delete the character before the current selection or delete the current selection
  void delete() {
    final TextEditingValue value = deleteText();

    // final TextSpan oldTextSpan = _mySpecialTextSpanBuilder.build(_value.text);

    // value = ExtendedTextLibraryUtils.handleSpecialTextSpanDelete(
    //   value,
    //   _value,
    //   oldTextSpan,
    //   null,
    // );
    this.value = value;
  }

  /// Delete the character before the current selection or delete the current selection
  /// and handle the TextEditingValue base on your case
  TextEditingValue deleteText() {
    // delete by code
    TextEditingValue value = this.value;
    final TextSelection selection = value.selection;
    if (!selection.isValid) {
      return value;
    }
    if (selection.isCollapsed && selection.start == 0) {
      return value;
    }
    final String actualText = value.text;

    final int start =
    selection.isCollapsed ? selection.start - 1 : selection.start;
    final int end = selection.end;
    // improve the case of emoji
    // https://github.com/dart-lang/sdk/issues/35798
    final CharacterRange characterRange =
    CharacterRange.at(actualText, start, end);
    value = TextEditingValue(
      text: characterRange.stringBefore + characterRange.stringAfter,
      selection:
      TextSelection.collapsed(offset: characterRange.stringBefore.length),
    );

    return value;
  }
}
